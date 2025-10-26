import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valarpay/core/constants/enums/enums.dart';
import 'package:valarpay/core/services/biometric_auth_service.dart';
import 'package:valarpay/core/services/local_storage_service.dart';
import 'package:valarpay/core/services/secure_storage_service.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/platform_responsive.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/device_utils.dart';
import 'package:valarpay/core/services/session_service.dart';
import 'package:valarpay/features/auth/widgets/need_help_modal.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/notifiers/auth_notifier.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class BiometricLoginScreen extends ConsumerStatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  ConsumerState<BiometricLoginScreen> createState() =>
      _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends ConsumerState<BiometricLoginScreen> {
  String? _username;
  String? _phoneNumber;
  String? _profileImageUrl;
  bool _isLoading=false;


  @override
  void initState() {
    super.initState();
    _loadUserSession();

    // Automatically trigger biometric authentication when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestBiometricAndCameraPermissions();
    });
  }

  Future<void> _loadUserSession() async {
    final user = await SessionService.getUser();
    final savedUsername = await SessionService.getActualUsername();
    final savedFullname = await SessionService.getUserFullname();
    final savedPhoneNumber = await SessionService.getPhoneNumber();
    

    setState(() {
      // Use actual username for display (not email)
      _username = user?.username ?? savedUsername ?? 'User';
      _fullname = user?.fullname ?? savedFullname ?? 'User';
      _phoneNumber = user?.phoneNumber ?? savedPhoneNumber ?? '';
      _profileImageUrl = user?.profileImageUrl;
    });
  }

  /// Mask phone number to show only first 3 and last 3 digits
  String _maskPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return ''; // Return empty string instead of "Loading..."
    }
  
    if (phone == 'N/A') {
      return '';
    }

    if (phone.length <= 6) {
      return phone; // Too short to mask
    }


    final first3 = phone.substring(0, 3);
    final last3 = phone.substring(phone.length - 3);
    final maskedMiddle = '*' * (phone.length - 6);


    return '$first3$maskedMiddle$last3';
  }

  /// 🔒 Core login handler after biometric succeeds
  Future<void> _handleBiometricLogin(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      // Verify device ID first
      final currentDeviceId = await DeviceUtils.getDeviceId();
      final isBiometricEnabledForDevice = await SecureStorageService.isBiometricEnabledForDevice(currentDeviceId);
      
      if (!isBiometricEnabledForDevice) {
        if (!context.mounted) return;
        AppMessenger.show(
          context,
          message: 'Biometric login not enabled on this device. Please login with password first.',
          type: MessageType.warning,
        );
        context.go('/signin');
        return;
      }
      
      final storedPasscode = await SecureStorageService.getPasscode();
      final storedUsername = await SecureStorageService.getUsername();

      print(
          '🔐 [BiometricLogin] Has stored passcode: ${storedPasscode != null}');
      print(
          '🔐 [BiometricLogin] Has stored username: ${storedUsername != null}');

      if (storedPasscode != null && storedUsername != null) {
        // Use passcode login API
        print('🔐 [BiometricLogin] Logging in with stored passcode...');

        final ip = await DeviceUtils.getIpAddress();
        final deviceName = await DeviceUtils.getDeviceName();
        final os = await DeviceUtils.getDeviceOS();

        final request = PasscodeLoginRequest(
          username: storedUsername,
          passcode: storedPasscode,
          ipAddress: ip,
          deviceName: deviceName,
          operatingSystem: os,
        );

        final notifier = ref.read(authNotifierProvider.notifier);
        await notifier.loginWithPasscode(request);
        final state = ref.read(authNotifierProvider);

        if (state.isDataAvailable && state.data != null && mounted) {
          final loginResponse = state.data!.first;

          // Save session
          await SessionService.saveSession(loginResponse);

          // Refresh user profile
          final freshUser = await ref
              .read(userNotifierProvider.notifier)
              .refreshUserProfile();
          if (freshUser != null) {
            ref.read(userProvider.notifier).setUser(freshUser);
          } else {
            ref.read(userProvider.notifier).setUser(loginResponse.user);
          }

          AppMessenger.show(
            context,
            message: 'Welcome back, ${loginResponse.user.fullname}',
            type: MessageType.success,
          );
          context.go('/');
        } else {
          if (!context.mounted) return;
          AppMessenger.show(
            context,
            message: state.message ?? 'Login failed. Please try again',
            type: MessageType.error,
          );
          context.go('/signin');
        }
      } else {
        // Fallback to session-based login
        print('🔐 [BiometricLogin] No stored passcode, checking session...');
        final userAccessToken = await SessionService.getAccessToken();


        if (userAccessToken == null) {
          if (!context.mounted) return;
          AppMessenger.show(
            context,
            message: 'Session expired. Please login with your password',
            type: MessageType.warning,
          );
          context.go('/signin');
          return;
        }

        final user = await SessionService.getUser();
        if (user != null) {
          ref.read(userProvider.notifier).setUser(user);
          if (!context.mounted) return;
          AppMessenger.show(
            context,
            message: 'Welcome back, ${user.fullname}',
            type: MessageType.success,
          );
          context.go('/');
        } else {
          if (!context.mounted) return;
          AppMessenger.show(
            context,
            message: 'Session expired. Please login with your password',
            type: MessageType.warning,
          );
          context.go('/signin');
        }
      }
    } catch (e) {
      print('🔐 [BiometricLogin] Exception: $e');
      if (!context.mounted) return;
      AppMessenger.show(
        context,
        message: 'An error occurred: ${e.toString()}',
        type: MessageType.error,
      );
    }
  }

  /// Trigger biometric authentication directly
  Future<void> _triggerBiometricAuth(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final result = await BiometricAuthService.authenticateWithFallback(
      promptMessage: 'Authenticate with Fingerprint or Face ID',
    );

    if (!context.mounted) return;

    // Handle navigation based on result
    if (result == BiometricAuthResult.success) {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });
      
      await _handleBiometricLogin(context, ref);
      
      // Hide loading indicator (in case navigation fails)
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (result == BiometricAuthResult.fallback) {
      context.go('/passcode-login');
    } else {
      AppMessenger.show(
        context,
        message: 'Biometric authentication failed or cancelled.',
        type: MessageType.error,
      );
    }
  }

  /// Request biometric (Face ID / Fingerprint) and camera permission
  Future<void> _requestBiometricAndCameraPermissions() async {
    try {
      // Check if user has enabled biometrics in settings
      final fpEnabled = await LocalStorageService.getBool(
        'pref_biometric_fingerprint',
      );
      final faceEnabled = await LocalStorageService.getBool(
        'pref_biometric_faceid',
      );
      if ((fpEnabled ?? false) == false && (faceEnabled ?? false) == false) {
        if (!mounted) return;
        AppMessenger.show(
          context,
          message:
              'Biometric login is not enabled. Please enable it in settings.',
          type: MessageType.warning,
        );
        context.push('/signin');
        return;
      }

      // Request camera permission
      final cameraStatus = await Permission.camera.request();

      // Request biometric permission (Android-specific)
      final biometricStatus = await Permission.sensors.request();

      // Check biometric availability using local_auth
      final localAuth = LocalAuthentication();
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      final isDeviceSupported = await localAuth.isDeviceSupported();

      if (!mounted) return;

      if (cameraStatus.isGranted && canCheckBiometrics && isDeviceSupported ||
          canCheckBiometrics && isDeviceSupported) {
        _triggerBiometricAuth(context, ref);
      } else if (!cameraStatus.isGranted) {
        AppMessenger.show(
          context,
          message: 'Camera permission is required for face verification',
          type: MessageType.error,
        );
      } else if (!biometricStatus.isGranted || !canCheckBiometrics) {
        AppMessenger.show(
          context,
          message: 'Unable to check available biometrics',
          type: MessageType.error,
        );
      } else {
        AppMessenger.show(
          context,
          message:
              'Device biometrics not configured. Please set up Face ID or Fingerprint.',
          type: MessageType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppMessenger.show(
        context,
        message: 'Failed to request permissions: ${e.toString()}',
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.go('/signin'),
          icon: const Icon(Icons.arrow_back, color: appTheme.darkColor),
        ),
        actions: [
          TextButton(
            onPressed: () => NeedHelpModal.show(context),
            child: const Text(
              'Need Help?',
              style: TextStyle(
                color: appTheme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/authbg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50.rw,
                        height: 50.rh,
                        decoration: BoxDecoration(
                          color: appTheme.primaryColor,
                          borderRadius: PlatformResponsive.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: PlatformResponsive.circular(8),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            width: 50.rw,
                            height: 50.rh,
                          ),
                        ),
                      ),
                      PlatformResponsive.sizedBoxW(12),
                      Text(
                        'ValarPay',
                        style: TextStyle(
                          fontSize: 24.rsp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  CircleAvatar(
                    radius: 45.r,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: ClipOval(
                      child: _profileImageUrl != null &&
                              _profileImageUrl!.isNotEmpty
                          ? Image.network(
                              _profileImageUrl!,
                              width: 90.w,
                              height: 90.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: appTheme.primaryColor,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: appTheme.primaryColor,
                            ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Welcome back ${_username ?? 'User'}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _maskPhoneNumber(_phoneNumber),
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey[300]),
                  ),
                  SizedBox(height: 50.h),
                  _isLoading
                      ? Column(
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                appTheme.primaryColor,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Logging in...',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () => _requestBiometricAndCameraPermissions(),
                          child: Column(
                            children: [
                              Container(
                                width: 90.w,
                                height: 90.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.fingerprint,
                                  size: 50.sp,
                                  color: appTheme.primaryColor,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Text(
                                'Tap fingerprint to login',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 50.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/passcode-login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Login with Passcode',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  GestureDetector(
                    onTap: () => context.go('/signin'),
                    child: Text(
                      'Switch Account',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 16.sp,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Securely encrypted',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

