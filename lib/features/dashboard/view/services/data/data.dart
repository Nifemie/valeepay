import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/mobile_data_services_section.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/notifiers/data_notifier.dart';
import 'package:valarpay/features/models/data_models.dart';
import 'package:valarpay/core/widgets/kyc_not_set_widget.dart';
import 'package:valarpay/features/providers/user_provider.dart';

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
    // Don't fetch providers on init - wait for phone number to be entered
  }

  @override
  void dispose() {
    _controller.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        final user = ref.watch(userProvider);
    final isBvnVerified = user?.isBvnVerified ?? false;
    final plansState = ref.watch(dataPlansNotifierProvider);
    final availablePlans = plansState.data ?? <DataPlanInfo>[];

    // Extract unique networks from plans
    final uniqueNetworks =
        availablePlans.map((plan) => plan.network).toSet().toList();

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
          setState(() {
            amountController.text =
                variation.fixedAmounts.first.toStringAsFixed(0);
          });
        }
      }
    });

    // Listen for purchase results
    ref.listen<DataState<DataPurchaseResponse>>(dataPurchaseNotifierProvider,
        (prev, next) {
      if (!next.isInitialLoading &&
          next.message != null &&
          !next.isDataAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(next.message!), backgroundColor: Colors.red));
        }
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
        actions: isBvnVerified
            ? [
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
              ]
            : null,
      ),
      body: !isBvnVerified
          ? const KycNotSetWidget(
              title: 'KYC Not Completed',
              subtitle: 'Complete your KYC verification to purchase data',
            )
          : SingleChildScrollView(
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
              onChanged: (value) {
                // Auto-fetch plans when phone number is complete (10 digits)
                if (value.length >= 10) {
                  ref
                      .read(dataPlansNotifierProvider.notifier)
                      .getPlans(phone: value, currency: 'NGN');
                }
              },
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
            _buildNetworkProviderSelector(
                plansState, uniqueNetworks, availablePlans),
            const SizedBox(height: 24),

            // Data Amount Selection (from fixed amounts)
            if (_selectedNetwork.isNotEmpty) ...[
              _buildDataAmountSection(),
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

  Widget _buildNetworkProviderSelector(DataState<DataPlanInfo>? plansState,
      List<String> uniqueNetworks, List<DataPlanInfo> availablePlans) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Debug: Check if plans are loaded
    print('Available Plans Count: ${availablePlans.length}');
    print('Unique Networks: $uniqueNetworks');

    if ((plansState?.isInitialLoading ?? false) && availablePlans.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show message if no plans/networks
    if (uniqueNetworks.isEmpty) {
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
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: const Text(
              'Enter phone number to see available networks',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
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
              items: uniqueNetworks.map((network) {
                return DropdownMenuItem<String>(
                  value: network,
                  child: Text(
                    network,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  // Find a plan from this network to get operatorId
                  final networkPlan =
                      availablePlans.firstWhere((p) => p.network == value);
                  setState(() {
                    _selectedNetwork = value;
                    _selectedPlan = '';
                    _selectedOperatorId = networkPlan.operatorId;
                  });

                  // Fetch variation to get fixed amounts
                  await ref
                      .read(dataVariationNotifierProvider.notifier)
                      .getVariation(operatorId: networkPlan.operatorId);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataAmountSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final variationState = ref.watch(dataVariationNotifierProvider);
    final dataVariations = variationState.data ?? <DataPlan>[];

    // Get fixed amounts from the first variation (there's usually only one)
    final fixedAmounts = dataVariations.isNotEmpty
        ? dataVariations.first.fixedAmounts
        : <double>[];

    // Get descriptions if available
    final descriptions = dataVariations.isNotEmpty
        ? dataVariations.first.fixedAmountsDescriptions
        : <String, dynamic>{};

    if (variationState.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fixedAmounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No data plans available for this network',
          style: TextStyle(color: Colors.orange),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Data Amount',
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
                'Select Data Amount',
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
              items: fixedAmounts.map((amount) {
                final amountKey = amount.toStringAsFixed(0);
                final description = descriptions[amountKey] ?? '';
                final displayText = description.isNotEmpty
                    ? '$description - ₦${amount.toStringAsFixed(0)}'
                    : '₦${amount.toStringAsFixed(0)}';

                return DropdownMenuItem<String>(
                  value: amount.toString(),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPlan = value;
                    amountController.text =
                        double.parse(value).toStringAsFixed(0);
                  });
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
    final dataVariations = ref.read(dataVariationNotifierProvider).data ?? [];
    final descriptions = dataVariations.isNotEmpty
        ? dataVariations.first.fixedAmountsDescriptions
        : <String, dynamic>{};

    // Get description for selected amount
    final amountKey = double.parse(_selectedPlan).toStringAsFixed(0);
    final planDescription =
        descriptions[amountKey] ?? '₦${amountController.text} Data';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReuseableTransactionDetailsScreen(
          hasBottom: false,
          topTitleText: 'Transaction',
          topTransactionsDetailsList: [
            buildDetailRow('Recipient Number', _controller.text, isDark),
            buildDetailRow('Provider', _selectedNetwork, isDark),
            buildDetailRow('Data Plan', planDescription, isDark),
            buildDetailRow('Amount', '₦${amountController.text}', isDark),
          ],
          onButtonPressed: _handlePinEntry,
        ),
      ),
    );
  }

  // Handle PIN entry and purchase
  Future<void> _handlePinEntry() async {
    final pin = await BiometricTransactionPinModal.show(context);
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

      print('🔐 [Data] Initiating data purchase...');
      await ref.read(dataPurchaseNotifierProvider.notifier).purchase(request);
      print('📤 [Data] Data purchase request sent');

      // Use post frame callback to close dialog and navigate after frame completes
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            print('⚠️ [Data] Widget not mounted in postFrameCallback');
            return;
          }

          // Close loading dialog
          if (Navigator.canPop(context)) {
            print('📤 [Data] Closing loading dialog');
            Navigator.pop(context);
          }

          // Small delay to ensure loading dialog is fully closed
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!mounted) {
              print('⚠️ [Data] Widget not mounted after delay');
              return;
            }

            // Check the state and navigate
            final state = ref.read(dataPurchaseNotifierProvider);
            print('🎧 [Data] State check:');
            print('   - isDataAvailable: ${state.isDataAvailable}');
            print('   - message: ${state.message}');
            print('   - data: ${state.data}');
            
            // Check for success via message (like airtime)
            final isSuccessMessage = state.message != null && 
                state.message!.toLowerCase().contains('success');
            
            if ((state.isDataAvailable &&
                state.data != null &&
                state.data!.isNotEmpty) || isSuccessMessage) {
              print('✅ [Data] Purchase successful, navigating to receipt');
              // Get description for selected amount
              final dataVariations =
                  ref.read(dataVariationNotifierProvider).data ?? [];
              final descriptions = dataVariations.isNotEmpty
                  ? dataVariations.first.fixedAmountsDescriptions
                  : <String, dynamic>{};
              final amountKey = double.parse(_selectedPlan).toStringAsFixed(0);
              final planDescription =
                  descriptions[amountKey] ?? '₦${amountController.text} Data';

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionReceiptWidget(
                    amount: '₦${amountController.text}',
                    topDetails: [
                      TransactionDetail(
                          label: 'Transaction ID',
                          value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                          showCopyIcon: true),
                      TransactionDetail(
                          label: 'Recipient Number', value: _controller.text),
                      TransactionDetail(
                          label: 'Network', value: _selectedNetwork),
                      TransactionDetail(
                          label: 'Data Plan', value: planDescription),
                      TransactionDetail(
                          label: 'Amount', value: '₦${amountController.text}'),
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
        });
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // close loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Purchase failed: ${e.toString()}'),
            backgroundColor: Colors.red));
      }
    }
  }
}
