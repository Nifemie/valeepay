import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/Kyc/KYC_reusable_button.dart';
import '../../widgets/Kyc/kyc_progress_bar.dart';
import 'identity_verification.dart';
import 'kyc_step_provider.dart';

class CameraPermissionPage extends ConsumerWidget {
  const CameraPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(kycStepProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () {
            ref.read(kycStepProvider.notifier).state = 2;
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
              const SizedBox(height: 60),
              // Camera Icon with Background
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Camera.svg',
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFF76301),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                'Camera Permission Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontFamily: 'SF Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              // Description
              const Text(
                'To keep your account secure, we need access to your camera. This allows us to capture your face for identity verification, confirm it\'s really you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Warning Text
              const Text(
                'Don\'t worry—your camera is only used for verification and nothing else',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF76301),
                  fontFamily: 'SF Pro',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  letterSpacing: 0.06,
                ),
              ),
              const SizedBox(height: 40),
              // Allow Permission Button
              FullWidthButton(
                text: 'Allow Permission',
                isEnabled: true,
                onPressed: () {
                  ref.read(kycStepProvider.notifier).state = 3;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IdentityVerificationTipsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

