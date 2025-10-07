import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/home_widgets/settings_widgets.dart';
import 'close_account_screen.dart';

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
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),
              SizedBox(height: 16),
              SettingsListTile(
                icon: Icons.support_agent_outlined,
                title: 'Close Account',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CloseAccountScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SettingsListTile(
                icon: Icons.logout_outlined,
                title: 'Logout',
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
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
