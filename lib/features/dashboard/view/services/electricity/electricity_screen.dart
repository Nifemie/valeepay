import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/kyc_not_set_widget.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/models/electricity.dart';
import 'package:valarpay/features/notifiers/electricity_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../../../widgets/services_widgets/electricity_widgets/disco_selector_modal.dart';
import '../../../widgets/services_widgets/electricity_widgets/meter_type_modal.dart';
import 'saved_beneficiary_screen.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
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
  final NumberFormat formatter = NumberFormat('#,###');
  bool saveBeneficiary = false;

  VerifyMeterNumberData? verifyMeterNumberData;
  String serviceFee = '500';
  String customerName = '';
  bool isMeterVerified = false;
  bool hasError = false;
  bool isNotMinimumAmount = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(electricityNotifierProvider.notifier)
          .getElectricityPlans(currency: 'NGN');
    });
    amountController.addListener(() {
      final text = amountController.text.replaceAll(',', '');
      if (text.isEmpty) return;

      // Prevent recursive updates
      final newText = formatter.format(int.parse(text));
      if (newText != amountController.text) {
        final cursorPos = newText.length;
        amountController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPos),
        );
      }
      if (double.parse(text) < verifyMeterNumberData!.minimum) {
        setState(() {
          isNotMinimumAmount = true;
        });
      } else {
        setState(() {
          isNotMinimumAmount = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isBvnVerified = user?.isBvnVerified ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final electricityState = ref.watch(electricityNotifierProvider);
    final billInfoState = ref.watch(electricityBillInfoNotifierProvider);
    final paymentState = ref.watch(electricityPaymentNotifierProvider);
    final state = ref.read(electricityPaymentNotifierProvider);
    final paymentResponse = state.singleData;
    final totalAmount =
        '${int.parse(amountController.text.replaceAll(',', '')) + int.parse(serviceFee)}';

    _onShareTransactionReceiptPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ReceiptShareScreen(
                date:
                    '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                transactionDetailList: [
                  ShareableTransactionReceiptDetail(
                    label: 'Amount',
                    value: currencyFormatter(
                      amountController.text..replaceAll(',', ''),
                    ),
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Fee',
                    value: currencyFormatter(serviceFee),
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Currency',
                    value: 'NGN',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Transaction Type',
                    value: 'Electricity Purchase',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Token',
                    value: paymentResponse!.data.rechargeToken,
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Meter Details',
                    value:
                        '${meterNumberController.text.trim()}\n${selectedMeterType?.categoryName}',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Customer Name',
                    value: verifyMeterNumberData?.name ?? '',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Discos',
                    value: selectedDisco?.planName ?? '',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Transaction ID',
                    value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Status',
                    value: 'Successful',
                    isSuccessful: true,
                  ),
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
          isMeterVerified &&
          verifyMeterNumberData != null &&
          !isNotMinimumAmount;
    }

    void _verifyMeterNumber() async {
      if (selectedMeterType == null || selectedDisco == null) return;

      setState(() {
        hasError = false;
      });

      final request = VerifyMeterNumberRequest(
        itemCode: selectedMeterType!.itemCode,
        billerCode: selectedDisco!.billerCode,
        billerNumber: meterNumberController.text,
      );

      final response = await ref
          .read(electricityPaymentNotifierProvider.notifier)
          .verifyMeterNumber(request);

      if (response != null && response.data != null) {
        // API uses response_code '00' to indicate success
        final success =
            response.data!.responseCode == '00' ||
            response.data!.responseMessage.toLowerCase().contains('success');
        if (success) {
          setState(() {
            isMeterVerified = true;
            // update service fee from API if provided
            verifyMeterNumberData = response.data;
            customerName = verifyMeterNumberData?.name ?? '';
            try {
              final feeInt = response.data!.fee.toInt();
              serviceFee = feeInt.toString();
            } catch (_) {}
          });
          return;
        }
      } else {
        setState(() {
          hasError = true;
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
        amount: double.parse(amountController.text.replaceAll(',', '')),
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await ref
          .read(electricityPaymentNotifierProvider.notifier)
          .payElectricity(request);

      Navigator.pop(context);

      final state = ref.read(electricityPaymentNotifierProvider);
      if (state.isDataAvailable && state.singleData != null) {
        final paymentResponse = state.singleData;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => TransactionReceiptWidget(
                  headerText: 'Transaction',
                  amount:
                      '${int.parse(amountController.text) + int.parse(serviceFee)}',
                  topDetails: [
                    TransactionDetail(
                      label: 'Token',
                      value: paymentResponse!.data.rechargeToken,
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
                        '${int.parse(amountController.text) + int.parse(serviceFee)}',
                      ),
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
                          '${meterNumberController.text} | ${selectedMeterType?.categoryName}',
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
                      value:
                          '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                    ),
                  ],
                  onShareReceipt: _onShareTransactionReceiptPressed,
                ),
          ),
        );
      } else {
        AppMessenger.show(
          context,
          message: state.message ?? 'An error ocured please try again',
          type: MessageType.error,
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
        builder:
            (context) => DiscoSelectorModal(
              discos: electricityState.data!,
              selectedDisco: selectedDisco,
              onDiscoSelected: (disco) {
                setState(() {
                  selectedDisco = disco;
                  selectedMeterType =
                      null; // Reset meter type when disco changes
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
        builder:
            (context) => MeterTypeModal(
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

    _handlePinEntry() async {
      final hasEnoughBalance = checkBalanceLeft(
        context,
        user?.wallets.first.balance.toString() ?? '0',
        totalAmount,
      );

      if (!hasEnoughBalance) return;
      final pin = await TransactionPinModal.show(context);
      if (pin != null && pin.length == 4 && mounted) {
        await _processPayment(pin);
      }
    }

    _handleBiometricPinEntry() async {
      final hasEnoughBalance = checkBalanceLeft(
        context,
        user?.wallets.first.balance.toString() ?? '0',
        totalAmount,
      );

      if (!hasEnoughBalance) return;
      final pin = await BiometricTransactionPinModal.show(context);
      if (pin != null && pin.length == 4 && mounted) {
        await _processPayment(pin);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Electricity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions:
            isBvnVerified
                ? [
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
                      style: TextStyle(color: Color(0xFFF76301), fontSize: 14),
                    ),
                  ),
                ]
                : null,
      ),
      body:
          !isBvnVerified
              ? const KycNotSetWidget(
                title: 'KYC Not Completed',
                subtitle:
                    'Complete your KYC verification to pay electricity bills',
              )
              : Padding(
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
                      onTap:
                          electricityState.isDataAvailable
                              ? () => _showDiscoSelector(context)
                              : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
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
                                color:
                                    selectedDisco == null ? Colors.grey : null,
                              ),
                            ),
                            electricityState.isInitialLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Icon(
                                  Icons.keyboard_arrow_down,
                                  color:
                                      isDark
                                          ? Colors.white70
                                          : Colors.grey[600],
                                ),
                          ],
                        ),
                      ),
                    ),

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
                      onTap:
                          billInfoState.isDataAvailable
                              ? () => _showMeterTypeModal(context)
                              : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
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
                                color:
                                    selectedMeterType == null
                                        ? Colors.grey
                                        : null,
                              ),
                            ),
                            billInfoState.isInitialLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Icon(
                                  Icons.keyboard_arrow_down,
                                  color:
                                      isDark
                                          ? Colors.white70
                                          : Colors.grey[600],
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
                      isReadOnly:
                          selectedDisco == null || selectedMeterType == null,
                      textInputType: TextInputType.number,
                      showCountryLabel: false,
                      onChanged: (value) {
                        if (value.length >= 10 && selectedMeterType != null) {
                          _verifyMeterNumber();
                        } else {
                          setState(() {
                            isMeterVerified = false;
                            customerName = '';
                            hasError = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Meter verification status
                    if (meterNumberController.text.isNotEmpty &&
                        selectedMeterType != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isMeterVerified
                                  ? Colors.green.withOpacity(0.1)
                                  : hasError
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isMeterVerified
                                    ? Colors.green
                                    : hasError
                                    ? Colors.red
                                    : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isMeterVerified ? Icons.check_circle : Icons.info,
                              color:
                                  isMeterVerified
                                      ? Colors.green
                                      : hasError
                                      ? Colors.red
                                      : Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isMeterVerified
                                    ? 'Account Name: $customerName \nMinimum: ${currencyFormatter(verifyMeterNumberData?.minimum.toString() ?? '')} \nAddress: ${verifyMeterNumberData?.address}'
                                    : paymentState.isInitialLoading
                                    ? 'Verifying meter number...'
                                    : hasError
                                    ? paymentState.message ??
                                        'Error verifying meter number'
                                    : 'Enter valid meter number to verify',
                                style: TextStyle(
                                  color:
                                      isMeterVerified
                                          ? Colors.green
                                          : hasError
                                          ? Colors.red
                                          : Colors.orange,
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
                      isReadOnly: verifyMeterNumberData == null,
                      hintText: '10,000',
                    ),
                    if (isNotMinimumAmount) SizedBox(height: 12),
                    if (isNotMinimumAmount)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please enter a value greater or equal to ${currencyFormatter(verifyMeterNumberData!.minimum.toString())}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              builder:
                                  (context) =>
                                      ReuseableTransactionDetailsScreen(
                                        saveBeneficiary: saveBeneficiary,
                                        onSaveBeneficiaryChanged: (value) {
                                          setState(() {
                                            saveBeneficiary = value;
                                          });
                                        },
                                        hasBottom: false,
                                        topTitleText: 'Transaction',
                                        topTransactionsDetailsList: [
                                          buildDetailRow(
                                            'Meter Number',
                                            meterNumberController.text,
                                            isDark,
                                          ),
                                          buildDetailRow(
                                            'Disco',
                                            selectedDisco?.planName ?? '',
                                            isDark,
                                          ),
                                          buildDetailRow(
                                            'Meter Type',
                                            selectedMeterType?.categoryName ??
                                                '',
                                            isDark,
                                          ),
                                          buildDetailRow(
                                            'Customer Name',
                                            customerName,
                                            isDark,
                                          ),
                                          buildDetailRow(
                                            'Amount',
                                            currencyFormatter(
                                              amountController.text
                                                ..replaceAll(',', ''),
                                            ),
                                            isDark,
                                          ),
                                          buildDetailRow(
                                            'Fee',
                                            currencyFormatter(serviceFee),
                                            isDark,
                                          ),
                                          buildDetailRow(
                                            'Total Amount',
                                            currencyFormatter(totalAmount),
                                            isDark,
                                            isTotal: true,
                                          ),
                                        ],
                                        onButtonPressed: _handlePinEntry,
                                        onBiometricButtonPressed: _handleBiometricPinEntry,
                                      ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
