import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool showNairaBalance = false;
  bool showDollarBalance = false;

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
          "Account",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.paddingAll16,
        child: Column(
          children: [
            // Naira Account Card
            _accountCard(
              currency: "₦",
              isVisible: showNairaBalance,
              onToggle:
                  () => setState(() => showNairaBalance = !showNairaBalance),
            ),
            SizedBox(height: 16.h),

            // Dollar Account Card
            _accountCard(
              currency: "\$",
              isVisible: showDollarBalance,
              onToggle:
                  () => setState(() => showDollarBalance = !showDollarBalance),
            ),
            SizedBox(height: 20.h),

            // Get Euro Account
            _accountSetupCard(
              flag: "assets/images/euflag.png",
              title: "Get Euro Account",
              subtitle: "Open a secure euro account",
              onTap: () {
                context.push('/account-setup');
              },
            ),
            SizedBox(height: 12.h),

            // Get Pound Account
            _accountSetupCard(
              flag: "assets/images/usflag.png",
              title: "Get Pound Account",
              subtitle: "Open a secure pounds account",
              onTap: () {
                // handle setup
                context.push('/account-setup');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Account Card
  Widget _accountCard({
    required String currency,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: ResponsiveUtils.paddingAll16,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveUtils.borderRadius12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Your Balance",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                  ),
                  IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).iconTheme.color,
                      size: 20.sp,
                    ),
                    onPressed: onToggle,
                  ),
                ],
              ),
              Text(
                "Tier 1",
                style: TextStyle(
                  color: appTheme.primaryColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            isVisible ? "$currency 150,000.00" : "$currency ***********",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 16.h),

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
    );
  }

  // Info Row with copy icon
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
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$label copied to clipboard")),
            );
          },
        ),
      ],
    );
  }

  // Account setup card (Euro / Pound)
  Widget _accountSetupCard({
    required String flag,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: ResponsiveUtils.paddingAll12,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveUtils.borderRadius12,
      ),
      child: ListTile(
        leading: CircleAvatar(radius: 18.r, backgroundImage: AssetImage(flag)),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13.sp),
        ),
        trailing: TextButton(
          onPressed: onTap,
          child: Text(
            "Setup",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}