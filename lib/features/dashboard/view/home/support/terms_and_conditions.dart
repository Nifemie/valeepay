import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          context.pop();
        } else {
          context.go('/about-us');
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Terms and Conditions'),
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                )
              : null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'ValarPay Mobile Banking Terms and Conditions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Effective Date: October 23, 2025\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'These Terms and Conditions (\'Terms\') govern your use of the ValarPay mobile banking application. By using ValarPay, you agree to these Terms. Please read them carefully.\n',
              ),
              Text(
                '1. Eligibility',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'You must be at least 18 years old and have the legal capacity to enter into a binding agreement to use ValarPay.\n',
              ),
              Text(
                '2. Account Registration',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'You agree to provide accurate and complete information when registering for ValarPay. You are responsible for maintaining the confidentiality of your account credentials.\n',
              ),
              Text(
                '3. Use of Services',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '- You agree to use ValarPay only for lawful purposes.\n- You will not use the app for fraudulent or illegal activities.\n- You are responsible for all activities that occur under your account.\n',
              ),
              Text(
                '4. Fees and Charges',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'ValarPay may charge fees for certain services. All fees will be disclosed to you before you complete a transaction.\n',
              ),
              Text('5. Security', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'You are responsible for keeping your login credentials secure. Notify us immediately if you suspect unauthorized access to your account.\n',
              ),
              Text(
                '6. Intellectual Property',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'All content, trademarks, and data on ValarPay are the property of ValarPay or its licensors.\n',
              ),
              Text(
                '7. Limitation of Liability',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'ValarPay is not liable for any indirect, incidental, or consequential damages arising from your use of the app.\n',
              ),
              Text(
                '8. Termination',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We may suspend or terminate your access to ValarPay at any time for violation of these Terms or applicable laws.\n',
              ),
              Text(
                '9. Changes to Terms',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We may update these Terms from time to time. Continued use of ValarPay after changes constitutes acceptance of the new Terms.\n',
              ),
              Text(
                '10. Governing Law',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'These Terms are governed by the laws of the Federal Republic of Nigeria.\n',
              ),
              Text(
                '11. Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'If you have any questions about these Terms, contact us at support@valarpay.com.\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
