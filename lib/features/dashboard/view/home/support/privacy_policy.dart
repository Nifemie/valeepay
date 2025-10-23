import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          title: const Text('Privacy Policy'),
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
                'ValarPay Mobile Banking Privacy Policy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Effective Date: October 23, 2025\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'ValarPay is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile banking application. By using ValarPay, you consent to the practices described in this policy.\n',
              ),
              Text(
                '1. Information We Collect',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '- Personal Information: Name, phone number, email, address, date of birth, BVN, and other identifiers.\n- Financial Information: Bank account details, transaction history, card details, and wallet balances.\n- Device Information: Device ID, operating system, mobile network, and location data.\n- Usage Data: App usage, log data, and cookies.\n',
              ),
              Text(
                '2. How We Use Your Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '- To provide and maintain our services.\n- To process transactions and manage your account.\n- To communicate with you about your account or transactions.\n- To improve our app and develop new features.\n- To comply with legal and regulatory requirements.\n- For fraud prevention and security purposes.\n',
              ),
              Text(
                '3. Information Sharing and Disclosure',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '- With service providers who help us operate our app.\n- With regulatory authorities as required by law.\n- With your consent or at your direction.\n- In connection with a merger, acquisition, or sale of assets.\n',
              ),
              Text(
                '4. Data Security',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We use industry-standard security measures to protect your information. However, no method of transmission over the Internet or electronic storage is 100% secure.\n',
              ),
              Text(
                '5. Your Rights and Choices',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '- You can access, update, or delete your personal information by contacting us.\n- You may opt out of marketing communications at any time.\n',
              ),
              Text(
                '6. Children\'s Privacy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Our services are not intended for children under 18. We do not knowingly collect information from children.\n',
              ),
              Text(
                '7. Changes to This Policy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We may update this Privacy Policy from time to time. We will notify you of any changes by updating the effective date.\n',
              ),
              Text(
                '8. Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'If you have any questions about this Privacy Policy, please contact us at support@valarpay.com.\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
