import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'saved_beneficiary_screen.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
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
  String selectedProvider = 'DStv';
  final TextEditingController smartcardController = TextEditingController();
  String selectedPlan = 'Plan A';
  String planAmount = '6500'; // This will need to be dynamic later

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

    // cable plans are read when needed (e.g. in modal builders)

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cable Tv',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: isBvnVerified
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CableTvSavedBeneficiaryScreen(),
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
              ]
            : null,
      ),
      body: !isBvnVerified
          ? const KycNotSetWidget(
              title: 'KYC Not Completed',
              subtitle: 'Complete your KYC verification to pay for cable TV subscriptions',
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
                hintText: 'Smartcard Number ',
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

            // Current Date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF76301),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₦${planAmount}',
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
                  if (smartcardController.text.isEmpty || planAmount.isEmpty)
                    return;

                  // show details and ask for PIN
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReuseableTransactionDetailsScreen(
                        hasBottom: false,
                        topTitleText: 'Transaction',
                        topTransactionsDetailsList: [
                          buildDetailRow('Provider', selectedProvider, isDark),
                          buildDetailRow('Smartcard Number',
                              smartcardController.text, isDark),
                          buildDetailRow('Plan', selectedPlan, isDark),
                          buildDetailRow('Amount', '₦${planAmount}', isDark),
                          const Divider(),
                          buildDetailRow(
                              'Total Amount', '₦${planAmount}', isDark,
                              isTotal: true)
                        ],
                        onButtonPressed: () async {
                          final pin = await TransactionPinModal.show(context);
                          if (pin == null || pin.length != 4) return;

                          // find selected variation
                          final variations =
                              ref.read(cableVariationNotifierProvider).data;
                          if (variations == null || variations.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Selected plan not available')));
                            return;
                          }
                          final selectedVar = variations.firstWhere(
                              (v) => v.name == selectedPlan,
                              orElse: () => variations.first);

                          try {
                            await ref
                                .read(cablePaymentNotifierProvider.notifier)
                                .verifyNumber(
                                  VerifyCableRequest(
                                    itemCode: selectedVar.itemCode,
                                    billerCode: selectedVar.billerCode,
                                    billerNumber: smartcardController.text,
                                  ),
                                );

                            await ref
                                .read(cablePaymentNotifierProvider.notifier)
                                .payCable(
                                  CablePayRequest(
                                    itemCode: selectedVar.itemCode,
                                    billerCode: selectedVar.billerCode,
                                    currency: 'NGN',
                                    billerNumber: smartcardController.text,
                                    amount: selectedVar.payAmount ??
                                        selectedVar.amount,
                                  ),
                                );

                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransactionReceiptWidget(
                                    amount: planAmount,
                                    topDetails: [
                                      TransactionDetail(
                                          label: 'Provider',
                                          value: selectedProvider),
                                      TransactionDetail(
                                          label: 'Smartcard Number',
                                          value: smartcardController.text),
                                      TransactionDetail(
                                          label: 'Plan', value: selectedPlan),
                                    ],
                                    onShareReceipt: () {},
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted)
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                          }
                        },
                      ),
                    ),
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
      builder: (context) {
        final plans = ref.read(cablePlansNotifierProvider).data;
        final providers = plans != null && plans.isNotEmpty
            ? plans.map((e) => e.planName).toSet().toList()
            : ['DStv', 'GOtv', 'Startimes'];
        return CableTvProviderSelectorModal(
          selectedProvider: selectedProvider,
          providers: providers,
          onProviderSelected: (provider) {
            setState(() {
              selectedProvider = provider;
            });
            // fetch matching biller code and load variations
            if (plans != null && plans.isNotEmpty) {
              final match = plans.firstWhere((p) => p.planName == provider,
                  orElse: () => plans.first);
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
      builder: (context) => CableTvPlanSelectorModal(
        selectedPlan: selectedPlan,
        plans: planNames,
        onPlanSelected: (plan) {
          setState(() {
            selectedPlan = plan;
            if (variations != null && variations.isNotEmpty) {
              final selectedVar = variations.firstWhere((v) => v.name == plan,
                  orElse: () => variations.first);
              planAmount = (selectedVar.payAmount ?? selectedVar.amount)
                  .toStringAsFixed(0);
            }
          });
        },
      ),
    );
  }
}
