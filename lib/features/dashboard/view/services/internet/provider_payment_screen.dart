import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/current_rate_widget.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/notifiers/internet_notifier.dart';
import 'package:valarpay/features/models/internet_models.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/cabletv_widgets/provider_selector_modal.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/cabletv_widgets/plan_selector_modal.dart';

class InternetProviderPaymentScreen extends ConsumerStatefulWidget {
  final String providerName;

  const InternetProviderPaymentScreen({super.key, required this.providerName});

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedPlan.isEmpty ? 'Select Plan' : selectedPlan),
                    Icon(Icons.keyboard_arrow_down,
                        color: isDark ? Colors.white70 : Colors.grey[600])
                  ]),
            ),
          ),
          const SizedBox(height: 24),
          CurrentRateWidget(
              price: currencyFormatter(amountController.text),
              text: 'Current Rate'),
          const SizedBox(height: 60),
          FullWidthButton(
              text: 'Continue',
              onPressed: () {
                if (accountController.text.isEmpty || selectedPlan.isEmpty)
                  return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReuseableTransactionDetailsScreen(
                              hasBottom: false,
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
                                final pin =
                                    await TransactionPinModal.show(context);
                                if (pin == null || pin.length != 4) return;

                                final variations = ref
                                    .read(internetVariationNotifierProvider)
                                    .data;
                                if (variations == null || variations.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Plan not available')));
                                  return;
                                }
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

                                  if (mounted) {
                                    Navigator.pushReplacement(
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
                                                        label: 'Amount',
                                                        value:
                                                            currencyFormatter(
                                                                amountController
                                                                    .text))
                                                  ],
                                                  bottomDetails: [
                                                    TransactionDetail(
                                                        label:
                                                            'Smartcard Number',
                                                        value: accountController
                                                            .text)
                                                  ],
                                                  onShareReceipt: () {},
                                                )));
                                  }
                                } catch (e) {
                                  if (mounted)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
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
              Navigator.pop(context);
            }));
  }
}
