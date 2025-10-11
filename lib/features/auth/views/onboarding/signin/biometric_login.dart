import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/services/biometric_auth_service.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/platform_responsive.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/services/session_service.dart';
import 'package:valarpay/core/utils/device_utils.dart';
import 'package:valarpay/features/notifiers/auth_notifier.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/auth/widgets/need_help_modal.dart';

class BiometricLoginScreen extends ConsumerStatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  ConsumerState<BiometricLoginScreen> createState() =>
      _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends ConsumerState<BiometricLoginScreen> {
  String? _email;
  String? _fullname;

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final userFullName = await SessionService.getUserFullname();
    final username = await SessionService.getUsername();
    
    if (userFullName != null && username != null) {
      setState(() {
        _email = username;
        _fullname = userFullName;
      });
    } else {
      final savedUsername = await SessionService.getUsername();
      setState(() {
        _email = savedUsername;
        _fullname = 'User';
      });
    }
  }

  Future<void> _handleBiometricLogin(
      BuildContext context, WidgetRef ref) async {
    final success = await BiometricAuthService.authenticate();

    if (!success) {
      AppMessenger.show(
        context,
        message: 'Biometric authentication failed or cancelled.',
        type: MessageType.error,
      );
      return;
    }

    final ip = await DeviceUtils.getIpAddress();
    final deviceName = await DeviceUtils.getDeviceName();
    final os = await DeviceUtils.getDeviceOS();
    final savedUsername = _email ?? await SessionService.getUsername();

    if (savedUsername == null) {
      AppMessenger.show(
        context,
        message: 'No saved user session found. Please login manually.',
        type: MessageType.warning,
      );
      context.push('/signin');
      return;
    }

    final request = PasscodeLoginRequest(
      email: savedUsername,
      passcode: '', // biometric bypass
      ipAddress: ip,
      deviceName: deviceName,
      operatingSystem: os,
    );

    final notifier = ref.read(authNotifierProvider.notifier);
    await notifier.loginWithPasscode(request);
    final state = ref.read(authNotifierProvider);

    if (state.isDataAvailable) {
      final user = state.data?.first;
      await SessionService.saveSession(
        LoginResponse(
          message: state.message ?? '',
          user: user!,
          statusCode: 200,
        ),
      );

      AppMessenger.show(
        context,
        message: 'Welcome back, ${user.fullname}',
        type: MessageType.success,
      );
      context.pushReplacement('/');
    } else {
      AppMessenger.show(
        context,
        message: state.message ?? 'Unable to authenticate.',
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
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/authbg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay
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

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
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
                            width: 40.rw,
                            height: 40.rh,
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

                  // User avatar
                  CircleAvatar(
                    radius: 45.r,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Welcome text (dynamic)
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
                    _email ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey[300],
                    ),
                  ),

                  SizedBox(height: 50.h),

                  // Fingerprint section (tap triggers auth)
                  GestureDetector(
                    onTap: () => _handleBiometricLogin(context, ref),
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

                  // Login with Passcode
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

                  // Switch account
                  GestureDetector(
                    onTap: () async {
                      await SessionService.reset();
                      context.push('/signin');
                    },
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

                  // Securely encrypted info
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
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
