import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import '../../../widgets/services_widgets/electricity_widgets/disco_selector_modal.dart';
import '../../../widgets/services_widgets/electricity_widgets/meter_type_modal.dart';
import 'saved_beneficiary_screen.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  String selectedDisco = 'Benin Electricity';
  String selectedMeterType = 'Prepaid';
  final TextEditingController meterNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String serviceFee = '500';

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
          'Electricity',
          style: TextStyle(
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
                  builder: (context) => const SavedBeneficiaryScreen(),
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
            // Select Disco
            Text(
              'Select Disco',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showDiscoSelector(context),
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
                      selectedDisco,
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

            // Meter Number
            Text(
              'Meter Number',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ReuseableTextFieldWithCountry(
                controller: meterNumberController,
                hintText: 'Enter Meter Number',
                isReadOnly: false,
                textInputType: TextInputType.number,
                showCountryLabel: false),
            const SizedBox(height: 24),

            // Meter Type
            Text(
              'Meter Type',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showMeterTypeModal(context),
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
                      selectedMeterType,
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
                prefixText: '₦',
                hintText: '10,000'),
            const SizedBox(height: 60),

            // Continue Button
            FullWidthButton(
                text: 'Continue',
                onPressed: () {
                  if (meterNumberController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReuseableTransactionDetailsScreen(
                          hasBottom: false,
                          topTitleText: 'Transaction',
                          topTransactionsDetailsList: [
                            buildDetailRow('Meter Number',
                                meterNumberController.text, isDark),
                            buildDetailRow('Disco', selectedDisco, isDark),
                            buildDetailRow(
                                'Meter Type', selectedMeterType, isDark),
                            buildDetailRow(
                                'Customer Name', 'JOHN SMITH JACOB', isDark),
                            buildDetailRow(
                                'Amount',
                                currencyFormatter(amountController.text),
                                isDark),
                            buildDetailRow(
                                'Fee', currencyFormatter(serviceFee), isDark),
                            buildDetailRow(
                                'Total Amount',
                                currencyFormatter(
                                    '${int.parse(amountController.text) + int.parse(serviceFee)}'),
                                isDark,
                                isTotal: true)
                          ],
                          onButtonPressed: () async {
                            final pin = await TransactionPinModal.show(context);
                            if (pin != null && pin.length == 4 && mounted) {
                              if (mounted) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionReceiptWidget(
                                              amount:
                                                  '${int.parse(amountController.text) + int.parse(serviceFee)}',
                                              topDetails: [
                                                TransactionDetail(
                                                    label: 'Token',
                                                    value:
                                                        '1235-8796-6754-0987'),
                                                TransactionDetail(
                                                    label: 'Amount',
                                                    value: currencyFormatter(
                                                        amountController.text)),
                                                TransactionDetail(
                                                    label: 'Fee',
                                                    value: currencyFormatter(
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
                                                    label: 'Meter Details',
                                                    value:
                                                        '${meterNumberController.text} | $selectedMeterType'),
                                                TransactionDetail(
                                                    label: 'Customer Name',
                                                    value: 'JOHN SMITH JACOB'),
                                                TransactionDetail(
                                                    label: 'Disco',
                                                    value: selectedDisco),
                                                TransactionDetail(
                                                    label: 'Payment Source',
                                                    value: 'ValarPay Account'),
                                                TransactionDetail(
                                                    label: 'Date & Time',
                                                    value:
                                                        '29 Sep 2025 | 8:15 pm'),
                                              ],
                                              onShareReceipt: () {
                                                // TODO: Implement share receipt functionality
                                              },
                                            )));
                              }
                            }
                          },
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  void _showDiscoSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DiscoSelectorModal(
        selectedDisco: selectedDisco,
        onDiscoSelected: (disco) {
          setState(() {
            selectedDisco = disco;
          });
        },
      ),
    );
  }

  void _showMeterTypeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MeterTypeModal(
        selectedType: selectedMeterType,
        onTypeSelected: (type) {
          setState(() {
            selectedMeterType = type;
          });
        },
      ),
    );
  }
}
