import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/current_rate_widget.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import '../../../widgets/services_widgets/cabletv_widgets/provider_selector_modal.dart';
import '../../../widgets/services_widgets/cabletv_widgets/plan_selector_modal.dart';

class CableTvProviderPaymentScreen extends StatefulWidget {
  final String providerName;

  const CableTvProviderPaymentScreen({
    super.key,
    required this.providerName,
  });

  @override
  State<CableTvProviderPaymentScreen> createState() =>
      _CableTvProviderPaymentScreenState();
}

class _CableTvProviderPaymentScreenState
    extends State<CableTvProviderPaymentScreen> {
  String selectedProvider = 'DStv';
  final TextEditingController smartcardController = TextEditingController();
  String selectedPlan = 'Plan A';
  final TextEditingController amountController =
      TextEditingController(text: '6500');
  String serviceFee = '500';

  @override
  void initState() {
    super.initState();
    selectedProvider = widget.providerName;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cable Tv',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to saved beneficiaries
            },
            child: const Text(
              'Saved Beneficiary',
              style: TextStyle(
                color: Color(0xFFF76301),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Provider
            Text(
              'Select Provider',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showProviderSelector(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedProvider,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Smartcard Number
            Text(
              'Smartcard Number',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ReuseableTextFieldWithCountry(
                controller: smartcardController,
                hintText: '0123456789',
                isReadOnly: false,
                textInputType: TextInputType.number,
                showCountryLabel: false),

            const SizedBox(height: 24),

            // Select Plan
            Text(
              'Select Plan',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showPlanSelector(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedPlan,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Current Date (Amount field with orange border)
            CurrentRateWidget(
                price: currencyFormatter(amountController.text),
                text: 'Current Rate'),
            const SizedBox(height: 60),

            // Continue Button
            FullWidthButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReuseableTransactionDetailsScreen(
                          hasBottom: false,
                          topTitleText: 'Transaction',
                              topTransactionsDetailsList: [
                                buildDetailRow('Smartcard Number',
                                    smartcardController.text, isDark),
                                buildDetailRow(
                                    'Provider', selectedProvider, isDark),
                                buildDetailRow('Package', selectedPlan, isDark),
                                buildDetailRow(
                                    'Amount',
                                    currencyFormatter(amountController.text),
                                    isDark),
                                buildDetailRow('Fee',
                                    currencyFormatter(serviceFee), isDark),
                                buildDetailRow(
                                    'Total Amount',
                                    currencyFormatter(
                                        '${int.parse(amountController.text) + int.parse(serviceFee)}'),
                                    isDark,
                                    isTotal: true),
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
                                                  amount: amountController.text,
                                                  topDetails: [
                                                    TransactionDetail(
                                                      label: 'Plan',
                                                      value: selectedPlan,
                                                    ),
                                                    TransactionDetail(
                                                        label: 'Amount',
                                                        value:
                                                            currencyFormatter(
                                                                amountController
                                                                    .text)),
                                                    TransactionDetail(
                                                        label: 'Fee',
                                                        value:
                                                            currencyFormatter(
                                                                serviceFee)),
                                                    TransactionDetail(
                                                        label: 'Total Debit',
                                                        value: currencyFormatter(
                                                            '${int.parse(amountController.text) + int.parse(serviceFee)}')),
                                                  ],
                                                  bottomDetails: [
                                                    TransactionDetail(
                                                        label: 'Transaction ID',
                                                        value:
                                                            'TXN${DateTime.now().millisecondsSinceEpoch}',
                                                        showCopyIcon: true),
                                                    TransactionDetail(
                                                        label:
                                                            'Smartcard Number',
                                                        value:
                                                            smartcardController
                                                                .text),
                                                    TransactionDetail(
                                                        label: 'Provider',
                                                        value:
                                                            selectedProvider),
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
                })
          ],
        ),
      ),
    );
  }

  void _showProviderSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CableTvProviderSelectorModal(
        selectedProvider: selectedProvider,
        onProviderSelected: (provider) {
          setState(() {
            selectedProvider = provider;
          });
        },
      ),
    );
  }

  void _showPlanSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CableTvPlanSelectorModal(
        selectedPlan: selectedPlan,
        onPlanSelected: (plan) {
          setState(() {
            selectedPlan = plan;
            // Update amount based on plan
            amountController.text = _getPlanPrice(plan);
          });
        },
      ),
    );
  }

  String _getPlanPrice(String plan) {
    switch (plan) {
      case 'Plan A':
        return '6500';
      case 'Plan B':
        return '4500';
      case 'Plan C':
        return '3500';
      case 'Plan D':
        return '2500';
      default:
        return '6500';
    }
  }
}
