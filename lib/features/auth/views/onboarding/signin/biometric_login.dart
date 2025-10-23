import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valarpay/core/constants/enums/enums.dart';
import 'package:valarpay/core/services/biometric_auth_service.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/platform_responsive.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/services/session_service.dart';
import 'package:valarpay/features/auth/widgets/need_help_modal.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class BiometricLoginScreen extends ConsumerStatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  ConsumerState<BiometricLoginScreen> createState() =>
      _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends ConsumerState<BiometricLoginScreen> {
  String? _username;
  String? _fullname;

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final userFullName = await SessionService.getUserFullname();
    final username = await SessionService.getUsername();

    setState(() {
      _username = username ?? 'N/A';
      _fullname = userFullName ?? 'User';
    });
  }

  /// 🔒 Core login handler after biometric succeeds
  Future<void> _handleBiometricLogin(
      BuildContext context, WidgetRef ref) async {
    try {
      final userAccessToken = await SessionService.getAccessToken();

      if (userAccessToken == null) {
        AppMessenger.show(
          context,
          message: 'Please login with your password',
          type: MessageType.warning,
        );
        context.push('/signin');
        return;
      }

      final user = await SessionService.getUser();
      if (user != null) {
        ref.read(userProvider.notifier).setUser(user);
        AppMessenger.show(
          context,
          message: 'Welcome back, ${user.fullname}',
          type: MessageType.success,
        );
        context.pushReplacement('/');
      } else {
        AppMessenger.show(
          context,
          message: 'Authentication failed, login with your password',
          type: MessageType.error,
        );
        context.push('/signin');
      }
    } catch (e) {
      AppMessenger.show(
        context,
        message: 'An error occurred: ${e.toString()}',
        type: MessageType.error,
      );
    }
  }

  Future<void> _showBiometricBottomSheet(
      BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        // start biometric auth right away
        Future.microtask(() async {
          final result = await BiometricAuthService.authenticateWithFallback(
            promptMessage: 'Authenticate with Fingerprint or Face ID',
          );

          if (result == BiometricAuthResult.success && ctx.mounted) {
            Navigator.pop(ctx);
            _handleBiometricLogin(context, ref);
          } else if (result == BiometricAuthResult.fallback && ctx.mounted) {
            Navigator.pop(ctx);
            context.push('/passcode-login');
          } else if (ctx.mounted) {
            Navigator.pop(ctx);
            AppMessenger.show(
              context,
              message: 'Biometric authentication failed or cancelled.',
              type: MessageType.error,
            );
          }
        });

        return SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint,
                  size: 60, color: appTheme.primaryColor),
              const SizedBox(height: 16),
              const Text(
                'Authenticate to continue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Use Face ID or Fingerprint',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 36),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Request biometric (Face ID / Fingerprint) and camera permission
  Future<void> _requestBiometricAndCameraPermissions() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();

      // Request biometric permission (Android-specific)
      final biometricStatus = await Permission.sensors.request();

      // Check biometric availability using local_auth
      final localAuth = LocalAuthentication();
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      final isDeviceSupported = await localAuth.isDeviceSupported();

      if (cameraStatus.isGranted &&
          biometricStatus.isGranted &&
          canCheckBiometrics &&
          isDeviceSupported) {
        _showBiometricBottomSheet(context, ref);
      } else if (!cameraStatus.isGranted) {
        AppMessenger.show(
          context,
          message: 'Camera permission is required for face verification',
          type: MessageType.error,
        );
      } else if (!biometricStatus.isGranted || !canCheckBiometrics) {
        AppMessenger.show(
          context,
          message:
              'Biometric (Face ID / Fingerprint) permission is required for verification',
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.push('/signin'),
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
                        width: 40.rw,
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
                        'Valarpay',
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
                    child:
                        const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Welcome back, ${_fullname ?? 'User'}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _username ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  GestureDetector(
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
                      onPressed: () => context.push('/passcode-login'),
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
                    onTap: () => context.push('/signin'),
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
                      Icon(Icons.shield_outlined,
                          size: 16.sp, color: Colors.white70),
                      SizedBox(width: 6.w),
                      Text(
                        'Securely encrypted',
                        style:
                            TextStyle(fontSize: 13.sp, color: Colors.white70),
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
