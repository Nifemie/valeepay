import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'saved_beneficiary_screen.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import '../../../widgets/services_widgets/cabletv_widgets/cabletv_provider_selector_modal.dart';
import '../../../widgets/services_widgets/cabletv_widgets/cabletv_plan_selector_modal.dart';
import 'package:valarpay/features/notifiers/cable_notifier.dart';
import 'package:valarpay/features/models/cable_models.dart';
import 'package:valarpay/core/widgets/kyc_not_set_widget.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class CableTvScreen extends ConsumerStatefulWidget {
  const CableTvScreen({super.key});

  @override
  ConsumerState<CableTvScreen> createState() => _CableTvScreenState();
}

class _CableTvScreenState extends ConsumerState<CableTvScreen> {
  String selectedProvider = 'Select a provider';
  final TextEditingController smartcardController = TextEditingController();
  String? selectedPlan;
  String planAmount = ' Amount'; // This will need to be dynamic later
  bool _showVerifyButton = false;
  bool _isVerifying = false;
  bool _hasError = false;
  VerifyCableData? _verifyResponse;
  String? _verifiedUserName;
  String? _errorMessage;
  bool saveBeneficiary = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cablePlansNotifierProvider.notifier).getPlans(currency: 'NGN');
    });
  }

  @override
  void dispose() {
    smartcardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isBvnVerified = user?.isBvnVerified ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int totalAmount = 0;
    try {
      final planAmountInt = int.parse(
        planAmount.replaceAll(RegExp(r'[^\d]'), ''),
      );
      final feeAmount = double.parse(_verifyResponse?.fee.toString() ?? '0.0');
      totalAmount = (planAmountInt + feeAmount).toInt();
    } catch (e) {
      totalAmount = 0;
    }

    // cable plans are read when needed (e.g. in modal builders)

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
                    value: currencyFormatter(planAmount),
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Currency',
                    value: 'NGN',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Transaction Type',
                    value: 'Cable TV Purchase',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Plan',
                    value: selectedPlan ?? '',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Smartcard Number',
                    value: smartcardController.text.trim(),
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Customer Name',
                    value: _verifiedUserName ?? '',
                  ),

                  ShareableTransactionReceiptDetail(
                    label: 'Provider',
                    value: selectedProvider,
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

    _handlePinEntry() async {
      final hasEnoughBalance = checkBalanceLeft(
        context,
        user?.wallets.first.balance.toString() ?? '0',
        totalAmount.toString(),
      );

      if (!hasEnoughBalance) return;
      final pin = await TransactionPinModal.show(context);
      if (pin == null || pin.length != 4) return;

      // find selected variation
      final variations = ref.read(cableVariationNotifierProvider).data;
      if (variations == null || variations.isEmpty) {
        AppMessenger.show(
          context,
          message: 'Selected plan not available',
          type: MessageType.warning,
        );

        return;
      }
      final selectedVar = variations.firstWhere(
        (v) => v.name == selectedPlan,
        orElse: () => variations.first,
      );

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        await ref
            .read(cablePaymentNotifierProvider.notifier)
            .payCable(
              CablePayRequest(
                itemCode: selectedVar.itemCode,
                billerCode: selectedVar.billerCode,
                currency: 'NGN',
                billerNumber: smartcardController.text,
                amount: selectedVar.payAmount ?? selectedVar.amount,
                walletPin: pin,
              ),
            );
        Navigator.pop(context);

        final paymentState = ref.read(cablePaymentNotifierProvider);
        if (paymentState.isDataAvailable) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TransactionReceiptWidget(
                    headerText: 'Transaction',
                    amount: planAmount,
                    topDetails: [
                      TransactionDetail(
                        label: 'Plan',
                        value: selectedPlan ?? '',
                      ),
                      TransactionDetail(
                        label: 'Amount',
                        value: currencyFormatter(planAmount),
                      ),
                      TransactionDetail(
                        label: 'Fee',
                        value: currencyFormatter(
                          _verifyResponse?.fee.toString() ?? '0.0',
                        ),
                      ),
                      TransactionDetail(
                        label: 'Total Debit',
                        value: currencyFormatter(totalAmount.toString()),
                      ),
                    ],
                    bottomDetails: [
                      TransactionDetail(
                        label: 'Provider',
                        value: selectedProvider,
                      ),
                      TransactionDetail(
                        label: 'Smartcard Number',
                        value: smartcardController.text,
                      ),
                      TransactionDetail(
                        label: 'Transaction ID',
                        value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                        showCopyIcon: true,
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
            message: paymentState.message ?? 'An error has occured',
            type: MessageType.error,
          );
        }
      } catch (e) {
        if (mounted) {
          AppMessenger.show(
            context,
            message: e.toString(),
            type: MessageType.error,
          );
        }
      }
    }

    _handleBiometricPinEntry() async {
      final hasEnoughBalance = checkBalanceLeft(
        context,
        user?.wallets.first.balance.toString() ?? '0',
        totalAmount.toString(),
      );

      if (!hasEnoughBalance) return;
      final pin = await BiometricTransactionPinModal.show(context);
      if (pin == null || pin.length != 4) return;

      // find selected variation
      final variations = ref.read(cableVariationNotifierProvider).data;
      if (variations == null || variations.isEmpty) {
        AppMessenger.show(
          context,
          message: 'Selected plan not available',
          type: MessageType.warning,
        );

        return;
      }
      final selectedVar = variations.firstWhere(
        (v) => v.name == selectedPlan,
        orElse: () => variations.first,
      );

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        await ref
            .read(cablePaymentNotifierProvider.notifier)
            .payCable(
              CablePayRequest(
                itemCode: selectedVar.itemCode,
                billerCode: selectedVar.billerCode,
                currency: 'NGN',
                billerNumber: smartcardController.text,
                amount: selectedVar.payAmount ?? selectedVar.amount,
                walletPin: pin,
              ),
            );
        Navigator.pop(context);

        final paymentState = ref.read(cablePaymentNotifierProvider);
        if (paymentState.isDataAvailable) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TransactionReceiptWidget(
                    headerText: 'Transaction',
                    amount: planAmount,
                    topDetails: [
                      TransactionDetail(
                        label: 'Plan',
                        value: selectedPlan ?? '',
                      ),
                      TransactionDetail(
                        label: 'Amount',
                        value: currencyFormatter(planAmount),
                      ),
                      TransactionDetail(
                        label: 'Fee',
                        value: currencyFormatter(
                          _verifyResponse?.fee.toString() ?? '0.0',
                        ),
                      ),
                      TransactionDetail(
                        label: 'Total Debit',
                        value: currencyFormatter(totalAmount.toString()),
                      ),
                    ],
                    bottomDetails: [
                      TransactionDetail(
                        label: 'Provider',
                        value: selectedProvider,
                      ),
                      TransactionDetail(
                        label: 'Smartcard Number',
                        value: smartcardController.text,
                      ),
                      TransactionDetail(
                        label: 'Transaction ID',
                        value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                        showCopyIcon: true,
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
            message: paymentState.message ?? 'An error has occured',
            type: MessageType.error,
          );
        }
      } catch (e) {
        if (mounted) {
          AppMessenger.show(
            context,
            message: e.toString(),
            type: MessageType.error,
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cable Tv',
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
                          builder:
                              (context) =>
                                  const CableTvSavedBeneficiaryScreen(),
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
                    'Complete your KYC verification to pay for cable TV subscriptions',
              )
              : Padding(
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
                              selectedProvider,
                              style: TextStyle(fontSize: 16),
                            ),
                            ref
                                    .watch(cablePlansNotifierProvider)
                                    .isInitialLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
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
                      hintText: 'Smartcard Number ',
                      isReadOnly: selectedProvider == 'Select a provider',
                      textInputType: TextInputType.number,
                      showCountryLabel: false,
                      onChanged: (value) async {
                        // Show verify button when user starts typing and clear any previous response
                        setState(() {
                          _verifyResponse = null;
                          _showVerifyButton = value.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Verify Button / Response
                    if (_showVerifyButton && _verifyResponse == null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isVerifying
                                  ? null
                                  : () async {
                                    setState(() {
                                      _isVerifying = true;
                                      _hasError = false;
                                      _verifyResponse = null;
                                      _errorMessage = null;
                                    });

                                    final variations =
                                        ref
                                            .read(
                                              cableVariationNotifierProvider,
                                            )
                                            .data;
                                    if (variations == null ||
                                        variations.isEmpty) {
                                      if (mounted) {
                                        AppMessenger.show(
                                          context,
                                          message:
                                              'Selected plan not available',
                                          type: MessageType.warning,
                                        );
                                      }
                                      setState(() {
                                        _isVerifying = false;
                                      });
                                      return;
                                    }

                                    final selectedVar = variations.firstWhere(
                                      (v) => v.name == selectedPlan,
                                      orElse: () => variations.first,
                                    );

                                    try {
                                      final res = await ref
                                          .read(
                                            cablePaymentNotifierProvider
                                                .notifier,
                                          )
                                          .verifyNumber(
                                            VerifyCableRequest(
                                              itemCode: selectedVar.itemCode,
                                              billerCode:
                                                  selectedVar.billerCode,
                                              billerNumber:
                                                  smartcardController.text,
                                            ),
                                          );

                                      setState(() {
                                        // success path: store typed response and clear error
                                        _verifyResponse = res.data;
                                        _errorMessage = null;
                                        _verifiedUserName =
                                            _verifyResponse?.name;
                                        _showVerifyButton =
                                            false; // remove button once response displays
                                        _hasError = false;
                                        _isVerifying = false;
                                        _errorMessage = res.message;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        _verifyResponse = null;
                                        _verifiedUserName = null;
                                        _showVerifyButton = false;
                                        _hasError = true;
                                        _isVerifying = false;
                                        _errorMessage = e.toString();
                                      });
                                    }
                                  },
                          child:
                              _isVerifying
                                  ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text('Verify'),
                        ),
                      ),

                    if (_verifyResponse != null || _errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              _verifiedUserName != null && _hasError == false
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _verifiedUserName != null && _hasError == false
                                    ? Colors.green
                                    : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _verifiedUserName != null
                                  ? Icons.check_circle
                                  : Icons.info,
                              color:
                                  _verifiedUserName != null
                                      ? Colors.green
                                      : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _verifiedUserName != null && _hasError == false
                                    ? 'Account Name: $_verifiedUserName'
                                    : _errorMessage ?? '',
                                style: TextStyle(
                                  color:
                                      _verifiedUserName != null &&
                                              _hasError == false
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                      onTap:
                          selectedProvider == 'Select a provider'
                              ? null
                              : () => _showPlanSelector(context),
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
                              selectedPlan ?? 'Select a plan',
                              style: TextStyle(fontSize: 16),
                            ),
                            ref
                                    .watch(cableVariationNotifierProvider)
                                    .isInitialLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
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

                    // Current Date
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFF76301).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            planAmount == ' Amount'
                                ? planAmount
                                : currencyFormatter(planAmount),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Pay Cable TV Button
                    FullWidthButton(
                      text: 'Pay Cable TV',
                      onPressed: () async {
                        if (smartcardController.text.isEmpty ||
                            planAmount.isEmpty ||
                            _verifyResponse == null) {
                          return;
                        }

                        // show details and ask for PIN
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ReuseableTransactionDetailsScreen(
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
                                      'Smartcard Number',
                                      smartcardController.text,
                                      isDark,
                                    ),
                                    buildDetailRow(
                                      'Provider',
                                      selectedProvider,
                                      isDark,
                                    ),
                                    buildDetailRow(
                                      'Package',
                                      selectedPlan ?? '',
                                      isDark,
                                    ),
                                    buildDetailRow(
                                      'Amount',
                                      currencyFormatter(planAmount),
                                      isDark,
                                    ),
                                    buildDetailRow(
                                      'Fee',
                                      currencyFormatter(
                                        _verifyResponse?.fee.toString() ??
                                            '0.0',
                                      ),
                                      isDark,
                                    ),
                                    const Divider(),
                                    buildDetailRow(
                                      'Total Amount',
                                      currencyFormatter(totalAmount.toString()),
                                      isDark,
                                      isTotal: true,
                                    ),
                                  ],
                                  onButtonPressed: _handlePinEntry,
                                  onBiometricButtonPressed:
                                      _handleBiometricPinEntry,
                                ),
                          ),
                        );
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
      builder: (context) {
        final plans = ref.read(cablePlansNotifierProvider).data;
        final providers =
            plans != null && plans.isNotEmpty
                ? plans.map((e) => e.planName).toSet().toList()
                : [''];
        return CableTvProviderSelectorModal(
          selectedProvider: selectedProvider,
          providers: providers,
          onProviderSelected: (provider) {
            setState(() {
              selectedProvider = provider;
            });
            // fetch matching biller code and load variations
            if (plans != null && plans.isNotEmpty) {
              final match = plans.firstWhere(
                (p) => p.planName == provider,
                orElse: () => plans.first,
              );
              ref
                  .read(cableVariationNotifierProvider.notifier)
                  .getVariations(billerCode: match.billerCode);
            }
          },
        );
      },
    );
  }

  void _showPlanSelector(BuildContext context) {
    final variations = ref.read(cableVariationNotifierProvider).data;
    final planNames = (variations ?? []).map((v) => v.name).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CableTvPlanSelectorModal(
            selectedPlan: selectedPlan ?? '',
            plans: planNames,
            onPlanSelected: (plan) {
              setState(() {
                selectedPlan = plan;
                if (variations != null && variations.isNotEmpty) {
                  final selectedVar = variations.firstWhere(
                    (v) => v.name == plan,
                    orElse: () => variations.first,
                  );
                  planAmount = (selectedVar.payAmount ?? selectedVar.amount)
                      .toStringAsFixed(0);
                }
              });
            },
          ),
    );
  }
}
