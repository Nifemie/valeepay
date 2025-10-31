import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class AddMoneyQRCode extends StatefulWidget {
  const AddMoneyQRCode({super.key});

  @override
  State<AddMoneyQRCode> createState() => _AddMoneyQRCodeState();
}

class _AddMoneyQRCodeState extends State<AddMoneyQRCode> {
  final String qrData = "valarpay:user:123456"; // replace with dynamic QR code data

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
          "My QR Code",
           style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),),
      ),
      body: Padding(
        padding: ResponsiveUtils.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Enter Amount
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Amount",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: appTheme.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // QR Code Container
            Container(
              padding: ResponsiveUtils.paddingAll16,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveUtils.borderRadius12,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.w,
                foregroundColor: appTheme.primaryColor,
                embeddedImage: const AssetImage("assets/images/logo.png"), // replace with ValarPay logo
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(48.w, 48.h),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Instruction text
            Text(
              "Open your phone camera, scan the ValarPay QR code, and add money instantly.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}