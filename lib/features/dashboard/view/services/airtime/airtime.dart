import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/airtime_services_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/network_provider_selector.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _useCashback = false;
  String _selectedNetwork = '';

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    _amountController.text = '';
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
          'Airtime',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
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
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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

              ReuseableTextFieldWithCountry(
                  countryCode: '+234 ',
                  flagImagePath: 'assets/images/ngflag.png',
                  hintText: '123 456 789',
                  controller: _controller,
                  isReadOnly: false,
                  textInputType: TextInputType.phone,
                  showCountryLabel: true,
                  suffixWidget: IconButton(
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
                  )),

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
              ReuseableAmountTextfield(
                amountController: _amountController,
                prefixText: '₦',
                hintText: '500',
              ),

              const SizedBox(height: 24),

              // Cashback Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Use Cashback',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                  // Handle continue action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReuseableTransactionDetailsScreen(
                          hasBottom: false,
                          topTitleText: 'Transaction',
                              topTransactionsDetailsList: [
                                buildDetailRow('Recipient Number',
                                    '${_controller.text}', isDark),
                                buildDetailRow(
                                    'Provider', _selectedNetwork, isDark),
                                buildDetailRow(
                                    'Amount',
                                    currencyFormatter(_amountController.text),
                                    isDark),
                              ],
                              onButtonPressed: () async {
                                final pin =
                                    await TransactionPinModal.show(context);
                                if (pin != null && pin.length == 4 && mounted) {
                                  if (mounted) Navigator.pop(context);
                                  if (mounted) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionReceiptWidget(
                                                  amount:
                                                      _amountController.text,
                                                  topDetails: [
                                                    TransactionDetail(
                                                        label: 'Transaction ID',
                                                        value:
                                                            'TXN${DateTime.now().millisecondsSinceEpoch}',
                                                        showCopyIcon: true),
                                                    TransactionDetail(
                                                        label: 'Phone Number',
                                                        value:
                                                            '${_controller.text}'),
                                                    TransactionDetail(
                                                        label: 'Provider',
                                                        value:
                                                            _selectedNetwork),
                                                    TransactionDetail(
                                                        label: 'Payment Source',
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
                },
              ),
              const SizedBox(height: 32),

              // Airtime Services Section
              const AirtimeServicesSection(),
              const SizedBox(height: 20), // Extra bottom padding
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
