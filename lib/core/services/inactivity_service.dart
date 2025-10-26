import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/services/local_storage_service.dart';
import 'package:valarpay/core/services/session_service.dart';

class InactivityService {
  static Timer? _inactivityTimer;
  static DateTime? _lastActivityTime;
  static bool _isActive = false;
  static const String _lastActivityKey = 'last_activity_timestamp';

  /// Start monitoring user inactivity
  static void startMonitoring(BuildContext context) async {
    if (_isActive) return;
    _isActive = true;
    _lastActivityTime = DateTime.now();
    await _saveLastActivityTime();
    _scheduleInactivityCheck(context);
    
    print('🔔 [InactivityService] Started monitoring');
    final setting = await LocalStorageService.get('auto_logout_setting');
    print('🔔 [InactivityService] Current setting: $setting');
  }

  /// Stop monitoring (when user logs out)
  static void stopMonitoring() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    _lastActivityTime = null;
    _isActive = false;
    print('🔔 [InactivityService] Stopped monitoring');
  }

  /// Record user activity
  static void recordActivity() async {
    _lastActivityTime = DateTime.now();
    await _saveLastActivityTime();
  }

  /// Save last activity time to storage
  static Future<void> _saveLastActivityTime() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    await LocalStorageService.save(_lastActivityKey, timestamp);
  }

  /// Get last activity time from storage
  static Future<DateTime?> _getLastActivityTime() async {
    final timestamp = await LocalStorageService.get(_lastActivityKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  }

  /// Get timeout duration based on user settings
  static Future<Duration?> _getTimeoutDuration() async {
    final setting = await LocalStorageService.get('auto_logout_setting');
    
    print('🔔 [InactivityService] Getting timeout for setting: $setting');
    
    switch (setting) {
      case 'Password Free Log in':
        print('🔔 [InactivityService] No timeout - Password Free');
        return null; // No timeout
      case '60 Minutes Password Free Log in':
        print('🔔 [InactivityService] Timeout: 60 minutes');
        return const Duration(minutes: 60);
      case 'Always Require Password to Log in':
        print('🔔 [InactivityService] No timeout - Only logout on app background');
        return null; // Don't auto-logout while using app, only on app resume
      default:
        print('🔔 [InactivityService] Timeout: Default 60 minutes');
        return const Duration(minutes: 60); // Default
    }
  }

  /// Check if user should be logged out
  static void _scheduleInactivityCheck(BuildContext context) {
    _inactivityTimer?.cancel();
    
    _inactivityTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final timeout = await _getTimeoutDuration();
      
      // No timeout means password-free login
      if (timeout == null) {
        print('🔔 [InactivityService] No timeout check - Password Free mode');
        return;
      }

      final now = DateTime.now();
      final lastActivity = _lastActivityTime ?? now;
      final inactiveDuration = now.difference(lastActivity);

      print('🔔 [InactivityService] Inactive for: ${inactiveDuration.inMinutes} minutes');

      if (inactiveDuration >= timeout) {
        print('⚠️ [InactivityService] Timeout reached! Logging out...');
        timer.cancel();
        await _handleAutoLogout(context);
      }
    });
  }

  /// Handle auto-logout
  static Future<void> _handleAutoLogout(BuildContext context) async {
    print('🚪 [InactivityService] Handling auto-logout');
    stopMonitoring();
    
    final setting = await LocalStorageService.get('auto_logout_setting');
    
    // Logout user but keep biometric credentials for quick re-login
    if (setting == 'Always Require Password to Log in') {
      print('🚪 [InactivityService] Clearing session (Always Require Password mode)');
      await SessionService.logout();
    } else {
      print('🚪 [InactivityService] Keeping session (60 min mode)');
    }
    
    if (context.mounted) {
      // Navigate to biometric login if available, otherwise signin
      final hasBiometric = await LocalStorageService.getBool('pref_biometric_fingerprint') ?? false;
      final hasFaceId = await LocalStorageService.getBool('pref_biometric_faceid') ?? false;
      
      if (hasBiometric || hasFaceId) {
        print('🚪 [InactivityService] Redirecting to biometric login');
        context.go('/biometric-login');
      } else {
        print('🚪 [InactivityService] Redirecting to signin');
        context.go('/signin');
      }
    }
  }

  /// Check if user should be logged out on app resume
  static Future<bool> shouldLogoutOnResume() async {
    final setting = await LocalStorageService.get('auto_logout_setting');
    
    print('🔄 [InactivityService] Checking logout on resume. Setting: $setting');
    
    // Password Free - never logout
    if (setting == 'Password Free Log in' || setting == null) {
      print('🔄 [InactivityService] Password Free mode - No logout');
      return false;
    }
    
    // Always Require Password - always logout
    if (setting == 'Always Require Password to Log in') {
      print('🔄 [InactivityService] Always Require Password - Logout required');
      return true;
    }
    
    // 60 Minutes - check if timeout exceeded
    final lastActivity = await _getLastActivityTime();
    if (lastActivity == null) {
      print('🔄 [InactivityService] No last activity found');
      return false;
    }
    
    final now = DateTime.now();
    final inactiveDuration = now.difference(lastActivity);
    final shouldLogout = inactiveDuration >= const Duration(minutes: 60);
    
    print('🔄 [InactivityService] Inactive for: ${inactiveDuration.inMinutes} minutes. Logout: $shouldLogout');
    
    return shouldLogout;
  }

  /// Check if auto-logout is enabled
  static Future<bool> isEnabled() async {
    final setting = await LocalStorageService.get('auto_logout_setting');
    return setting != 'Password Free Log in';
  }
}
