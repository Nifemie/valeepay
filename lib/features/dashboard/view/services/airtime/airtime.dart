import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/airtime_services_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/network_provider_selector.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/providers/airtime_providers.dart';
import 'package:valarpay/features/models/network_provider.dart';
import 'package:valarpay/features/notifiers/airtime_notifier.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _useCashback = false;
  String _selectedNetwork = '';
  int _selectedOperatorId = 0;
  late AirtimeNotifier _airtimeNotifier;
  List<NetworkProvider> _networkProviders = [];

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    _amountController.text = '';
    _airtimeNotifier = AirtimeProviders.notifier;
    _loadNetworkProviders();

    // Listen to airtime notifier changes
    _airtimeNotifier.addListener(_onAirtimeStateChanged);
  }

  void _loadNetworkProviders() async {
    await _airtimeNotifier.fetchAirtimeProviders();
  }

  void _onAirtimeStateChanged() {
    if (mounted) {
      setState(() {
        _networkProviders = _airtimeNotifier.airtimeProviders;
      });

      if (_airtimeNotifier.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_airtimeNotifier.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showContactAccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContactAccessDialog(
        onAllow: () {
          Navigator.of(context).pop();
          // Handle contact access permission
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Airtime',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () {
                // Handle saved beneficiary
              },
              child: Text(
                'Saved Beneficiary',
                style: TextStyle(
                  color: appTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Phone Number Section
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
                  countryCode: '+234 ',
                  flagImagePath: 'assets/images/ngflag.png',
                  hintText: '123 456 789',
                  controller: _controller,
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
                  )),

              const SizedBox(height: 24),

              // Network Provider Selection
              _buildNetworkProviderSelector(),
              const SizedBox(height: 24),

              // Amount Section
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
              ),

              const SizedBox(height: 24),

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
                        activeTrackColor: appTheme.primaryColor,
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
              const SizedBox(height: 32),

              // Airtime Services Section
              const AirtimeServicesSection(),
              const SizedBox(height: 20), // Extra bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Build network provider selector widget
  Widget _buildNetworkProviderSelector() {
    if (_airtimeNotifier.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedNetwork.isEmpty ? null : _selectedNetwork,
              hint: const Text('Select Network Provider'),
              isExpanded: true,
              items: _networkProviders.map((provider) {
                return DropdownMenuItem<String>(
                  value: provider.network,
                  child: Text(provider.planName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedNetwork = value;
                    final provider = _networkProviders.firstWhere(
                      (p) => p.network == value,
                    );
                    _selectedOperatorId = provider.operatorId;
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
        _amountController.text.isNotEmpty &&
        _selectedNetwork.isNotEmpty &&
        _selectedOperatorId > 0;
  }

  // Handle continue button press
  void _handleContinue() {
    if (!_isFormValid()) {
      AppMessenger.show(context,
          message: 'Please fill all required fields', type: MessageType.error);
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReuseableTransactionDetailsScreen(
          hasBottom: false,
          topTitleText: 'Transaction',
          topTransactionsDetailsList: [
            buildDetailRow('Recipient Number', _controller.text, isDark),
            buildDetailRow('Provider', _selectedNetwork, isDark),
            buildDetailRow(
              'Amount',
              currencyFormatter(_amountController.text),
              isDark,
            ),
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
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Attempt purchase
      final success = await _airtimeNotifier.purchaseAirtime(
        walletPin: pin,
        amount: double.parse(_amountController.text),
        operatorId: _selectedOperatorId,
        phone: _controller.text,
        currency: 'NGN',
        addBeneficiary: false,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        // Show success receipt
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionReceiptWidget(
              amount: _amountController.text,
              topDetails: [
                TransactionDetail(
                  label: 'Transaction ID',
                  value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                  showCopyIcon: true,
                ),
                TransactionDetail(
                  label: 'Phone Number',
                  value: _controller.text,
                ),
                TransactionDetail(
                  label: 'Provider',
                  value: _selectedNetwork,
                ),
                TransactionDetail(
                  label: 'Payment Source',
                  value: 'ValarPay Account',
                ),
                TransactionDetail(
                  label: 'Date & Time',
                  value: _formatDateTime(DateTime.now()),
                ),
              ],
              onShareReceipt: () {},
            ),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_airtimeNotifier.errorMessage.isNotEmpty
                ? _airtimeNotifier.errorMessage
                : 'Airtime purchase failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Format date time for display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year} | ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    _airtimeNotifier.removeListener(_onAirtimeStateChanged);
    super.dispose();
  }
}
