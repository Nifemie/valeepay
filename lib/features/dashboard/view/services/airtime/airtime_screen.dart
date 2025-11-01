import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
// app_messenger not used here
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/kyc_not_set_widget.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/airtime_services_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/network_provider_selector.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/providers/airtime_providers.dart';
import 'package:valarpay/features/providers/user_provider.dart';
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
  final NumberFormat formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(airtimeProvidersNotifierProvider.notifier).fetchProviders();
    });
    _amountController.addListener(() {
      final text = _amountController.text.replaceAll(',', '');
      if (text.isEmpty) return;

      // Prevent recursive updates
      final newText = formatter.format(int.parse(text));
      if (newText != _amountController.text) {
        final cursorPos = newText.length;
        _amountController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPos),
        );
      }
      // if (int.parse(text) < 50) {
      //   setState(() {
      //     isNotMinimumAmount = true;
      //   });
      // } else {
      //   setState(() {
      //     isNotMinimumAmount = false;
      //   });
      // }
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
          onAllow: () {
            Navigator.of(context).pop();
            _pickContact();
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      );

  bool _isFormValid(String network, int operatorId) {
    return _controller.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        network.isNotEmpty &&
        operatorId > 0;
  }

  Future<void> _handlePinEntry() async {
    print('🔑 [Airtime] _handlePinEntry called');
    final user = ref.read(userProvider);
    final hasEnoughBalance = checkBalanceLeft(
                                    context,
                                    user?.wallets.first.balance.toString() ??
                                        '0',
                                    _amountController.text.replaceAll(',', ''));
          if (!hasEnoughBalance) return;
    final pin = await BiometricTransactionPinModal.show(context);
    print(
        '🔑 [Airtime] PIN received: ${pin != null ? "****" : "null"}, length: ${pin?.length}');

    // Log first and last character for debugging (without exposing full PIN)
    if (pin != null && pin.length == 4) {
      print(
          '🔑 [Airtime] PIN format check: starts with "${pin[0]}", ends with "${pin[3]}"');
    }

    if (pin == null || pin.length != 4) {
      print('⚠️ [Airtime] Invalid PIN, returning');
      return;
    }
    if (!mounted) {
      print('⚠️ [Airtime] Widget not mounted, returning');
      return;
    }

    // Close details screen first
    Navigator.pop(context);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final operatorId = ref.read(airtimeSelectedOperatorIdProvider);

      // Ensure PIN is a string
      final pinString = pin.toString();
      print(
          '🔐 PIN type check: ${pin.runtimeType}, converted: ${pinString.runtimeType}');

      final request = AirtimePurchaseRequest(
        walletPin: pinString,
        amount: double.parse(_amountController.text..replaceAll(',', '')),
        operatorId: operatorId,
        phone: _controller.text,
        currency: 'NGN',
        addBeneficiary: false,
      );

      print('🔐 Initiating airtime purchase...');
      print(
          '🔐 Request details: amount=${request.amount}, operatorId=${request.operatorId}, phone=${request.phone}');
      print(
          '🔐 Request walletPin type: ${request.walletPin.runtimeType}, value: ${request.walletPin}');
      await ref
          .read(airtimePurchaseNotifierProvider.notifier)
          .purchase(request);
      print('📤 Airtime purchase request sent');
    } catch (e) {
      print('❌ Airtime purchase error: $e');
      if (mounted) Navigator.pop(context); // close loading
      if (mounted) {
        AppMessenger.show(context,
            message: 'Error: ${e.toString()}', type: MessageType.error);
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
              'Amount',
              currencyFormatter(_amountController.text..replaceAll(',', '')),
              isDark,
            ),
          ],
          onButtonPressed: _handlePinEntry,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isBvnVerified = user?.isBvnVerified ?? false;

    final useCashback = ref.watch(airtimeUseCashbackProvider);
    final selectedNetwork = ref.watch(airtimeSelectedNetworkProvider);
    final selectedOperatorId = ref.watch(airtimeSelectedOperatorIdProvider);

    final providersState = ref.watch(airtimeProvidersNotifierProvider);
    final networkProviders = providersState.data ?? <NetworkProvider>[];

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
                          value:  currencyFormatter(_amountController.text..replaceAll(',', ''))),
                      ShareableTransactionReceiptDetail(
                          label: 'Currency', value: 'NGN'),
                      ShareableTransactionReceiptDetail(
                          label: 'Transaction Type',
                          value: 'Airtime Purchase'),
                      ShareableTransactionReceiptDetail(
                          label: 'Provider',
                          value: selectedNetwork.toUpperCase()),
                      ShareableTransactionReceiptDetail(
                          label: 'Phone Number',
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

   

    // Listen to airtime purchase state
    ref.listen(airtimePurchaseNotifierProvider, (previous, next) {
      print('🎧 [Airtime Listener] State changed:');
      print('   - isDataAvailable: ${next.isDataAvailable}');
      print('   - isLoading: ${next.isInitialLoading}');
      print('   - message: ${next.message}');
      print('   - data: ${next.data}');
      print('   - data length: ${next.data?.length}');

      if (!mounted) {
        print('⚠️ [Airtime Listener] Widget not mounted, skipping');
        return;
      }

      // Check for success: either isDataAvailable is true OR data exists with success message
      final hasData = next.data != null && next.data!.isNotEmpty;
      final hasSuccessMessage = next.message != null &&
          next.message!.toLowerCase().contains('success');
      final isSuccess =
          (next.isDataAvailable && hasData) || (hasData && hasSuccessMessage) || next.message != null && !next.isInitialLoading;

      if (isSuccess) {
        // Purchase successful - close loading and navigate to receipt
        print(
            '✅ [Airtime Listener] Purchase successful, navigating to receipt');

        // Close loading dialog
        if (Navigator.canPop(context)) {
          print('📤 [Airtime Listener] Closing loading dialog');
          Navigator.pop(context);
        }

        // Small delay to ensure loading dialog is closed
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) {
            print(
                '⚠️ [Airtime Listener] Widget not mounted after delay, skipping navigation');
            return;
          }

          print('🧾 [Airtime Listener] Navigating to receipt screen');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionReceiptWidget(
                amount: currencyFormatter(_amountController.text..replaceAll(',', '')),
                topDetails: [
                  TransactionDetail(
                    label: 'Transaction ID',
                    value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                    showCopyIcon: true,
                  ),
                  TransactionDetail(
                    label: 'Recipient Number',
                    value: _controller.text,
                  ),
                  TransactionDetail(label: 'Network', value: selectedNetwork.toUpperCase()),
                  TransactionDetail(
                    label: 'Amount',
                    value:  currencyFormatter(_amountController.text..replaceAll(',', '')),,
                  ),
                ],
                onShareReceipt: _onShareTransactionReceiptPressed,
              ),
            ),
          );
        });
      }  else if (!next.isDataAvailable) {
          // Purchase failed
          print('❌ [Airtime Listener] Purchase failed: ${next.message}');

          // Close loading dialog
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

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
          'Airtime',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: !isBvnVerified
          ? const KycNotSetWidget(
              title: 'KYC Not Completed',
              subtitle: 'Complete your KYC verification to purchase airtime',
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
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
                        countryCode: '+234 ',
                        flagImagePath: 'assets/images/ngflag.png',
                        hintText: '123 456 789',
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
                        onChanged: (unnamed) => setState(() {})),
                    const SizedBox(height: 24),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: providersState.isInitialLoading &&
                              networkProviders.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : NetworkProviderSelector(
                              selectedNetwork: selectedNetwork,
                              providers: networkProviders,
                              onNetworkSelected: (value) async {
                                if (value.isEmpty) return;
                                try {
                                  final provider = networkProviders
                                      .firstWhere((p) => p.network == value);
                                  // update selected network and operator id
                                  ref
                                      .read(airtimeSelectedNetworkProvider
                                          .notifier)
                                      .state = value;
                                  ref
                                      .read(airtimeSelectedOperatorIdProvider
                                          .notifier)
                                      .state = provider.operatorId;

                                  if (_controller.text.isNotEmpty) {
                                    await ref
                                        .read(airtimePlanNotifierProvider
                                            .notifier)
                                        .getPlan(
                                          phone: _controller.text,
                                          currency: 'NGN',
                                        );
                                  }
                                } catch (e) {
                                  // provider not found or other error - ignore silently
                                  print(
                                      '⚠️ [Airtime] Selected provider not found: $value');
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Amount',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ReuseableAmountTextfield(
                      amountController: _amountController,
                      prefixText: '₦',
                      hintText: '500',
                      onChanged: (unnamed) => setState(() {}),
                    ),
                    // const SizedBox(height: 24),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Expanded(
                    //       child: Text(
                    //         'Use Cashback',
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //     Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         const Text(
                    //           '₦50.00',
                    //           style:
                    //               TextStyle(color: Colors.grey, fontSize: 14),
                    //         ),
                    //         const SizedBox(width: 8),
                    //         Switch(
                    //           value: useCashback,
                    //           onChanged: (v) => ref
                    //               .read(airtimeUseCashbackProvider.notifier)
                    //               .state = v,
                    //           activeTrackColor: appTheme.primaryColor,
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),

                    const SizedBox(height: 32),
                    FullWidthButton(
                      text: 'Continue',
                      onPressed: () => _navigateToDetails(
                          selectedNetwork, selectedOperatorId),
                      isEnabled:
                          _isFormValid(selectedNetwork, selectedOperatorId),
                    ),
                    const SizedBox(height: 32),
                    const AirtimeServicesSection(),
                  ],
                ),
              ),
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
}
