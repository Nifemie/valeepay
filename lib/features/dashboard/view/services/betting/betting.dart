import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/betting_widgets/provider_selector_modal.dart';
import 'saved_beneficiary_screen.dart';

class BettingScreen extends StatefulWidget {
  const BettingScreen({super.key});

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  String selectedProvider = 'Bet9ja';
  final TextEditingController userIdController = TextEditingController();
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
          'Betting',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BettingSavedBeneficiaryScreen(),
                ),
              );
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
                  color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedProvider,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
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

            // User ID
            Text(
              'User ID',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: userIdController,
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

            // Amount
            Text(
              'Amount',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: '₦',
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

            const SizedBox(height: 50),

            // Continue Button
            FullWidthButton(
              text: 'Continue',
              onPressed: () {
                if (userIdController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReuseableTransactionDetailsScreen(
                              transactionsDetailsList: [
                                buildDetailRow('Recipient ID',
                                    userIdController.text, isDark),
                                buildDetailRow(
                                    'Provider', selectedProvider, isDark),
                                buildDetailRow('Amount',
                                    '₦${amountController.text}', isDark),
                                Divider(),
                                buildDetailRow('Amount',
                                    '₦${amountController.text}', isDark,
                                    isTotal: true)
                              ],
                              onButtonPressed: () async {
                                final pin =
                                    await TransactionPinModal.show(context);
                                if (pin != null && pin.length == 4 && mounted) {
                                  if (mounted) Navigator.pop(context);
                                  if (mounted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionReceiptWidget(
                                                  amount: amountController.text,
                                                  topDetails: [
                                                    TransactionDetail(
                                                        label: 'Transaction ID',
                                                        value:
                                                            'TXN${DateTime.now().millisecondsSinceEpoch}'),
                                                    TransactionDetail(
                                                        label: 'Recipient ID',
                                                        value: userIdController
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
                                                  onDone: () {},
                                                )));
                                  }
                                }
                              },
                            )),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProviderSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BettingProviderSelectorModal(
        selectedProvider: selectedProvider,
        onProviderSelected: (provider) {
          setState(() {
            selectedProvider = provider;
          });
        },
      ),
    );
  }
}
