import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/themes/color_utils.dart';
// app_messenger not used here
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/airtime_services_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/providers/airtime_providers.dart';
import 'package:valarpay/features/models/network_provider.dart';
import 'package:valarpay/features/models/airtime_models.dart';
import 'package:valarpay/features/notifiers/airtime_notifier.dart';

/// Clean AirtimeScreen implementation. Use this file instead of the legacy `airtime.dart`.
class AirtimeScreen extends ConsumerStatefulWidget {
  const AirtimeScreen({super.key});

  @override
  ConsumerState<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends ConsumerState<AirtimeScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(airtimeProvidersNotifierProvider.notifier).fetchProviders();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showContactAccessDialog() => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ContactAccessDialog(
            onAllow: () => Navigator.of(context).pop(),
            onCancel: () => Navigator.of(context).pop()),
      );

  bool _isFormValid(String network, int operatorId) {
    return _controller.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        network.isNotEmpty &&
        operatorId > 0;
  }

  Future<void> _handlePinEntry() async {
    final pin = await TransactionPinModal.show(context);
    if (pin == null || pin.length != 4) return;
    if (!mounted) return;

    // Close details screen first
    Navigator.pop(context);

    // Show loading dialog
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final operatorId = ref.read(airtimeSelectedOperatorIdProvider);
      final request = AirtimePurchaseRequest(
        walletPin: pin,
        amount: double.parse(_amountController.text),
        operatorId: operatorId,
        phone: _controller.text,
        currency: 'NGN',
        addBeneficiary: false,
      );

      await ref
          .read(airtimePurchaseNotifierProvider.notifier)
          .purchase(request);

      // Use post frame callback to close dialog and navigate after frame completes
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          // Close loading dialog
          Navigator.pop(context);

          // Check the state and navigate
          final state = ref.read(airtimePurchaseNotifierProvider);
          if (state.isDataAvailable &&
              state.data != null &&
              state.data!.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransactionReceiptWidget(
                  amount: '₦${_amountController.text}',
                  topDetails: [
                    TransactionDetail(
                        label: 'Transaction ID',
                        value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                        showCopyIcon: true),
                    TransactionDetail(
                        label: 'Recipient Number', value: _controller.text),
                    TransactionDetail(
                        label: 'Network',
                        value: ref.read(airtimeSelectedNetworkProvider)),
                    TransactionDetail(
                        label: 'Amount', value: '₦${_amountController.text}'),
                  ],
                  onShareReceipt: () {},
                ),
              ),
            );
          } else if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message!), backgroundColor: Colors.red));
          }
        });
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // close loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red));
      }
    }
  }

  void _navigateToDetails(String selectedNetwork, int selectedOperatorId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReuseableTransactionDetailsScreen(
          hasBottom: false,
          topTitleText: 'Transaction',
          topTransactionsDetailsList: [
            buildDetailRow('Recipient Number', _controller.text, isDark),
            buildDetailRow('Provider', selectedNetwork, isDark),
            buildDetailRow(
                'Amount', currencyFormatter(_amountController.text), isDark),
          ],
          onButtonPressed: _handlePinEntry,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useCashback = ref.watch(airtimeUseCashbackProvider);
    final selectedNetwork = ref.watch(airtimeSelectedNetworkProvider);
    final selectedOperatorId = ref.watch(airtimeSelectedOperatorIdProvider);

    final providersState = ref.watch(airtimeProvidersNotifierProvider);
    final networkProviders = providersState.data ?? <NetworkProvider>[];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: const Text('Airtime',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            const Text('Phone Number',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            ReuseableTextFieldWithCountry(
                controller: _controller,
                countryCode: '+234 ',
                flagImagePath: 'assets/images/ngflag.png',
                hintText: '123 456 789',
                isReadOnly: false,
                textInputType: TextInputType.phone,
                showCountryLabel: true,
                suffixWidget: IconButton(
                    onPressed: _showContactAccessDialog,
                    icon: const Icon(Icons.person))),
            const SizedBox(height: 24),
            const Text('Network Provider',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300)),
              child: providersState.isInitialLoading && networkProviders.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          value:
                              selectedNetwork.isEmpty ? null : selectedNetwork,
                          hint: const Text('Select Network Provider'),
                          isExpanded: true,
                          items: networkProviders
                              .map((p) => DropdownMenuItem(
                                  value: p.network, child: Text(p.network)))
                              .toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            final provider = networkProviders
                                .firstWhere((p) => p.network == value);
                            ref
                                .read(airtimeSelectedNetworkProvider.notifier)
                                .state = value;
                            ref
                                .read(
                                    airtimeSelectedOperatorIdProvider.notifier)
                                .state = provider.operatorId;
                            if (_controller.text.isNotEmpty) {
                              await ref
                                  .read(airtimePlanNotifierProvider.notifier)
                                  .getPlan(
                                      phone: _controller.text, currency: 'NGN');
                            }
                          })),
            ),
            const SizedBox(height: 24),
            const Text('Amount',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            ReuseableAmountTextfield(
                amountController: _amountController,
                prefixText: '₦',
                hintText: '500'),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Expanded(
                  child: Text('Use Cashback',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500))),
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('₦50.00',
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(width: 8),
                Switch(
                    value: useCashback,
                    onChanged: (v) =>
                        ref.read(airtimeUseCashbackProvider.notifier).state = v,
                    activeTrackColor: appTheme.primaryColor)
              ])
            ]),
            const SizedBox(height: 32),
            FullWidthButton(
                text: 'Continue',
                onPressed: () =>
                    _navigateToDetails(selectedNetwork, selectedOperatorId),
                isEnabled: _isFormValid(selectedNetwork, selectedOperatorId)),
            const SizedBox(height: 32),
            const AirtimeServicesSection(),
          ]),
        ),
      ),
    );
  }
}
