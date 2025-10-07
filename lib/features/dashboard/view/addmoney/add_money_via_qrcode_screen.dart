import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.darkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My QR Code",
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Enter Amount
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Amount",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: appTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // QR Code Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                size: 250,
                foregroundColor: appTheme.primaryColor,
                embeddedImage: const AssetImage("assets/images/logo.png"), // replace with ValarPay logo
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(48, 48),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instruction text
            const Text(
              "Open your phone camera, scan the ValarPay QR code, and add money instantly.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
