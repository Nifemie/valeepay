import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/responsive_button.dart';
import 'package:valarpay/core/widgets/responsive_text_field.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/airtime_services_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/network_provider_selector.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _useCashback = false;
  String _selectedNetwork = '';

  @override
  void initState() {
    super.initState();
    _phoneController.text = '000000000';
    _amountController.text = '000000000';
  }

  void _showContactAccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContactAccessDialog(
        onAllow: () {
          Navigator.of(context).pop();
          // Handle contact access permission
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Airtime',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle saved beneficiary
            },
            child: Text(
              'Saved Beneficiary',
              style: TextStyle(
                color: appTheme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Phone Number Section
            const Text(
              'Phone Number',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                          prefix: const Text(
                            '🇳🇬 +234 ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          border: InputBorder.none),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showContactAccessDialog,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: appTheme.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Network Provider Selection
            NetworkProviderSelector(
              selectedNetwork: _selectedNetwork,
              onNetworkSelected: (network) {
                setState(() {
                  _selectedNetwork = network;
                });
              },
            ),
            const SizedBox(height: 24),

            // Amount Section
            const Text(
              'Amount',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _amountController,
                decoration: InputDecoration(
                    border: InputBorder.none, prefix: Text('₦ ')),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cashback Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Use Cashback',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      '₦50.00',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _useCashback,
                      onChanged: (value) {
                        setState(() {
                          _useCashback = value;
                        });
                      },
                      activeColor: appTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Continue Button
            ResponsiveButton(
              text: 'Continue',
              onPressed: () {
                // Handle continue action
              },
            ),
            const SizedBox(height: 32),

            // Airtime Services Section
            const AirtimeServicesSection(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
