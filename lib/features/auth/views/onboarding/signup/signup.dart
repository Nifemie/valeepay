import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/themes/app_theme.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import '../../../../../features/auth/widgets/need_help_modal.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String selectedAccountType = 'Personal';
  String selectedCurrency = 'NGN';

  void _showDialog<T>({
    required String title,
    required List<DialogOption<T>> options,
  }) {
    showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...options.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildDialogOption(option),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDialogOption<T>(DialogOption<T> option) {
    final isSelected = option.isSelected;
    return GestureDetector(
      onTap: () {
        option.onTap();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(20), // increased padding for height
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color:
                isSelected
                    ? (option.activeColor ?? appTheme.primaryColor)
                    : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (option.flag != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? option.activeColor!.withOpacity(0.2)
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(option.flag!, style: const TextStyle(fontSize: 18)),
              ),
            if (option.flag != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (option.subtitle != null) const SizedBox(height: 6),
                  if (option.subtitle != null)
                    Text(
                      option.subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            Radio<T>(
              value: option.value,
              groupValue: option.groupValue,
              onChanged: (_) => option.onTap(),
              activeColor: option.activeColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountTypeDialog() {
    _showDialog<String>(
      title: 'Choose Account',
      options: [
        DialogOption(
          title: 'Personal',
          subtitle: 'For individuals and everyday needs',
          value: 'Personal',
          groupValue: selectedAccountType,
          activeColor: appTheme.primaryColor,
          onTap: () => setState(() => selectedAccountType = 'Personal'),
        ),
        DialogOption(
          title: 'Business',
          subtitle: 'For organizations and corporate needs',
          value: 'Business',
          groupValue: selectedAccountType,
          activeColor: appTheme.primaryColor,
          onTap: () => setState(() => selectedAccountType = 'Business'),
        ),
      ],
    );
  }

  void _showCurrencyDialog() {
    _showDialog<String>(
      title: 'Choose Currency',
      options: [
        DialogOption(
          title: 'NGN',
          subtitle: 'For transactions in Naira',
          flag: '🇳🇬',
          value: 'NGN',
          groupValue: selectedCurrency,
          activeColor: Colors.green,
          onTap: () => setState(() => selectedCurrency = 'NGN'),
        ),
        DialogOption(
          title: 'USD',
          subtitle: 'For transactions in US Dollars',
          flag: '🇺🇸',
          value: 'USD',
          groupValue: selectedCurrency,
          activeColor: Colors.green,
          onTap: () => setState(() => selectedCurrency = 'USD'),
        ),
        DialogOption(
          title: 'GBP',
          subtitle: 'For transactions in Pounds',
          flag: '🇬🇧',
          value: 'GBP',
          groupValue: selectedCurrency,
          activeColor: Colors.green,
          onTap: () => setState(() => selectedCurrency = 'GBP'),
        ),
        DialogOption(
          title: 'EUR',
          subtitle: 'For transactions in Euros',
          flag: '🇪🇺',
          value: 'EUR',
          groupValue: selectedCurrency,
          activeColor: Colors.green,
          onTap: () => setState(() => selectedCurrency = 'EUR'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: isDarkMode ? AppTheme.lightTheme : AppTheme.darkTheme,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => GoRouter.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: () => NeedHelpModal.show(context),
              child: const Text(
                'Need Help?',
                style: TextStyle(color: appTheme.primaryColor, fontSize: 14),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoHeader(),
              const SizedBox(height: 40),
              const Text(
                'Create account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the account type that best fits your needs',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Label + selection tile
              const Text(
                'Account Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              _buildSelectionTile(
                selectedAccountType,
                _showAccountTypeDialog,
                Icons.person,
              ),
              const SizedBox(height: 24),

              const Text(
                'Currency',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              _buildSelectionTile(
                selectedCurrency,
                _showCurrencyDialog,
                Icons.money,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedAccountType == 'Personal') {
                      context.push('/personal-details');
                    } else {
                      context.push('/business-details');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect( // Use ClipRRect to apply border radius to the image
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/new_valapay.png',
              fit: BoxFit.cover, // Cover the container area
              width: 40,
              height: 40,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Valarpay',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSelectionTile(String value, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60, // increased height for better touch target
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class DialogOption<T> {
  final String title;
  final String? subtitle;
  final String? flag;
  final T value;
  final T? groupValue;
  final Color? activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  DialogOption({
    required this.title,
    this.subtitle,
    this.flag,
    required this.value,
    this.groupValue,
    this.activeColor,
    required this.onTap,
  }) : isSelected = value == groupValue;
}