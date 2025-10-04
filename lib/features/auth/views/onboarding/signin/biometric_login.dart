import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/auth/widgets/need_help_modal.dart';

class BiometricLoginScreen extends StatelessWidget {
  const BiometricLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:appTheme.whiteColor,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand / Logo
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: appTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Valarpay',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              // User avatar/profile
              CircleAvatar(
                radius: 45.r,
                backgroundColor: appTheme.primaryColor.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: 18.h),

              // Welcome text
              Text(
                'Welcome back, Emmanuel',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '900*0000000000',
                style: TextStyle(fontSize: 15.sp, color: Colors.grey[600]),
              ),

              SizedBox(height: 50.h),

              // Fingerprint prompt
              Column(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/verify-fingerprint'),
                    child: Container(
                      width: 90.w,
                      height: 90.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
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
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              const Spacer(),
              SizedBox(height: 20),

              // Actions
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/signin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Login with Password',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/passcode-login'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Login with Passcode',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
                    color: appTheme.primaryColor,
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
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Securely encrypted',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
