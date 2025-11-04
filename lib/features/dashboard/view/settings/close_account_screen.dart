import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';

class CloseAccountScreen extends StatefulWidget {
  const CloseAccountScreen({super.key});

  @override
  State<CloseAccountScreen> createState() => _CloseAccountScreenState();
}

class _CloseAccountScreenState extends State<CloseAccountScreen> {
  int currentStep =
      1; // 1: Warning, 2: Help Us Improve, 3: PIN Entry, 4: Success
  String? selectedReason;
  String pin = '';
  final int pinLength = 4;

  final List<String> reasons = [
    'I no longer use this service',
    'I found a better alternative',
    'I have a security or trust concerns',
    'Poor customer support experience',
    'App is too slow/buggy',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (currentStep > 1) {
              setState(() {
                currentStep--;
                if (currentStep == 2) {
                  pin = ''; // Reset PIN when going back
                }
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _getAppBarTitle(),
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color:
                    _getAppBarTitle() == 'Close Account?' ? Colors.red : null,
              ),
            ),
          ),
          Expanded(child: _buildCurrentStep()),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (currentStep) {
      case 1:
        return 'Close Account?';
      case 2:
        return 'Help Us Improve';
      case 3:
        return '';
      default:
        return 'Close Account';
    }
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 1:
        return _buildWarningStep();
      case 2:
        return _buildHelpUsImproveStep();
      case 3:
        return _buildSuccessStep();
      default:
        return _buildWarningStep();
    }
  }

  Widget _buildWarningStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'By closing your account, you will:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Lose access to your wallet balance'),
              SizedBox(height: 4),
              Text('• Not be able to receive or send money'),
              SizedBox(height: 4),
              Text('• Lose access to all transaction history'),
              SizedBox(height: 4),
              Text('• Not be able to use all of ValarPay services'),
              SizedBox(height: 4),
              Text('• Lose access to bill payments and services'),
              SizedBox(height: 4),
              Text('• Lose all rewards and cashback'),
              SizedBox(height: 4),
              Text('• Be unable to reopen this account later'),
              SizedBox(height: 4),
              Text('• Lose access to customer support for this account'),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep = 2;
                });
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
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHelpUsImproveStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Help us improve our service by telling us why you\'re leaving',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Text(
            'Select a Reason',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: reasons.length,
              itemBuilder: (context, index) {
                final reason = reasons[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedReason = reason;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            selectedReason == reason
                                ? appTheme.primaryColor
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  selectedReason == reason
                                      ? appTheme.primaryColor
                                      : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child:
                              selectedReason == reason
                                  ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: appTheme.primaryColor,
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            reason,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          FullWidthButton(
            text: 'Continue',
            isEnabled: selectedReason != null,
            onPressed: () async {
              final pin = await TransactionPinModal.show(context);
              if (pin == null || pin.length != 4) return;
              if (!mounted) return;

              Navigator.pop(context);
              setState(() {
                currentStep = 3;
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 24),
          const Text(
            'Account Deleted',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your account has been successfully deleted. Thank you for using our service.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                // Navigate to login or onboarding
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
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
