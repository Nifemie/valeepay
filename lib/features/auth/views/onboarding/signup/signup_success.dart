import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class SignupSuccessScreen extends StatelessWidget {
  final String firstName;
  const SignupSuccessScreen({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ prevents vertical overflow
          padding: EdgeInsets.all(24.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // ✅ Success Icon
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 60.sp),
                  ),

                  SizedBox(height: 48.h),

                  // ✅ Success Message with auto-wrap
                  Text(
                    "Congratulations, $firstName!\nYou've successfully created your account",
                    style: TextStyle(
                      fontSize: 22.sp, // responsive
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 3),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/signin'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Proceed to Login',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
