import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/platform_responsive.dart';
import 'package:valarpay/features/auth/widgets/need_help_modal.dart';

class BiometricLoginScreen extends StatelessWidget {
  const BiometricLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // make bg cover appbar area
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // transparent appbar
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
              'assets/images/authbg.jpg', // <-- replace with your asset
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay (black at bottom, transparent at top)
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
                          color: appTheme
                              .primaryColor, // Keep background color if desired
                          borderRadius: PlatformResponsive.circular(8),
                        ),
                        child: ClipRRect(
                          // Use ClipRRect to apply border radius to the image
                          borderRadius: PlatformResponsive.circular(8),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover, // Cover the container area
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

                  // User avatar/profile
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

                  // Welcome text
                  Text(
                    'Welcome back, Emmanuel',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'emmanuel@gmail.com',
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey[300]),
                  ),

                  SizedBox(height: 50.h),

                  // Fingerprint prompt
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
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

                  SizedBox(height: 50.h),

                  // Actions
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

                  // Securely encrypted
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
