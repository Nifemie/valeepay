import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.darkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bank Transfer",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tier 1",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: appTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bank Name
                  _infoRow("Bank Name", "ValarPay"),

                  const SizedBox(height: 12),

                  // Account Name
                  _infoRow("Account Name", "John Smith Emmy"),

                  const SizedBox(height: 12),

                  // Account Number
                  _infoRow("Account Number", "0000000000"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Share Details Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  // handle share details
                },
                icon: const Icon(Icons.share, color: Colors.white, size: 18),
                label: const Text(
                  "Share Details",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fund your ValarPay wallet easily in three quick steps",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Step 1: Copy your unique ValarPay account number from the app.\n"
                    "Step 2: Open your mobile banking app and initiate a transfer.\n"
                    "Step 3: Send the desired amount, and your ValarPay wallet will be credited instantly.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
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
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18, color: Colors.black45),
          onPressed: () => _copyToClipboard(label, value),
        ),
      ],
    );
  }
}
