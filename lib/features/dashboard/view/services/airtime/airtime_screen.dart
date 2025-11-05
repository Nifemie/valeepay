import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/utils/helpers.dart';
import 'package:valarpay/core/widgets/kyc_not_set_widget.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/airtime_services_section.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/notifiers/airtime_notifier.dart';
import 'package:valarpay/features/providers/airtime_providers.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import 'package:valarpay/features/models/airtime_models.dart';

class AirtimeScreen extends ConsumerStatefulWidget {
  const AirtimeScreen({super.key});

  @override
  ConsumerState<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends ConsumerState<AirtimeScreen> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  bool _saveBeneficiary = false;
  bool _loadingShown = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showLoading() {
    if (_loadingShown) return;
    _loadingShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _hideLoading() {
    if (!_loadingShown) return;
    _loadingShown = false;

    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  bool _isFormValid(String network, int operatorId) =>
      _phoneController.text.isNotEmpty &&
      _amountController.text.isNotEmpty &&
      network.isNotEmpty &&
      operatorId > 0;

  Future<void> _handlePin({bool biometric = false}) async {
    final user = ref.read(userProvider);
    final hasEnough = checkBalanceLeft(
      context,
      user?.wallets.first.balance.toString() ?? '0',
      _amountController.text.replaceAll(',', ''),
    );
    if (!hasEnough) return;

    final pin =
    biometric
        ? await BiometricTransactionPinModal.show(context)
        : await TransactionPinModal.show(context);

    if (pin == null || pin.length != 4 || !mounted) return;
    final operatorId = ref.read(airtimeSelectedOperatorIdProvider);

    _showLoading();

    try {
      final request = AirtimePurchaseRequest(
        walletPin: pin,
        amount: Helpers.parsedAmount(_amountController.text),
        operatorId: operatorId,
        phone: _phoneController.text.trim(),
        currency: 'NGN',
        addBeneficiary: _saveBeneficiary,
      );

      await ref
          .read(airtimePurchaseNotifierProvider.notifier)
          .purchase(request);

      _hideLoading();

      if (!mounted) return;

      final state = ref.read(airtimePurchaseNotifierProvider);

      if (state.isDataAvailable) {
        _navigateToReceipt();
      } else {
        // Check if the error message indicates incorrect PIN
        final errorMessage = state.message ?? 'Transaction failed. Please try again.';

        // Common patterns for incorrect PIN errors
        final isIncorrectPin = errorMessage.toLowerCase().contains('incorrect pin') ||
            errorMessage.toLowerCase().contains('wrong pin') ||
            errorMessage.toLowerCase().contains('invalid pin') ||
            errorMessage.toLowerCase().contains('pin is incorrect');

        AppMessenger.show(
          context,
          message: isIncorrectPin ? 'Incorrect PIN. Please try again.' : errorMessage,
          type: MessageType.error,
        );
      }
    } catch (e) {
      _hideLoading();

      if (!mounted) return;

      // Check if the exception message indicates incorrect PIN
      final errorMessage = e.toString();
      final isIncorrectPin = errorMessage.toLowerCase().contains('incorrect pin') ||
          errorMessage.toLowerCase().contains('wrong pin') ||
          errorMessage.toLowerCase().contains('invalid pin') ||
          errorMessage.toLowerCase().contains('pin is incorrect');

      AppMessenger.show(
        context,
        message: isIncorrectPin
            ? 'Incorrect PIN. Please try again.'
            : 'An unexpected error occurred: $errorMessage',
        type: MessageType.error,
      );
    }
  }


  // ------------------- Navigation -------------------
  void _navigateToReceipt() {
    final selectedNetwork = ref.read(airtimeSelectedNetworkProvider);
    final now = DateTime.now();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => TransactionReceiptWidget(
              headerText: 'Transaction',
              amount: currencyFormatter(
                _amountController.text.replaceAll(',', ''),
              ),
              topDetails: [
                TransactionDetail(
                  label: 'Transaction ID',
                  value: 'TXN${now.millisecondsSinceEpoch}',
                  showCopyIcon: true,
                ),
                TransactionDetail(
                  label: 'Recipient Number',
                  value: _phoneController.text,
                ),
                TransactionDetail(
                  label: 'Network',
                  value: selectedNetwork.toUpperCase(),
                ),
                TransactionDetail(
                  label: 'Amount',
                  value: currencyFormatter(
                    _amountController.text.replaceAll(',', ''),
                  ),
                ),
              ],
              onShareReceipt: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ReceiptShareScreen(
                          date:
                              '${now.day} ${Helpers.getMonthName(now.month)} ${now.year} | ${DateFormat.jm().format(now)}',
                          transactionDetailList: [
                            ShareableTransactionReceiptDetail(
                              label: 'Amount',
                              value: currencyFormatter(
                                _amountController.text.replaceAll(',', ''),
                              ),
                            ),
                            ShareableTransactionReceiptDetail(
                              label: 'Currency',
                              value: 'NGN',
                            ),
                            ShareableTransactionReceiptDetail(
                              label: 'Transaction Type',
                              value: 'Airtime Purchase',
                            ),
                            ShareableTransactionReceiptDetail(
                              label: 'Provider',
                              value: selectedNetwork.toUpperCase(),
                            ),
                            ShareableTransactionReceiptDetail(
                              label: 'Phone Number',
                              value: _phoneController.text.trim(),
                            ),
                            ShareableTransactionReceiptDetail(
                              label: 'Transaction ID',
                              value: 'TXN${now.millisecondsSinceEpoch}',
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
              },
            ),
      ),
    );
  }

  void _navigateToDetails(String network, int operatorId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ReuseableTransactionDetailsScreen(
              hasBottom: false,
              saveBeneficiary: _saveBeneficiary,
              onSaveBeneficiaryChanged:
                  (v) => setState(() => _saveBeneficiary = v),
              topTitleText: 'Transaction',
              topTransactionsDetailsList: [
                buildDetailRow(
                  'Recipient Number',
                  _phoneController.text,
                  isDark,
                ),
                buildDetailRow('Provider', network, isDark),
                buildDetailRow(
                  'Amount',
                  currencyFormatter(_amountController.text.replaceAll(',', '')),
                  isDark,
                ),
              ],
              onButtonPressed: () => _handlePin(biometric: false),
              onBiometricButtonPressed: () => _handlePin(biometric: true),
            ),
      ),
    );
  }

  Future<void> _pickContact() async {
    try {
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
              'Contacts permission permanently denied. Enable it in settings.',
          type: MessageType.error,
        );
        await openAppSettings();
        return;
      }

      _showLoading();
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      _hideLoading();

      final list = contacts.where((c) => c.phones.isNotEmpty).toList();
      if (list.isEmpty) {
        AppMessenger.show(
          context,
          message: 'No contacts found',
          type: MessageType.error,
        );
        return;
      }

      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          final searchController = TextEditingController();
          List<Contact> filtered = List.from(list);

          return StatefulBuilder(
            builder: (context, setModalState) {
              void filter(String query) {
                final q = query.toLowerCase();
                setModalState(() {
                  filtered =
                      list
                          .where(
                            (c) =>
                                c.displayName.toLowerCase().contains(q) ||
                                (c.phones.isNotEmpty &&
                                    c.phones.first.number.contains(q)),
                          )
                          .toList();
                });
              }

              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Select Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search contact...',
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).cardColor.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: filter,
                        ),
                      ),
                      SizedBox(
                        height: 450,
                        child: ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final c = filtered[i];
                            final number =
                                c.phones.isNotEmpty
                                    ? c.phones.first.number
                                    : '';
                            return ListTile(
                              title: Text(c.displayName),
                              subtitle: Text(number),
                              onTap: () {
                                _phoneController.text = Helpers.formatTo11(
                                  number,
                                );
                                Navigator.pop(context);
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
      _hideLoading();
      AppMessenger.show(
        context,
        message: 'Failed to load contacts',
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isVerified = user?.isBvnVerified ?? false;
    final network = ref.watch(airtimeSelectedNetworkProvider);
    final operatorId = ref.watch(airtimeSelectedOperatorIdProvider);
    final planState = ref.watch(airtimePlanNotifierProvider);
    final plan =
        planState.data?.isNotEmpty == true ? planState.data!.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Airtime',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions:
            isVerified
                ? [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Saved Beneficiary',
                      style: TextStyle(color: appTheme.primaryColor),
                    ),
                  ),
                ]
                : null,
      ),
      body:
          !isVerified
              ? const KycNotSetWidget(
                title: 'KYC Not Completed',
                subtitle: 'Complete your KYC to purchase airtime.',
              )
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ReuseableTextFieldWithCountry(
                        controller: _phoneController,
                        countryCode: '+234 ',
                        flagImagePath: 'assets/images/ngflag.png',
                        hintText: '812 345 6789',
                        textInputType: TextInputType.phone,
                        suffixWidget: IconButton(
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
                          onPressed: _pickContact,
                        ),
                        onChanged: (v) {
                          setState(() {});
                          if (v.replaceAll(RegExp(r'\D'), '').length >= 10) {
                            ref
                                .read(airtimePlanNotifierProvider.notifier)
                                .getPlan(phone: v, currency: 'NGN')
                                .then((_) {
                                  final s = ref.read(
                                    airtimePlanNotifierProvider,
                                  );
                                  if (s.isDataAvailable && s.data!.isNotEmpty) {
                                    final p = s.data!.first;
                                    ref
                                        .read(
                                          airtimeSelectedNetworkProvider
                                              .notifier,
                                        )
                                        .state = p.name;
                                    ref
                                        .read(
                                          airtimeSelectedOperatorIdProvider
                                              .notifier,
                                        )
                                        .state = p.operatorId;
                                  }
                                });
                          }
                        },
                        isReadOnly: false,
                        showCountryLabel: true,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Network Provider',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            planState.isInitialLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : plan == null
                                ? const Text(
                                  'Enter phone number to automatically detect  network provider',
                                  style: TextStyle(color: Colors.orange),
                                )
                                : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      plan.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle,
                                      color: appTheme.primaryColor,
                                    ),
                                  ],
                                ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Amount',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ReuseableAmountTextfield(
                        amountController: _amountController,
                        prefixText: '₦',
                        hintText: '500',
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 30),
                      FullWidthButton(
                        text: 'Continue',
                        isEnabled: _isFormValid(network, operatorId),
                        onPressed:
                            () => _navigateToDetails(network, operatorId),
                      ),
                      const SizedBox(height: 40),
                      const AirtimeServicesSection(),
                    ],
                  ),
                ),
              ),
    );
  }
}
