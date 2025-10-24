import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/features/providers/user_provider.dart';
// import 'change_pin_screen.dart';

class TransactionPinSettingsScreen extends ConsumerStatefulWidget {
  const TransactionPinSettingsScreen({super.key});

  @override
  ConsumerState<TransactionPinSettingsScreen> createState() =>
      _TransactionPinSettingsScreenState();
}

class _TransactionPinSettingsScreenState
    extends ConsumerState<TransactionPinSettingsScreen> {
  bool fingerprintEnabled = false;
  bool faceIdEnabled = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final hasPinSet = user?.isWalletPinSet ?? false;
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Transaction PIN Section
            Text(
              'Transaction PIN',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if(!hasPinSet)  Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF76301).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFFF76301),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please complete KYC and set your transaction pin first',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

           
           if(hasPinSet) Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      context.push('/change-pin');
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
                  const SizedBox(height: 12),
                  Divider(),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      context.push('/forgot-pin');
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
                  const SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Biometrics Section
            Text(
              'Biometrics',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
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
                      // setState(() {
                      //   fingerprintEnabled = value;
                      // });
                      AppMessenger.show(
                        context,
                        message: 'Feature not available yet',
                        type: MessageType.error,
                      );
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
                      // setState(() {
                      //   faceIdEnabled = value;
                      // });
                      AppMessenger.show(
                        context,
                        message: 'Feature not available yet',
                        type: MessageType.error,
                      );
                    },
                    activeTrackColor: appTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
