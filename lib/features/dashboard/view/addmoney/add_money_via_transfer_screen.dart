import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class AddMoneyTransferScreen extends StatefulWidget {
  const AddMoneyTransferScreen({super.key});

  @override
  State<AddMoneyTransferScreen> createState() => _AddMoneyTransferScreenState();
}

class _AddMoneyTransferScreenState extends State<AddMoneyTransferScreen> {
  void _copyToClipboard(String label, String value) {
    // TODO: implement Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$label copied to clipboard")));
  }

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
          "Bank Transfer",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
        ),
      ),
      body: Padding(
        padding: ResponsiveUtils.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Card
            Container(
              padding: ResponsiveUtils.paddingAll16,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveUtils.borderRadius12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tier 1",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: appTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Bank Name
                  _infoRow("Bank Name", "ValarPay"),

                  SizedBox(height: 12.h),

                  // Account Name
                  _infoRow("Account Name", "John Smith Emmy"),

                  SizedBox(height: 12.h),

                  // Account Number
                  _infoRow("Account Number", "0000000000"),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Share Details Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                onPressed: () {
                  // handle share details
                },
                icon: Icon(Icons.share, color: Colors.white, size: 18.sp),
                label: Text(
                  "Share Details",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Instructions Card
            Container(
              width: double.infinity,
              padding: ResponsiveUtils.paddingAll16,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveUtils.borderRadius12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fund your ValarPay wallet easily in three quick steps",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Step 1: Copy your unique ValarPay account number from the app.\n"
                    "Step 2: Open your mobile banking app and initiate a transfer.\n"
                    "Step 3: Send the desired amount, and your ValarPay wallet will be credited instantly.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Info row with copy action
  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.copy, size: 18.sp, color: Theme.of(context).iconTheme.color),
          onPressed: () => _copyToClipboard(label, value),
        ),
      ],
    );
  }
}