import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/me/account_statement.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/mobile_data_services_section.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/notifiers/data_notifier.dart';
import 'package:valarpay/features/models/data_models.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/network_provider_selector.dart';
import 'package:valarpay/features/models/network_provider.dart';
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
        AppMessenger.show(context,
            message: next.message!, type: MessageType.error);
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
          AppMessenger.show(context,
              message: next.message!, type: MessageType.error);
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
                        // setState(() {
                        //   availablePlans = [];
                        // });
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
          _pickContact();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _pickContact() async {
    try {
      // 🔹 First, check permission status
      final status = await Permission.contacts.status;

      if (status.isDenied || status.isRestricted) {
        final result = await Permission.contacts.request();
        if (!result.isGranted) {
          AppMessenger.show(
            context,
            message: 'Contacts permission denied',
            type: MessageType.error,
          );
          return;
        }
      } else if (status.isPermanentlyDenied) {
        AppMessenger.show(
          context,
          message:
              'Contacts permission permanently denied. Please enable it in settings.',
          type: MessageType.error,
        );
        await openAppSettings();
        return;
      }

      // ✅ Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // ✅ Fetch contacts
      final contacts = await FlutterContacts.getContacts(withProperties: true);

      if (Navigator.canPop(context)) Navigator.pop(context); // close loading

      final contactList = contacts
          .where((c) => (c.phones.isNotEmpty) || (c.emails.isNotEmpty))
          .toList();

      if (contactList.isEmpty) {
        AppMessenger.show(
          context,
          message: 'No contacts with phone numbers found',
          type: MessageType.error,
        );
        return;
      }

      // ✅ Show searchable contact list
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          final TextEditingController searchController =
              TextEditingController();
          List<Contact> filteredContacts = List.from(contactList);

          return StatefulBuilder(
            builder: (context, setModalState) {
              void _filterContacts(String query) {
                query = query.toLowerCase();
                setModalState(() {
                  filteredContacts = contactList.where((c) {
                    final name = c.displayName.toLowerCase();
                    final phone = c.phones.isNotEmpty
                        ? c.phones.first.number.toLowerCase()
                        : '';
                    return name.contains(query) || phone.contains(query);
                  }).toList();
                });
              }

              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Select contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // 🔍 Search Field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search contact...',
                            filled: true,
                            fillColor:
                                Theme.of(context).cardColor.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: _filterContacts,
                        ),
                      ),

                      // Contact list
                      SizedBox(
                        height: 450,
                        child: filteredContacts.isEmpty
                            ? const Center(
                                child: Text(
                                  'No contacts found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredContacts.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final c = filteredContacts[index];
                                  final phone = c.phones.isNotEmpty
                                      ? c.phones.first.number
                                      : '';
                                  final displayName = c.displayName.isNotEmpty
                                      ? c.displayName
                                      : phone;

                                  return ListTile(
                                    title: Text(displayName),
                                    subtitle: Text(phone),
                                    onTap: () async {
                                      final formatted = _formatTo11(phone);
                                      setState(() {
                                        _controller.text = formatted;
                                      });

                                      final digitsOnly = formatted.replaceAll(
                                          RegExp(r'\D'), '');
                                      if (digitsOnly.length >= 10) {
                                        await ref
                                            .read(dataPlansNotifierProvider
                                                .notifier)
                                            .getPlans(
                                                phone: formatted,
                                                currency: 'NGN');
                                      }

                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      AppMessenger.show(
        context,
        message: 'Failed to load contacts',
        type: MessageType.error,
      );
    }
  }

  String _formatTo11(String raw) {
    if (raw.isEmpty) return raw;
    var digits = raw.replaceAll(RegExp(r'\D'), '');

    // If starts with country code '234', strip it
    if (digits.startsWith('234')) {
      final rest = digits.substring(3);
      if (rest.length == 10) return '0$rest';
      if (rest.length == 11 && rest.startsWith('0')) return rest;
      // fallback to last 10 digits
      if (rest.length > 10) return '0' + rest.substring(rest.length - 10);
    }

    // If starts with leading '+' (already stripped) or other
    if (digits.length == 11 && digits.startsWith('0')) return digits;
    if (digits.length == 10) return '0$digits';
    if (digits.length > 11) return '0' + digits.substring(digits.length - 10);

    // otherwise return as-is
    return digits;
  }

  Widget _buildNetworkProviderSelector(DataState<DataPlanInfo>? plansState,
      List<String> uniqueNetworks, List<DataPlanInfo> availablePlans) {
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
          child: (plansState?.isInitialLoading ?? false) &&
                  availablePlans.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Builder(builder: (context) {
                  // Map DataPlanInfo to NetworkProvider for the selector
                  final providerModels = availablePlans
                      .map((p) => NetworkProvider(
                            id: p.id,
                            planName: p.planName,
                            network: p.network,
                            countryISOCode: p.countryISOCode,
                            operatorId: p.operatorId,
                            createdAt: p.createdAt,
                            updatedAt: p.updatedAt,
                          ))
                      .toList();

                  return NetworkProviderSelector(
                    selectedNetwork: _selectedNetwork,
                    providers: providerModels,
                    onNetworkSelected: (value) async {
                      if (value.isEmpty) return;
                      try {
                        final plan = availablePlans
                            .firstWhere((p) => p.network == value);
                        setState(() {
                          _selectedNetwork = value;
                          _selectedPlan = '';
                          _selectedOperatorId = plan.operatorId;
                        });

                        await ref
                            .read(dataVariationNotifierProvider.notifier)
                            .getVariation(operatorId: plan.operatorId);
                      } catch (e) {
                        print('⚠️ [Data] Selected provider not found: $value');
                      }
                    },
                  );
                }),
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

   _onShareTransactionReceiptPressed() {
     final dataVariations =
                  ref.read(dataVariationNotifierProvider).data ?? [];
              final descriptions = dataVariations.isNotEmpty
                  ? dataVariations.first.fixedAmountsDescriptions
                  : <String, dynamic>{};
              final amountKey = double.parse(_selectedPlan).toStringAsFixed(0);
              final planDescription =
                  descriptions[amountKey] ?? '₦ ${amountController.text} Data';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReceiptShareScreen(
                    date:
                        '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                    transactionDetailList: [
                      ShareableTransactionReceiptDetail(
                          label: 'Amount',
                          value:  currencyFormatter(amountController.text..replaceAll(',', ''))),
                      ShareableTransactionReceiptDetail(
                          label: 'Currency', value: 'NGN'),
                      ShareableTransactionReceiptDetail(
                          label: 'Transaction Type',
                          value: 'Data Purchase'),
                      ShareableTransactionReceiptDetail(
                          label: 'Provider',
                          value: _selectedNetwork),
                       ShareableTransactionReceiptDetail(
                          label: 'Plan',
                          value: planDescription),
                      ShareableTransactionReceiptDetail(
                          label: 'Beneficiary Number',
                          value:
                              _controller.text.trim()),
                     
                      
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

   

  // Handle continue button press
  void _handleContinue() {
    if (!_isFormValid()) {
      AppMessenger.show(context,
          message: 'Please fill all required fields', type: MessageType.error);

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
    final user = ref.read(userProvider);
    final hasEnoughBalance = checkBalanceLeft(
                                    context,
                                    user?.wallets.first.balance.toString() ??
                                        '0',
                                    amountController.text.replaceAll(',', ''));
          if (!hasEnoughBalance) return;
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
                    state.data!.isNotEmpty) ||
                isSuccessMessage) {
              print('✅ [Data] Purchase successful, navigating to receipt');
              // Get description for selected amount
              final dataVariations =
                  ref.read(dataVariationNotifierProvider).data ?? [];
              final descriptions = dataVariations.isNotEmpty
                  ? dataVariations.first.fixedAmountsDescriptions
                  : <String, dynamic>{};
              final amountKey = double.parse(_selectedPlan).toStringAsFixed(0);
              final planDescription =
                  descriptions[amountKey] ?? '₦ ${amountController.text} Data';

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionReceiptWidget(
                    amount: currencyFormatter(amountController.text..replaceAll(',', '')),
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
                          label: 'Amount', value: currencyFormatter(amountController.text..replaceAll(',', ''))),
                    ],
                    onShareReceipt: _onShareTransactionReceiptPressed,
                  ),
                ),
              );
            } else if (state.message != null) {
              AppMessenger.show(context,
                  message: state.message!, type: MessageType.error);
            }
          });
        });
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // close loading
      if (mounted) {
        AppMessenger.show(context,
            message: 'Purchase failed: ${e.toString()}',
            type: MessageType.error);
      }
    }
  }
}
