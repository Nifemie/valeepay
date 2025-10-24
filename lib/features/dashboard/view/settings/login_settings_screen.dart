import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/services/local_storage_service.dart';
import 'package:valarpay/core/services/biometric_auth_service.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/constants/enums/enums.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class LoginSettingsScreen extends ConsumerStatefulWidget {
  const LoginSettingsScreen({super.key});

  @override
  ConsumerState<LoginSettingsScreen> createState() =>
      _LoginSettingsScreenState();
}

class _LoginSettingsScreenState extends ConsumerState<LoginSettingsScreen> {
  static const _keyFingerprint = 'pref_biometric_fingerprint';
  static const _keyFaceId = 'pref_biometric_faceid';

  bool fingerprintEnabled = false;
  bool faceIdEnabled = false;
  bool logInWithFaceId = false;

  // Device capability flags
  bool hasFingerprintAvailable = false;
  bool hasFaceAvailable = false;
  bool canCheckBiometrics = false;

  final _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkDeviceBiometrics();
  }

  Future<void> _checkDeviceBiometrics() async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      bool fingerprint = false;
      bool face = false;

      // Some devices (Android 11+) may report BiometricType.strong
      // instead of fingerprint or face.
      for (final bio in availableBiometrics) {
        if (bio == BiometricType.fingerprint || bio == BiometricType.strong) {
          fingerprint = true;
        }
        if (bio == BiometricType.face) {
          face = true;
        }
      }

      setState(() {
        canCheckBiometrics = canCheck && isDeviceSupported;
        hasFingerprintAvailable = fingerprint;
        hasFaceAvailable = face;
      });
    } catch (e) {
      debugPrint('Biometric check failed: $e');
    }
  }

  Future<void> _loadPreferences() async {
    final fp = await LocalStorageService.getBool(_keyFingerprint);
    final face = await LocalStorageService.getBool(_keyFaceId);
    setState(() {
      fingerprintEnabled = fp ?? false;
      faceIdEnabled = face ?? false;
      logInWithFaceId = faceIdEnabled;
    });
  }

  Future<void> _saveFingerprintPref(bool value) async {
    await LocalStorageService.saveBool(_keyFingerprint, value);
  }

  Future<void> _saveFaceIdPref(bool value) async {
    await LocalStorageService.saveBool(_keyFaceId, value);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final bool hasPasscodeCodeSet = user?.isPasscodeSet ?? false;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Login Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              // Password Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => context.push('/change-password'),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Change Password',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => context.push('/forgot-password'),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Forgot Password',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        hasPasscodeCodeSet
                            ? context.push('/change-passcode')
                            : context.push('/create-passcode');
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              hasPasscodeCodeSet
                                  ? 'Change Passcode'
                                  : 'Create Passcode',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        context.push('/auto-logout-settings');
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Auto Logout Settings',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Biometrics Section
              Text(
                'Biometrics',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Log in with fingerprint',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Switch(
                          value: fingerprintEnabled,
                          onChanged: (value) async {
                            // If device doesn't support fingerprint, don't attempt to enable
                            if (value && !hasFingerprintAvailable) {
                              AppMessenger.show(
                                context,
                                message:
                                    'Fingerprint is not available on this device',
                                type: MessageType.warning,
                              );
                              return;
                            }

                            // require biometric verification before enabling/disabling
                            final result =
                                await BiometricAuthService.authenticateWithFallback(
                                  promptMessage:
                                      'Verify to change biometric setting',
                                );
                            if (result == BiometricAuthResult.success) {
                              setState(() {
                                fingerprintEnabled = value;
                              });
                              _saveFingerprintPref(value);
                            } else if (result == BiometricAuthResult.fallback) {
                              AppMessenger.show(
                                context,
                                message:
                                    'Biometrics not available. Please use your passcode to change settings',
                                type: MessageType.warning,
                              );
                            } else {
                              AppMessenger.show(
                                context,
                                message:
                                    'Authentication failed. Biometric setting unchanged',
                                type: MessageType.error,
                              );
                            }
                          },
                          activeTrackColor: appTheme.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Log in with Face ID',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Switch(
                          value: logInWithFaceId,
                          onChanged: (value) async {
                            // If enabling, ensure device has Face available
                            if (value && !hasFaceAvailable) {
                              AppMessenger.show(
                                context,
                                message:
                                    'Face ID is not available on this device',
                                type: MessageType.warning,
                              );
                              return;
                            }

                            final result =
                                await BiometricAuthService.authenticateWithFallback(
                                  promptMessage:
                                      'Verify to change biometric setting',
                                );
                            if (result == BiometricAuthResult.success) {
                              setState(() {
                                logInWithFaceId = value;
                                faceIdEnabled = value;
                              });
                              _saveFaceIdPref(value);
                            } else if (result == BiometricAuthResult.fallback) {
                              AppMessenger.show(
                                context,
                                message:
                                    'Biometrics not available. Please use your passcode to change settings',
                                type: MessageType.warning,
                              );
                            } else {
                              AppMessenger.show(
                                context,
                                message:
                                    'Authentication failed. Biometric setting unchanged',
                                type: MessageType.error,
                              );
                            }
                          },
                          activeTrackColor: appTheme.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
