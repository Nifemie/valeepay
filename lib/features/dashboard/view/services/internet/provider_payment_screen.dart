import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/current_rate_widget.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/notifiers/internet_notifier.dart';
import 'package:valarpay/features/models/internet_models.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/cabletv_widgets/provider_selector_modal.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/cabletv_widgets/plan_selector_modal.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class InternetProviderPaymentScreen extends ConsumerStatefulWidget {
  String providerName;

  InternetProviderPaymentScreen({super.key, required this.providerName});

  @override
  ConsumerState<InternetProviderPaymentScreen> createState() =>
      _InternetProviderPaymentScreenState();
}

class _InternetProviderPaymentScreenState
    extends ConsumerState<InternetProviderPaymentScreen> {
  String selectedProvider = '';
  final TextEditingController accountController = TextEditingController();
  String selectedPlan = '';
  final TextEditingController amountController =
      TextEditingController(text: '0');
  String serviceFee = '0';
  bool saveBeneficiary = false;

  @override
  void initState() {
    super.initState();
    selectedProvider = widget.providerName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plans = ref.read(internetPlansNotifierProvider).data;
      if (plans != null && plans.isNotEmpty) {
        final match = plans.firstWhere((p) => p.planName == selectedProvider,
            orElse: () => plans.first);
        ref
            .read(internetVariationNotifierProvider.notifier)
            .getVariations(billerCode: match.billerCode);
      }
    });
  }

  @override
  void dispose() {
    accountController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final variationsState = ref.watch(internetVariationNotifierProvider);

    final planNames = variationsState.data?.map((v) => v.name).toList() ?? [];

    _onShareTransactionReceiptPressed() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReceiptShareScreen(
                    date:
                        '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                    transactionDetailList: [
                      ShareableTransactionReceiptDetail(
                          label: 'Amount',
                          value: currencyFormatter(
                              amountController.text..replaceAll(',', ''))),
                      ShareableTransactionReceiptDetail(
                          label: 'Currency', value: 'NGN'),
                      ShareableTransactionReceiptDetail(
                          label: 'Transaction Type', value: 'Internet'),
                      ShareableTransactionReceiptDetail(
                          label: 'Beneficiay Number',
                          value: accountController.text.trim()),
                      ShareableTransactionReceiptDetail(
                          label: 'Provider', value: selectedProvider),
                      ShareableTransactionReceiptDetail(
                          label: 'Transaction ID',
                          value: 'TXN${DateTime.now().millisecondsSinceEpoch}'),
                      ShareableTransactionReceiptDetail(
                          label: 'Status',
                          value: 'Successful',
                          isSuccessful: true)
                    ],
                  )));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.providerName),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text('Saved Beneficiary',
                  style: TextStyle(color: Color(0xFFF76301))))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Select Provider',
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                  fontSize: 14)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showProviderSelector(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedProvider),
                    Icon(Icons.keyboard_arrow_down,
                        color: isDark ? Colors.white70 : Colors.grey[600])
                  ]),
            ),
          ),
          const SizedBox(height: 24),
          Text('Account Number',
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                  fontSize: 14)),
          const SizedBox(height: 8),
          ReuseableTextFieldWithCountry(
              controller: accountController,
              hintText: 'Account/Subscriber Number',
              isReadOnly: false,
              textInputType: TextInputType.number,
              showCountryLabel: false),
          const SizedBox(height: 24),
          Text('Select Plan',
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                  fontSize: 14)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showPlanSelector(context, planNames),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedPlan.isEmpty ? 'Select Plan' : selectedPlan),
                    variationsState.isInitialLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.keyboard_arrow_down,
                            color: isDark ? Colors.white70 : Colors.grey[600])
                  ]),
            ),
          ),
          const SizedBox(height: 24),
          CurrentRateWidget(
              price: amountController.text.trim(), text: 'Current Rate'),
          const SizedBox(height: 60),
          FullWidthButton(
              text: 'Continue',
              onPressed: () {
                if (accountController.text.isEmpty || selectedPlan.isEmpty) {
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReuseableTransactionDetailsScreen(
                              hasBottom: false,
                              saveBeneficiary: saveBeneficiary,
                              onSaveBeneficiaryChanged: (value) {
                                setState(() {
                                  saveBeneficiary = value;
                                });
                              },
                              topTitleText: 'Transaction',
                              topTransactionsDetailsList: [
                                buildDetailRow(
                                    'Account', accountController.text, isDark),
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
                                final totalAmount =
                                    int.parse(amountController.text) +
                                        int.parse(serviceFee);
                                final user = ref.read(userProvider);
                                final hasEnoughBalance = checkBalanceLeft(
                                    context,
                                    user?.wallets.first.balance.toString() ??
                                        '0',
                                    totalAmount.toString());
                                if (!hasEnoughBalance) return;
                                final pin =
                                    await BiometricTransactionPinModal.show(
                                        context);
                                if (pin == null || pin.length != 4) return;

                                final variations = ref
                                    .read(internetVariationNotifierProvider)
                                    .data;
                                if (variations == null || variations.isEmpty) {
                                  AppMessenger.show(context,
                                      message: 'Plan not available',
                                      type: MessageType.error);

                                  return;
                                }

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                final selectedVar = variations.firstWhere(
                                    (v) => v.name == selectedPlan,
                                    orElse: () => variations.first);

                                try {
                                  await ref
                                      .read(internetPaymentNotifierProvider
                                          .notifier)
                                      .payInternet(
                                        InternetPayRequest(
                                          walletPin: pin,
                                          itemCode: selectedVar.itemCode,
                                          billerCode: selectedVar.billerCode,
                                          currency: 'NGN',
                                          amount: selectedVar.payAmount ??
                                              selectedVar.amount,
                                          billerNumber: accountController.text,
                                        ),
                                      );
                                  final state =
                                      ref.read(internetPaymentNotifierProvider);

                                  if (state.isDataAvailable &&
                                      state.data != null &&
                                      state.data!.isNotEmpty &&
                                      mounted) {
                                    Navigator.pop(
                                        context); // Close the loading dialog
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionReceiptWidget(
                                                  amount: (selectedVar
                                                              .payAmount ??
                                                          selectedVar.amount)
                                                      .toString(),
                                                  topDetails: [
                                                    TransactionDetail(
                                                        label: 'Plan',
                                                        value: selectedPlan),
                                                    TransactionDetail(
                                                        label: 'Provider',
                                                        value:
                                                            selectedProvider),
                                                    TransactionDetail(
                                                        label: 'Amount',
                                                        value:
                                                            currencyFormatter(
                                                                amountController
                                                                    .text))
                                                  ],
                                                  bottomDetails: [
                                                    TransactionDetail(
                                                      label: 'Transaction ID',
                                                      value:
                                                          'TXN${DateTime.now().millisecondsSinceEpoch}',
                                                      showCopyIcon: true,
                                                    ),
                                                    TransactionDetail(
                                                        label: 'Account Number',
                                                        value: accountController
                                                            .text),
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
                                                  onShareReceipt:
                                                      _onShareTransactionReceiptPressed,
                                                )));
                                  } else {
                                    Navigator.pop(context); // Close the dialog
                                    AppMessenger.show(context,
                                        message:
                                            state.message ?? 'Payment failed',
                                        type: MessageType.error);
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    AppMessenger.show(context,
                                        message: e.toString(),
                                        type: MessageType.error);
                                  }
                                }
                              },
                            )));
              })
        ]),
      ),
    );
  }

  void _showProviderSelector(BuildContext context) {
    final plans = ref.read(internetPlansNotifierProvider).data ?? [];
    final providers = plans.map((e) => e.planName).toList();
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => CableTvProviderSelectorModal(
            selectedProvider: selectedProvider,
            providers: providers,
            onProviderSelected: (provider) {
              setState(() {
                selectedProvider = provider;
                widget.providerName = provider;
              });
              final match = plans.firstWhere((p) => p.planName == provider,
                  orElse: () => plans.first);
              ref
                  .read(internetVariationNotifierProvider.notifier)
                  .getVariations(billerCode: match.billerCode);
            }));
  }

  void _showPlanSelector(BuildContext context, List<String> planNames) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => CableTvPlanSelectorModal(
            selectedPlan: selectedPlan,
            plans: planNames,
            onPlanSelected: (plan) {
              setState(() {
                selectedPlan = plan;
                final variations =
                    ref.read(internetVariationNotifierProvider).data;
                if (variations != null && variations.isNotEmpty) {
                  final selectedVar = variations.firstWhere(
                      (v) => v.name == plan,
                      orElse: () => variations.first);
                  amountController.text =
                      (selectedVar.payAmount ?? selectedVar.amount)
                          .toStringAsFixed(0);
                }
              });
            }));
  }
}
