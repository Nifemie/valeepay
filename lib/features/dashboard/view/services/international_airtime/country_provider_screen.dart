import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';

class CountryProviderScreen extends StatefulWidget {
  final String countryProvider;

  const CountryProviderScreen({
    super.key,
    required this.countryProvider,
  });

  @override
  State<CountryProviderScreen> createState() => _CountryProviderScreenState();
}

class _CountryProviderScreenState extends State<CountryProviderScreen> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedAmount = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get country code based on provider
    String countryCode = _getCountryCode(widget.countryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.countryProvider,
          style: TextStyle(
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

            ReuseableTextFieldWithCountry(
                showCountryLabel: true,
                hintText: '123 456 789',
                isReadOnly: false,
                textInputType: TextInputType.phone,
                countryCode: countryCode,
                flagImagePath: 'assets/images/ghflag.png',
                controller: controller),

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

            ReuseableAmountTextfield(
                amountController: amountController,
                prefixText: '\$',
                hintText: '1000'),

            const SizedBox(height: 24),

            // Quick Amount Selection
            Text(
              'Quick Select',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAmountChip('5.00', isDark),
                _buildAmountChip('10.00', isDark),
                _buildAmountChip('20.00', isDark),
                _buildAmountChip('50.00', isDark),
                _buildAmountChip('100.00', isDark),
              ],
            ),

            const SizedBox(
              height: 50,
            ),

            // Continue Button
            FullWidthButton(
                text: 'Continue',
                onPressed: () {
                  if (controller.text.isNotEmpty &&
                      (amountController.text.isNotEmpty ||
                          selectedAmount.isNotEmpty)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReuseableTransactionDetailsScreen(
                                hasBottom: false,
                                topTitleText: 'Transacton',
                                topTransactionsDetailsList: [
                                  buildDetailRow('Recipient Number',
                                      '$countryCode${controller.text}', isDark),
                                  buildDetailRow('Provider',
                                      widget.countryProvider, isDark),
                                  buildDetailRow(
                                      'Amount',
                                      currencyFormatter(amountController.text),
                                      isDark),
                                ],
                                onButtonPressed: () async {
                                  final pin =
                                      await BiometricTransactionPinModal.show(context);
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
                                                    amount:
                                                        amountController.text,
                                                    topDetails: [
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
                                                              '$countryCode${controller.text}'),
                                                      TransactionDetail(
                                                          label: 'Provider',
                                                          value: widget
                                                              .countryProvider),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAmountChip(String amount, bool isDark) {
    final isSelected = selectedAmount == amount;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
          amountController.text = amount;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF76301)
              : (isDark ? const Color(0xFF2B2725) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? Colors.white24 : Colors.grey[300]!,
                ),
        ),
        child: Text(
          '\$$amount',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : Colors.black),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _getCountryCode(String provider) {
    if (provider.contains('Ghana')) return '+233';
    if (provider.contains('Canada')) return '+1';
    if (provider.contains('Kenya')) return '+254';
    if (provider.contains('Senegal')) return '+221';
    return '+233'; // Default
  }

  Color _getFlagColor(String provider) {
    if (provider.contains('Ghana')) return Colors.red;
    if (provider.contains('Canada')) return Colors.red;
    if (provider.contains('Kenya')) return Colors.green;
    if (provider.contains('Senegal')) return Colors.green;
    return Colors.red; // Default
  }
}
