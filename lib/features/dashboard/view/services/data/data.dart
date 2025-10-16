import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_text_field_with_country.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/contact_access_dialog.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/mobile_data_services_section.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/providers/data_providers.dart';
import 'package:valarpay/features/notifiers/data_notifier.dart';
import 'package:valarpay/features/models/data_models.dart';
import 'package:valarpay/features/models/network_provider.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _useCashback = false;
  String _selectedNetwork = '';
  int _selectedOperatorId = 0;
  String _selectedPlan = '';
  late DataNotifier _dataNotifier;
  List<NetworkProvider> _networkProviders = [];
  List<DataPlanInfo> _availablePlans = [];

  @override
  void initState() {
    super.initState();
    _dataNotifier = DataProviders.notifier;
    _loadNetworkProviders();
    _dataNotifier.addListener(_onDataStateChanged);
  }

  void _loadNetworkProviders() async {
    await _dataNotifier.fetchDataProviders();
  }

  void _onDataStateChanged() {
    if (mounted) {
      setState(() {
        _networkProviders = _dataNotifier.dataProviders;
        _availablePlans = _dataNotifier.availablePlans;
      });

      if (_dataNotifier.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_dataNotifier.errorMessage),
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
          'Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                controller: _controller,
                hintText: "123 567 890",
                countryCode: '+234',
                flagImagePath: 'assets/images/ngflag.png',
                isReadOnly: false,
                textInputType: TextInputType.phone,
                showCountryLabel: true),
            const SizedBox(height: 24),

            // Network Provider Selection
            _buildNetworkProviderSelector(),
            const SizedBox(height: 24),

            // Data Plans Section
            if (_selectedNetwork.isNotEmpty && _availablePlans.isNotEmpty) ...[
              _buildDataPlansSection(),
              const SizedBox(height: 24),
            ],

            // Cashback Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Use Cashback',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
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
            SizedBox(height: 24),
            DataServicesSection()
          ],
        ),
      ),
    );
  }

  // Build network provider selector widget
  Widget _buildNetworkProviderSelector() {
    if (_dataNotifier.isLoading && _networkProviders.isEmpty) {
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
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    _selectedNetwork = value;
                    _selectedPlan = '';
                    _selectedOperatorId = 0;
                  });
                  // Fetch available plans for this network
                  if (_controller.text.isNotEmpty) {
                    await _dataNotifier.getDataPlan(
                      phone: _controller.text,
                      currency: 'NGN',
                    );
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Build data plans section
  Widget _buildDataPlansSection() {
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
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPlan.isEmpty ? null : _selectedPlan,
              hint: const Text('Select Data Plan'),
              isExpanded: true,
              items: _availablePlans.map((plan) {
                return DropdownMenuItem<String>(
                  value: plan.id,
                  child: Text(plan.planName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPlan = value;
                    final plan = _availablePlans.firstWhere(
                      (p) => p.id == value,
                    );
                    _selectedOperatorId = plan.operatorId;
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
    final selectedPlanInfo = _availablePlans.firstWhere(
      (p) => p.id == _selectedPlan,
    );

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
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get the selected plan details
      final selectedPlanInfo = _availablePlans.firstWhere(
        (p) => p.id == _selectedPlan,
      );

      // Attempt purchase - Note: amount should come from the plan details
      // For now using a placeholder, you may need to adjust based on your API
      final success .isNotEmpty) {
                    await _dataNotifier.getDataPlan(
                      phone: _controller.text,
                      currency: 'NGN',
                    );
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Build data plans section
  Widget _buildDataPlansSection() {
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
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedOperatorId == 0 ? null : _selectedOperatorId,
              hint: const Text('Select Data Plan'),
              isExpanded: true,
              items: _availablePlans.map((plan) {
                return DropdownMenuItem<int>(
                  value: plan.operatorId,
                  child: Text(plan.planName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
    
