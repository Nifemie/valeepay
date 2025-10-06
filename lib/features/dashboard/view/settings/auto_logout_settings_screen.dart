import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';

class AutoLogoutSettingsScreen extends StatefulWidget {
  const AutoLogoutSettingsScreen({super.key});

  @override
  State<AutoLogoutSettingsScreen> createState() =>
      _AutoLogoutSettingsScreenState();
}

class _AutoLogoutSettingsScreenState extends State<AutoLogoutSettingsScreen> {
  String selectedOption = '60 Minutes Password Free Log in';

  final List<String> logoutOptions = [
    'Password Free Log in',
    '60 Minutes Password Free Log in',
    'Always Require Password to Log in',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-Logout Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose the lock that suits you best',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 32),

            // Auto-logout options
            ...logoutOptions.map((option) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = option;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedOption == option
                              ? appTheme.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: selectedOption == option
                                        ? appTheme.primaryColor
                                        : Colors.black87,
                                  ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedOption == option
                                    ? appTheme.primaryColor
                                    : Colors.grey[600]!,
                                width: 2,
                              ),
                            ),
                            child: selectedOption == option
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: appTheme.primaryColor,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Settings Saved',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your auto-logout settings have been updated to: $selectedOption',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
