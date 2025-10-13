import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/responsive_button.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/data_plans_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/mobile_data_services_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/network_provider_selector.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _useCashback = false;
  String _selectedNetwork = '';
  String _selectedPlan = '';

  @override
  void initState() {
    super.initState();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
            ReuseableTextFieldWithCountry(
                controller: _controller,
                hintText: "123 567 890",
                countryCode: '+234',
                flagImagePath: 'assets/images/ngflag.png',
                isReadOnly: false,
                textInputType: TextInputType.phone,
                showCountryLabel: true),
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

            // Data Plans Section
            if (_selectedNetwork.isNotEmpty) ...[
              DataPlansSection(
                networkName: _selectedNetwork,
                selectedPlan: _selectedPlan,
                onPlanSelected: (plan) {
                  setState(() {
                    _selectedPlan = plan;
                  });
                },
              ),
              const SizedBox(height: 50),
            ],

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

            FullWidthButton(
                text: 'Continue',
                onPressed: () {
                  if (_selectedPlan.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReuseableTransactionDetailsScreen(
                                hasBottom: false,
                                topTitleText: 'Transaction',
                                topTransactionsDetailsList: [
                                  buildDetailRow('Beneficiary Number',
                                      '${_controller.text}', isDark),
                                  buildDetailRow(
                                      'Provider', _selectedNetwork, isDark),
                                  buildDetailRow(
                                      'Timeframe', _selectedNetwork, isDark),
                                  buildDetailRow('Amount',
                                      currencyFormatter('10000'), isDark),
                                ],
                                onButtonPressed: () async {
                                  final pin =
                                      await TransactionPinModal.show(context);
                                  if (pin != null &&
                                      pin.length == 4 &&
                                      mounted) {
                                    if (mounted) Navigator.pop(context);
                                    if (mounted) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionReceiptWidget(
                                                    amount: '10000',
                                                    topDetails: [
                                                      TransactionDetail(
                                                        label: 'Timeframe',
                                                        value: _selectedPlan,
                                                      ),
                                                      TransactionDetail(
                                                          label: 'Plan',
                                                          value: _selectedPlan),
                                                    ],
                                                    bottomDetails: [
                                                      TransactionDetail(
                                                          label:
                                                              'Transaction ID',
                                                          value:
                                                              'TXN${DateTime.now().millisecondsSinceEpoch}',
                                                          showCopyIcon: true),
                                                      TransactionDetail(
                                                          label:
                                                              'Recipient Mobiler',
                                                          value:
                                                              '${_controller.text}'),
                                                      TransactionDetail(
                                                          label: 'Provider',
                                                          value:
                                                              _selectedNetwork),
                                                      TransactionDetail(
                                                          label:
                                                              'Payment Source',
                                                          value:
                                                              'ValarPay Account'),
                                                      TransactionDetail(
                                                          label: 'Date & Time',
                                                          value:
                                                              '29 Sep 2025 | 8:15 pm')
                                                    ],
                                                    onShareReceipt: () {},
                                                  )));
                                    }
                                  }
                                },
                              )),
                    );
                  }
                }),
            SizedBox(height: 24),
            DataServicesSection()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
