import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/home_widgets/settings_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
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
          SettingsListTile(
            icon: Icons.login_outlined,
            title: 'Login Settings',
            onTap: () {
              context.push('/login-settings');
            },
          ),
          SettingsListTile(
            icon: Icons.security_outlined,
            title: 'Security Settings',
            onTap: () {
              context.push('/security-settings');
            },
          ),
          SettingsListTile(
            icon: Icons.pin_outlined,
            title: 'Transaction PIN Settings',
            onTap: () {
              context.push('/transaction-pin-settings');
            },
          ),
          SettingsListTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Finance Settings',
            onTap: () {
              context.push('/finance-settings');
            },
          ),
          SettingsListTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Settings',
            onTap: () {
              context.push('/notification-settings');
            },
          ),
          SettingsListTile(
            icon: Icons.support_agent_outlined,
            title: 'Close Account',
            onTap: () {
              _showCloseAccountDialog(context);
            },
          ),
          SettingsListTile(
            icon: Icons.logout_outlined,
            title: 'Logout',
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCloseAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CloseAccountDialog(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
