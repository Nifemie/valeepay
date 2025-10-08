import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/Kyc/KYC_reusable_button.dart';
import '../../widgets/Kyc/kyc_progress_bar.dart';
import 'camerapermission.dart';
import 'kyc_step_provider.dart';

// State provider for BVN
final bvnProvider = StateProvider<String>((ref) => '');

class BVNPage extends ConsumerWidget {
  const BVNPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bvn = ref.watch(bvnProvider);
    final isFormValid = bvn.length == 11; // BVN is 11 digits
    final currentStep = ref.watch(kycStepProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(kycStepProvider.notifier).state = 1;
            Navigator.pop(context);
          }
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Step Progress Bar
              StepProgressBar(currentStep: currentStep),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Your BVN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                'Enter your BVN to verify your identity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              const SizedBox(height: 32),
              // BVN Input Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  const Text(
                    'Your BVN',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.06,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Input Container
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        ref.read(bvnProvider.notifier).state = value;
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      style: const TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your BVN',
                        hintStyle: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        counterText: '', // Hide character counter
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Info Section
              Column(
                children: [
                  const Text(
                    'Why we need your BVN?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We need your BVN to confirm your identity and ensure your account is secure. Sharing your BVN does not give us access to your bank account or funds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'To get your BVN, dial ',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                        TextSpan(
                          text: '*565#',
                          style: TextStyle(color: Color(0xFFF76301)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Continue Button
              FullWidthButton(
                text: 'Continue',
                isEnabled: isFormValid,
                onPressed: () {
                  ref.read(kycStepProvider.notifier).state = 3;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraPermissionPage()),
                  );// Navigate to next step
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

