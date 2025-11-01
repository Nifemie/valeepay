import 'package:flutter/material.dart';
import 'package:valarpay/core/services/biometric_auth_service.dart';
import 'package:valarpay/core/services/local_storage_service.dart';
import 'package:valarpay/core/services/secure_storage_service.dart';
import 'package:valarpay/core/services/biometric_transaction_tracker.dart';
import 'package:valarpay/core/utils/device_utils.dart';
import 'package:valarpay/core/constants/enums/enums.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';

class BiometricTransactionPinModal {
  /// Show biometric transaction PIN modal
  /// Returns the wallet PIN if successful, null if cancelled
  static Future<String?> show(BuildContext context) async {
    // Check if biometric is enabled for transactions
    final fingerprintEnabled = await LocalStorageService.getBool('pref_transaction_fingerprint') ?? false;
    final faceIdEnabled = await LocalStorageService.getBool('pref_transaction_faceid') ?? false;
    
    final biometricEnabled = fingerprintEnabled || faceIdEnabled;
    
    if (!biometricEnabled) {
      // No biometric enabled, show regular PIN modal
      return await TransactionPinModal.show(context);
    }
    
    // Check if biometric is enabled for this device
    final currentDeviceId = await DeviceUtils.getDeviceId();
    final isEnabledForDevice = await SecureStorageService.isTransactionBiometricEnabledForDevice(currentDeviceId);
    
    if (!isEnabledForDevice) {
      // Biometric not enabled for this device, show regular PIN modal
      return await TransactionPinModal.show(context);
    }
    
    // Check if wallet PIN is stored
    final hasStoredPin = await SecureStorageService.hasWalletPin();
    if (!hasStoredPin) {
      // No stored PIN, show regular PIN modal
      return await TransactionPinModal.show(context);
    }
    
    // Show PIN modal first, then trigger biometric on top
    return await _showPinModalWithBiometric(context);
  }
  
  /// Show PIN modal with biometric prompt on top
  static Future<String?> _showPinModalWithBiometric(BuildContext context) async {
    // Show the PIN modal
    final pinModalFuture = TransactionPinModal.show(context);
    
    // Wait a bit for the PIN modal to appear
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Trigger biometric authentication
    BiometricTransactionTracker.startTransactionBiometric();
    
    final biometricResult = await BiometricAuthService.authenticateWithFallback(
      promptMessage: 'Authenticate to authorize transaction',
    );
    
    BiometricTransactionTracker.endTransactionBiometric();
    
    if (biometricResult == BiometricAuthResult.success) {
      // Get stored wallet PIN
      final storedPin = await SecureStorageService.getWalletPin();
      print('🔐 [BiometricModal] Retrieved stored PIN: ${storedPin != null ? "****" : "null"}, length: ${storedPin?.length}');
      
      if (storedPin != null && storedPin.length == 4) {
        print('🔐 [BiometricModal] PIN format check: starts with "${storedPin[0]}", ends with "${storedPin[3]}"');
      }
      
      if (storedPin != null) {
        print('🔐 [BiometricModal] Biometric success, closing PIN modal and returning stored PIN');
        // Close the PIN modal
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        return storedPin;
      }
    }
    
    // If biometric failed or was cancelled, let user enter PIN manually
    print('🔐 [BiometricModal] Biometric failed/cancelled, waiting for manual PIN entry');
    return await pinModalFuture;
  }
  
}

class _BiometricTransactionDialog extends StatefulWidget {
  @override
  _BiometricTransactionDialogState createState() => _BiometricTransactionDialogState();
}

class _BiometricTransactionDialogState extends State<_BiometricTransactionDialog> {
  bool _isAuthenticating = false;
  bool _showFallback = false;

  Future<void> _authenticateWithBiometric() async {
    if (!mounted) return;
    
    setState(() {
      _isAuthenticating = true;
    });
    
    // Mark that transaction biometric is starting
    BiometricTransactionTracker.startTransactionBiometric();
    
    try {
      final result = await BiometricAuthService.authenticateWithFallback(
        promptMessage: 'Authenticate to authorize transaction',
      );
      
      // Clear the flag after biometric completes
      BiometricTransactionTracker.endTransactionBiometric();
      
      if (!mounted) return;
      
      setState(() {
        _isAuthenticating = false;
      });
      
      if (result == BiometricAuthResult.success) {
        // Get stored wallet PIN
        final storedPin = await SecureStorageService.getWalletPin();
        print('🔐 [BiometricModal] Retrieved stored PIN: ${storedPin != null ? "****" : "null"}, length: ${storedPin?.length}');
        
        if (storedPin != null && storedPin.length == 4) {
          print('🔐 [BiometricModal] PIN format check: starts with "${storedPin[0]}", ends with "${storedPin[3]}"');
        }
        
        if (storedPin != null && mounted) {
          print('🔐 [BiometricModal] Returning stored PIN to caller');
          Navigator.of(context).pop(storedPin);
        } else if (mounted) {
          // Stored PIN not found, show fallback
          print('⚠️ [BiometricModal] No stored PIN found, showing fallback');
          setState(() {
            _showFallback = true;
          });
        }
      } else if (result == BiometricAuthResult.fallback) {
        // User chose to use PIN instead
        if (mounted) {
          setState(() {
            _showFallback = true;
          });
        }
      } else {
        // Authentication failed or cancelled
        if (mounted) {
          Navigator.of(context).pop(null);
        }
      }
    } catch (e) {
      // Clear flag on error
      BiometricTransactionTracker.endTransactionBiometric();
      
      if (!mounted) return;
      
      setState(() {
        _isAuthenticating = false;
      });
      
      // Close modal on error
      Navigator.of(context).pop(null);
    }
  }
  
  Future<void> _showPinFallback() async {
    if (!mounted) return;
    
    // Close biometric dialog and return a special value to indicate fallback
    Navigator.of(context).pop('__FALLBACK__');
  }
  
  @override
  Widget build(BuildContext context) {
    if (_showFallback) {
      // Close this dialog and trigger fallback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPinFallback();
      });
      return Container(); // Empty container while transitioning
    }
    
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Biometric Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF76301).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fingerprint,
                size: 40,
                color: Color(0xFFF76301),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              _isAuthenticating ? 'Authenticating...' : 'Authorize Transaction',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              _isAuthenticating 
                  ? 'Please wait while we verify your identity'
                  : 'Use your fingerprint or Face ID to authorize this transaction',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            if (!_isAuthenticating) ...[
              // Main Authenticate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _authenticateWithBiometric,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF76301),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Authenticate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Use PIN Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showFallback = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Use PIN Instead',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Cancel Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ] else ...[
              // Show loading indicator when authenticating
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF76301)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
