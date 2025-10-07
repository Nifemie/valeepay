import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'change_pin_screen.dart';

class TransactionPinSettingsScreen extends StatefulWidget {
  const TransactionPinSettingsScreen({super.key});

  @override
  State<TransactionPinSettingsScreen> createState() =>
      _TransactionPinSettingsScreenState();
}

class _TransactionPinSettingsScreenState
    extends State<TransactionPinSettingsScreen> {
  bool fingerprintEnabled = true;
  bool faceIdEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Transaction PIN Settings'),
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
          // Transaction PIN Section
          Text(
            'Transaction PIN',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangePinScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Change PIN',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    // Navigate to forgot PIN
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Forgot PIN',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Biometrics Section
          Text(
            'Biometrics',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Use Fingerprint',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: fingerprintEnabled,
                  onChanged: (value) {
                    setState(() {
                      fingerprintEnabled = value;
                    });
                  },
                  activeTrackColor: appTheme.primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Use Face ID',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: faceIdEnabled,
                  onChanged: (value) {
                    setState(() {
                      faceIdEnabled = value;
                    });
                  },
                  activeTrackColor: appTheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
