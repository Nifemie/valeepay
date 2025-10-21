import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/mobile_data_services_section.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/notifiers/data_notifier.dart';
import 'package:valarpay/features/models/data_models.dart';
import 'package:valarpay/features/models/network_provider.dart';

class DataScreen extends ConsumerStatefulWidget {
  const DataScreen({super.key});

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController amountController =
      TextEditingController(text: '0');
  bool _useCashback = false;
  String _selectedNetwork = '';
  int _selectedOperatorId = 0;
  String _selectedPlan = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvidersNotifierProvider.notifier).fetchProviders();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providersState = ref.watch(dataProvidersNotifierProvider);
    final plansState = ref.watch(dataPlansNotifierProvider);

    final networkProviders = providersState.data ?? <NetworkProvider>[];
    final availablePlans = plansState.data ?? <DataPlanInfo>[];

    // Listen for plan errors
    ref.listen<DataState<DataPlanInfo>>(dataPlansNotifierProvider,
        (prev, next) {
      if (next.message != null &&
          !next.isInitialLoading &&
          !next.isDataAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(next.message!), backgroundColor: Colors.red));
      }
    });

    // Listen for variation updates to set amount
    ref.listen<DataState<DataPlan>>(dataVariationNotifierProvider,
        (prev, next) {
      if (!next.isInitialLoading &&
          next.isDataAvailable &&
          next.data != null &&
          next.data!.isNotEmpty) {
        final variation = next.data!.first;
        if (variation.fixedAmounts.isNotEmpty) {
          amountController.text =
              variation.fixedAmounts.first.toStringAsFixed(0);
        }
      }
    });

    // Listen for purchase results
    ref.listen<DataState<DataPurchaseResponse>>(dataPurchaseNotifierProvider,
        (prev, next) {
      if (!next.isInitialLoading &&
          next.isDataAvailable &&
          next.data != null &&
          next.data!.isNotEmpty) {
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => TransactionReceiptWidget(
                      amount: '₦${amountController.text}',
                      topDetails: [
                        TransactionDetail(
                            label: 'Data Plan', value: _selectedPlan)
                      ],
                      bottomDetails: [
                        TransactionDetail(
                            label: 'Recipient Number', value: _controller.text)
                      ],
                      onShareReceipt: () {})));
        }
      } else if (!next.isInitialLoading &&
          next.message != null &&
          !next.isDataAvailable) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(next.message!), backgroundColor: Colors.red));
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Saved Beneficiary',
              style: TextStyle(
                color: appTheme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phone Number',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ReuseableTextFieldWithCountry(
              controller: _controller,
              hintText: "123 567 890",
              countryCode: '+234',
              flagImagePath: 'assets/images/ngflag.png',
              isReadOnly: false,
              textInputType: TextInputType.phone,
              showCountryLabel: true,
              suffixWidget: IconButton(
                onPressed: _showContactAccessDialog,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appTheme.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Network Provider Selection
            _buildNetworkProviderSelector(providersState, networkProviders),
            const SizedBox(height: 24),

            // Data Plans Section
            if (_selectedNetwork.isNotEmpty && availablePlans.isNotEmpty) ...[
              _buildDataPlansSection(plansState, availablePlans),
              const SizedBox(height: 24),
            ],

            // Cashback Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Use Cashback',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '₦50.00',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _useCashback,
                      onChanged: (value) {
                        setState(() {
                          _useCashback = value;
                        });
                      },
                      activeColor: appTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Continue Button
            FullWidthButton(
              text: 'Continue',
              onPressed: _handleContinue,
              isEnabled: _isFormValid(),
            ),
            const SizedBox(height: 24),
            const DataServicesSection(),
          ],
        ),
      ),
    );
  }

  void _showContactAccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContactAccessDialog(
        onAllow: () {
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildNetworkProviderSelector(
      DataState<NetworkProvider>? providersState,
      List<NetworkProvider> networkProviders) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if ((providersState?.isInitialLoading ?? false) &&
        networkProviders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Network Provider',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedNetwork.isEmpty ? null : _selectedNetwork,
              hint: Text(
                'Select Network Provider',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              isExpanded: true,
              dropdownColor: Theme.of(context).cardColor,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
              items: networkProviders.map((provider) {
                return DropdownMenuItem<String>(
                  value: provider.network,
                  child: Text(
                    provider.network,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    _selectedNetwork = value;
                    _selectedPlan = '';
                    _selectedOperatorId = 0;
                  });
                  if (_controller.text.isNotEmpty) {
                    await ref
                        .read(dataPlansNotifierProvider.notifier)
                        .getPlans(phone: _controller.text, currency: 'NGN');
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataPlansSection(
      DataState<DataPlanInfo>? plansState, List<DataPlanInfo> availablePlans) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Data Plan',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPlan.isEmpty ? null : _selectedPlan,
              hint: Text(
                'Select Data Plan',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              isExpanded: true,
              dropdownColor: Theme.of(context).cardColor,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
              items: availablePlans.map((plan) {
                return DropdownMenuItem<String>(
                  value: plan.id,
                  child: Text(
                    plan.planName,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    _selectedPlan = value;
                    final plan =
                        availablePlans.firstWhere((p) => p.id == value);
                    _selectedOperatorId = plan.operatorId;
                  });
                  // Fetch variation for selected operator
                  await ref
                      .read(dataVariationNotifierProvider.notifier)
                      .getVariation(operatorId: _selectedOperatorId);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Check if form is valid
  bool _isFormValid() {
    return _controller.text.isNotEmpty &&
        _selectedNetwork.isNotEmpty &&
        _selectedPlan.isNotEmpty &&
        _selectedOperatorId > 0;
  }

  // Handle continue button press
  void _handleContinue() {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedPlanInfo = (ref.read(dataPlansNotifierProvider).data ?? [])
        .firstWhere((p) => p.id == _selectedPlan);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReuseableTransactionDetailsScreen(
          hasBottom: false,
          topTitleText: 'Transaction',
          topTransactionsDetailsList: [
            buildDetailRow('Recipient Number', _controller.text, isDark),
            buildDetailRow('Provider', _selectedNetwork, isDark),
            buildDetailRow('Data Plan', selectedPlanInfo.planName, isDark),
          ],
          onButtonPressed: _handlePinEntry,
        ),
      ),
    );
  }

  // Handle PIN entry and purchase
  Future<void> _handlePinEntry() async {
    final pin = await TransactionPinModal.show(context);
    if (pin == null || pin.length != 4) return;

    if (!mounted) return;
    Navigator.pop(context); // Close transaction details screen

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final amount = double.tryParse(amountController.text) ?? 0;

      final request = DataPurchaseRequest(
        walletPin: pin,
        amount: amount,
        operatorId: _selectedOperatorId,
        phone: _controller.text,
        currency: 'NGN',
        addBeneficiary: false,
      );

      await ref.read(dataPurchaseNotifierProvider.notifier).purchase(request);
      if (!mounted) return;
      Navigator.pop(context); // close loading dialog

      // result handling via ref.listen on purchase provider
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Purchase failed: ${e.toString()}'),
          backgroundColor: Colors.red));
    }
  }
}
