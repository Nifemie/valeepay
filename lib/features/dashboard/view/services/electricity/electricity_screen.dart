import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/features/models/electricity.dart';
import 'package:valarpay/features/notifiers/electricity_notifier.dart';
import '../../../widgets/services_widgets/electricity_widgets/disco_selector_modal.dart';
import '../../../widgets/services_widgets/electricity_widgets/meter_type_modal.dart';
import 'saved_beneficiary_screen.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key});

  @override
  ConsumerState<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  ElectricityPlan? selectedDisco;
  ElectricityBillInfo? selectedMeterType;
  final TextEditingController meterNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String serviceFee = '500';
  String customerName = '';
  bool isMeterVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(electricityNotifierProvider.notifier)
          .getElectricityPlans(currency: 'NGN');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final electricityState = ref.watch(electricityNotifierProvider);
    final billInfoState = ref.watch(electricityBillInfoNotifierProvider);
    final paymentState = ref.watch(electricityPaymentNotifierProvider);

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
              onTap: electricityState.isDataAvailable
                  ? () => _showDiscoSelector(context)
                  : null,
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
                      selectedDisco?.planName ?? 'Select Disco',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedDisco == null ? Colors.grey : null,
                      ),
                    ),
                    electricityState.isInitialLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
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
                showCountryLabel: false,
                onChanged: (value) {
                  if (value.length >= 10 && selectedMeterType != null) {
                    _verifyMeterNumber();
                  } else {
                    setState(() {
                      isMeterVerified = false;
                      customerName = '';
                    });
                  }
                }),
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
              onTap: billInfoState.isDataAvailable
                  ? () => _showMeterTypeModal(context)
                  : null,
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
                      selectedMeterType?.name ?? 'Select Meter Type',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedMeterType == null ? Colors.grey : null,
                      ),
                    ),
                    billInfoState.isInitialLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.keyboard_arrow_down,
                            color: isDark ? Colors.white70 : Colors.grey[600],
                          ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Meter verification status
            if (meterNumberController.text.isNotEmpty &&
                selectedMeterType != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMeterVerified
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isMeterVerified ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isMeterVerified ? Icons.check_circle : Icons.info,
                      color: isMeterVerified ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isMeterVerified
                            ? 'Meter verified: $customerName'
                            : paymentState.isInitialLoading
                                ? 'Verifying meter number...'
                                : 'Enter valid meter number to verify',
                        style: TextStyle(
                          color: isMeterVerified ? Colors.green : Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
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
                isEnabled: _canProceed(),
                onPressed: () {
                  if (_canProceed()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReuseableTransactionDetailsScreen(
                          hasBottom: false,
                          topTitleText: 'Transaction',
                          topTransactionsDetailsList: [
                            buildDetailRow('Meter Number',
                                meterNumberController.text, isDark),
                            buildDetailRow(
                                'Disco', selectedDisco?.planName ?? '', isDark),
                            buildDetailRow('Meter Type',
                                selectedMeterType?.name ?? '', isDark),
                            buildDetailRow(
                                'Customer Name', customerName, isDark),
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
                              await _processPayment(pin);
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

  bool _canProceed() {
    return selectedDisco != null &&
        selectedMeterType != null &&
        meterNumberController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        isMeterVerified;
  }

  void _verifyMeterNumber() async {
    if (selectedMeterType == null || selectedDisco == null) return;

    final request = VerifyMeterNumberRequest(
      itemCode: selectedMeterType!.itemCode,
      billerCode: selectedDisco!.billerCode,
      billerNumber: meterNumberController.text,
    );

    await ref
        .read(electricityPaymentNotifierProvider.notifier)
        .verifyMeterNumber(request);

    final state = ref.read(electricityPaymentNotifierProvider);
    if (state.message != null && !state.message!.contains('Invalid')) {
      setState(() {
        isMeterVerified = true;
        customerName = 'JOHN SMITH JACOB'; // This would come from API response
      });
    } else {
      setState(() {
        isMeterVerified = false;
        customerName = '';
      });
    }
  }

  Future<void> _processPayment(String pin) async {
    if (!_canProceed()) return;

    final request = ElectricityPaymentRequest(
      walletPin: pin,
      itemCode: selectedMeterType!.itemCode,
      billerCode: selectedDisco!.billerCode,
      currency: 'NGN',
      billerNumber: meterNumberController.text,
      amount: double.parse(amountController.text),
    );

    await ref
        .read(electricityPaymentNotifierProvider.notifier)
        .payElectricity(request);

    final state = ref.read(electricityPaymentNotifierProvider);
    if (state.isDataAvailable &&
        state.data != null &&
        state.data!.isNotEmpty &&
        mounted) {
      final paymentResponse = state.data!.first;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionReceiptWidget(
            amount:
                '${int.parse(amountController.text) + int.parse(serviceFee)}',
            topDetails: [
              TransactionDetail(
                label: 'Token',
                value: paymentResponse.data.rechargeToken,
                showCopyIcon: true,
              ),
              TransactionDetail(
                label: 'Amount',
                value: currencyFormatter(amountController.text),
              ),
              TransactionDetail(
                label: 'Fee',
                value: currencyFormatter(serviceFee),
              ),
              TransactionDetail(
                label: 'Total Debit',
                value: currencyFormatter(
                    '${int.parse(amountController.text) + int.parse(serviceFee)}'),
              ),
            ],
            bottomDetails: [
              TransactionDetail(
                label: 'Transaction ID',
                value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                showCopyIcon: true,
              ),
              TransactionDetail(
                label: 'Meter Details',
                value:
                    '${meterNumberController.text} | ${selectedMeterType?.name}',
              ),
              TransactionDetail(
                label: 'Customer Name',
                value: customerName,
              ),
              TransactionDetail(
                label: 'Disco',
                value: selectedDisco?.planName ?? '',
              ),
              TransactionDetail(
                label: 'Payment Source',
                value: 'ValarPay Account',
              ),
              TransactionDetail(
                label: 'Date & Time',
                value: '29 Sep 2025 | 8:15 pm',
              ),
            ],
            onShareReceipt: () {
              // TODO: Implement share receipt functionality
            },
          ),
        ),
      );
    }
  }

  void _showDiscoSelector(BuildContext context) {
    final electricityState = ref.read(electricityNotifierProvider);
    if (!electricityState.isDataAvailable || electricityState.data == null)
      return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DiscoSelectorModal(
        discos: electricityState.data!,
        selectedDisco: selectedDisco,
        onDiscoSelected: (disco) {
          setState(() {
            selectedDisco = disco;
            selectedMeterType = null; // Reset meter type when disco changes
            isMeterVerified = false;
            customerName = '';
          });
          // Load bill info for selected disco
          ref
              .read(electricityBillInfoNotifierProvider.notifier)
              .getBillInfo(billerCode: disco.billerCode);
        },
      ),
    );
  }

  void _showMeterTypeModal(BuildContext context) {
    final billInfoState = ref.read(electricityBillInfoNotifierProvider);
    if (!billInfoState.isDataAvailable || billInfoState.data == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MeterTypeModal(
        meterTypes: billInfoState.data!,
        selectedType: selectedMeterType,
        onTypeSelected: (type) {
          setState(() {
            selectedMeterType = type;
            isMeterVerified = false;
            customerName = '';
          });
          // Verify meter number if already entered
          if (meterNumberController.text.length >= 10) {
            _verifyMeterNumber();
          }
        },
      ),
    );
  }
}
