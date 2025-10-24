import 'package:flutter/material.dart';
import '../../widgets/home_widgets/settings_widgets.dart';

class FinanceSettingsScreen extends StatefulWidget {
  const FinanceSettingsScreen({super.key});

  @override
  State<FinanceSettingsScreen> createState() => _FinanceSettingsScreenState();
}

class _FinanceSettingsScreenState extends State<FinanceSettingsScreen> {
  bool targetSavingsEnabled = true;
  bool fixedDepositEnabled = false;
  bool fixedSavingsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Settings'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsToggleTile(
            icon: Icons.savings_outlined,
            title: 'Target Savings',
            subtitle:
                'Enable or disable the auto-save and target savings wallet',
            value: targetSavingsEnabled,
            onChanged: (value) {
              setState(() {
                targetSavingsEnabled = value;
              });
            },
          ),
          SettingsToggleTile(
            icon: Icons.account_balance_outlined,
            title: 'Fixed Savings',
            subtitle:
                'Enable or disable the auto-save and target savings wallet',
            value: fixedSavingsEnabled,
            onChanged: (value) {
              setState(() {
                fixedSavingsEnabled = value;
              });
            },
          ),
          SettingsToggleTile(
            icon: Icons.trending_up_outlined,
            title: 'Fixed Deposit',
            subtitle:
                'Enable or disable the auto-save and target savings wallet',
            value: fixedDepositEnabled,
            onChanged: (value) {
              setState(() {
                fixedDepositEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
