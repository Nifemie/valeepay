import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/current_rate_widget.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';

import '../../../widgets/services_widgets/internet_widgets/plan_selector_modal.dart';

class ProviderPaymentScreen extends StatefulWidget {
  final String providerName;

  const ProviderPaymentScreen({
    super.key,
    required this.providerName,
  });

  @override
  State<ProviderPaymentScreen> createState() => _ProviderPaymentScreenState();
}

class _ProviderPaymentScreenState extends State<ProviderPaymentScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  String selectedPlan = '100MB Daily Plan';
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.providerName,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone Number
            Text(
              'Phone Number',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: '0000000000',
                hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey[400]),
                filled: true,
                fillColor: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Plan Selection
            Text(
              'Plan',
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
                  color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedPlan,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

            SizedBox(height: 24),

            CurrentRateWidget(
                text: 'Current Rate', price: _getPlanPrice(selectedPlan)),

            SizedBox(height: 40),

            FullWidthButton(
                text: 'Continue',
                onPressed: () {
                  if (phoneNumberController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReuseableTransactionDetailsScreen(
                                transactionsDetailsList: [
                                  buildDetailRow('Recipient Number',
                                      phoneNumberController.text, isDark),
                                  buildDetailRow(
                                      'Provider', widget.providerName, isDark),
                                  buildDetailRow('Plan', selectedPlan, isDark),
                                  Divider(),
                                  buildDetailRow(
                                    'Amount',
                                    _getPlanPrice(selectedPlan)
                                        .replaceAll('₦', '')
                                        .replaceAll(',', ''),
                                    isDark,
                                  )
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
                                                    amount: _getPlanPrice(
                                                        selectedPlan),
                                                    topDetails: [
                                                      TransactionDetail(
                                                          label: 'Plan',
                                                          value: selectedPlan),
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
                                                              'Recipient Mobile',
                                                          value:
                                                              phoneNumberController
                                                                  .text),
                                                      TransactionDetail(
                                                          label: 'Provider',
                                                          value: widget
                                                              .providerName),
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
                })
          ],
        ),
      ),
    );
  }

  String _getPlanPrice(String plan) {
    switch (plan) {
      case '100MB Daily Plan':
        return '₦500';
      case 'Unlimited Weekly Plan':
        return '₦2,000';
      case 'Unlimited Monthly Plan':
        return '₦8,000';
      case '300GB Monthly Plan':
        return '₦15,000';
      case 'Family / Shared Plans':
        return '₦25,000';
      default:
        return '₦500';
    }
  }

  void _showPlanSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => PlanSelectorModal(
        selectedPlan: selectedPlan,
        onPlanSelected: (plan) {
          setState(() {
            selectedPlan = plan;
          });
        },
      ),
    );
  }
}
