import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/reuseable_appbar_text_button.dart';
import 'saved_beneficiary_screen.dart';
import 'provider_payment_screen.dart';

class InternetScreen extends StatefulWidget {
  const InternetScreen({super.key});

  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final internetProviders = [
      'Spectranet',
      'Smile Communications',
      'Swift Networks',
      'Broadline Broadband',
      'Vodacom Business Nigeria',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Internet',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          ReuseableAppbarTextButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InternetSavedBeneficiaryScreen(),
                ),
              );
            }, 
          text: 'Saved Beneficiary')
         
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Internet Providers List
            Expanded(
              child: ListView.builder(
                itemCount: internetProviders.length,
                itemBuilder: (context, index) {
                  final provider = internetProviders[index];
                  return _buildProviderTile(provider, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderTile(String provider, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          provider,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDark ? Colors.white70 : Colors.grey[600],
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProviderPaymentScreen(
                providerName: provider,
              ),
            ),
          );
        },
      ),
    );
  }
}
