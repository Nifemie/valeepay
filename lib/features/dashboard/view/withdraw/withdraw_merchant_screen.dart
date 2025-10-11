import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class WithdrawMerchantScreen extends StatefulWidget {
  const WithdrawMerchantScreen({super.key});

  @override
  State<WithdrawMerchantScreen> createState() => _WithdrawMerchantScreenState();
}

class _WithdrawMerchantScreenState extends State<WithdrawMerchantScreen> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isRecentTab = true;
  String selectedBeneficiary = "Emmy John Smith";

  final List<Map<String, String>> recentBeneficiaries = [
    {
      "name": "John Smith",
      "bank": "ValarPay",
      "logo": "assets/images/user.png",
    },
    {
      "name": "John Smith",
      "bank": "ValarPay",
      "logo": "assets/images/user.png",
    },
  ];

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
          "Withdraw via Merchant",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
        ),
      ),
      body: Padding(
        padding: ResponsiveUtils.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient Account Number
            Text(
              "Recipient Account Number",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: accountController,
              decoration: InputDecoration(
                hintText: "Enter account name/number",
                suffixIcon: Icon(Icons.copy, color: Theme.of(context).iconTheme.color, size: 20.sp),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.borderRadius12,
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Amount
            Text(
              "Amount",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "₦ ",
                prefixStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.borderRadius12,
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Selected Beneficiary
            Row(
              children: [
                Icon(Icons.check_circle, color: appTheme.primaryColor),
                SizedBox(width: 8.w),
                Text(
                  selectedBeneficiary,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: appTheme.primaryColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Continue Button
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
                  // Handle continue
                  context.push("/transaction-details");
                },
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Tabs (Recent & Saved)
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => isRecentTab = true),
                  child: Column(
                    children: [
                      Text(
                        "Recent",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isRecentTab
                              ? appTheme.primaryColor
                              : Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      if (isRecentTab)
                        Container(
                          margin: EdgeInsets.only(top: 4.h),
                          height: 3.h,
                          width: 40.w,
                          color: appTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () => setState(() => isRecentTab = false),
                  child: Column(
                    children: [
                      Text(
                        "Saved Beneficiary",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: !isRecentTab
                              ? appTheme.primaryColor
                              : Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      if (!isRecentTab)
                        Container(
                          margin: EdgeInsets.only(top: 4.h),
                          height: 3.h,
                          width: 40.w,
                          color: appTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Search Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                hintText: "Searching",
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.borderRadius12,
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Beneficiaries List
            Expanded(
              child: ListView.builder(
                itemCount: recentBeneficiaries.length,
                itemBuilder: (context, index) {
                  final b = recentBeneficiaries[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: ResponsiveUtils.paddingAll12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: ResponsiveUtils.borderRadius12,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(b["logo"]!),
                          radius: 18.r,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b["name"]!,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "${b["bank"]}   ValarPay",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 13.sp,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.bookmark_add_outlined,
                            size: 20.sp,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}