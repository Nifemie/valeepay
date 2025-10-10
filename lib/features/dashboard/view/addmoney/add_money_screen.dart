import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final List<Map<String, dynamic>> addMoneyOptions = [
    {
      "id": 1,
      "icon": Icons.account_balance,
      "title": "Via Bank Transfer",
      "subtitle":
          "Send money directly to your ValarPay account via bank transfer",
    },
    {
      "id": 2,
      "icon": Icons.store,
      "title": "Cash Deposit (Agent)",
      "subtitle":
          "Deposit cash safely at any authorized ValarPay agent near you",
    },
    {
      "id": 3,
      "icon": Icons.credit_card,
      "title": "Top Up with Card/Account",
      "subtitle":
          "Instantly fund your wallet using your debit card or linked bank account",
    },
    {
      "id": 4,
      "icon": Icons.qr_code,
      "title": "Scan My Code",
      "subtitle":
          "Add money instantly by scanning your unique ValarPay QR code",
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
          "Add Money",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
        ),
      ),
      body: Padding(
        padding: ResponsiveUtils.paddingAll16,
        child: Column(
          children: addMoneyOptions.map((option) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveUtils.borderRadius12,
              ),
              child: ListTile(
                contentPadding: ResponsiveUtils.paddingAll12,
                leading: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: appTheme.primaryColor,
                  child: Icon(
                    option["icon"],
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  option["title"],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                ),
                subtitle: Text(
                  option["subtitle"],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                      ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).iconTheme.color,
                ),
                onTap: () {
                  // handle navigation to each option screen
                  if (option["id"] == 1 || option["id"] == 2) {
                    context.push("/add-money-via-transfer");
                  } else if (option["id"] == 4) {
                    context.push("/add-money-via-qrcode");
                  } else {
                    context.push("/coming-soon");
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}