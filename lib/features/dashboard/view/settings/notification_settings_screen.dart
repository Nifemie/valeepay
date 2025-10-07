import 'package:flutter/material.dart';
import '../../widgets/home_widgets/settings_widgets.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool transactionsEnabled = true;
  bool servicesEnabled = true;
  bool updatesEnabled = true;
  bool messagesEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Get Only Notification Preference',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 24),
          SettingsToggleTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Transactions',
            subtitle:
                'Get notified about your transactions and account activities',
            value: transactionsEnabled,
            onChanged: (value) {
              setState(() {
                transactionsEnabled = value;
              });
            },
          ),
          SettingsToggleTile(
            icon: Icons.business_outlined,
            title: 'Services',
            subtitle:
                'Receive updates about new services and service activities',
            value: servicesEnabled,
            onChanged: (value) {
              setState(() {
                servicesEnabled = value;
              });
            },
          ),
          SettingsToggleTile(
            icon: Icons.system_update_outlined,
            title: 'Updates',
            subtitle: 'Stay informed about app improvements and new features',
            value: updatesEnabled,
            onChanged: (value) {
              setState(() {
                updatesEnabled = value;
              });
            },
          ),
          SettingsToggleTile(
            icon: Icons.message_outlined,
            title: 'Messages',
            subtitle: 'Get direct messages and direct communications',
            value: messagesEnabled,
            onChanged: (value) {
              setState(() {
                messagesEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
