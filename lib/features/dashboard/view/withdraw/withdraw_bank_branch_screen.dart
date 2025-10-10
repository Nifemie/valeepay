import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class WithdrawBankBranchScreen extends StatefulWidget {
  const WithdrawBankBranchScreen({super.key});

  @override
  State<WithdrawBankBranchScreen> createState() =>
      _WithdrawBankBranchScreenState();
}

class _WithdrawBankBranchScreenState extends State<WithdrawBankBranchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Withdraw via Bank Branch",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        child: Column(
          children: [
            // Illustration / Image
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/bank.png", // replace with your actual illustration asset
                  height: 200.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Title
            Text(
              "Withdraw via Bank Branch",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),

            // Subtitle / Description
            Text(
              "Visit any bank branch to access your ValarPay account and withdraw your cash easily",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30.h),

            // Locate Nearest Branch Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                onPressed: () {
                  // TODO: implement nearest branch logic
                },
                child: Text(
                  "Locate Nearest Branch",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}