import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.darkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Withdraw via Bank Branch",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            // Illustration / Image
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/bank.png", // replace with your actual illustration asset
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Title
            const Text(
              "Withdraw via Bank Branch",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle / Description
            const Text(
              "Visit any bank branch to access your ValarPay account and withdraw your cash easily",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Locate Nearest Branch Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  // TODO: implement nearest branch logic
                },
                child: const Text(
                  "Locate Nearest Branch",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
