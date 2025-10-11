import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valarpay/features/dashboard/view/KYC/Residential_address.dart';

class KYCSetupPage extends ConsumerWidget {
  const KYCSetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // KYC Image
              Image.asset(
                'assets/images/KYC_image.png',
                width: 250,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 250,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 80,
                      color: Color(0xFFCCCCCC),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                'What do i need to complete my profile setup?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              // Requirements List
              _buildRequirementItem('Your Residential Address'),
              const SizedBox(height: 16),
              _buildRequirementItem('Your BVN'),
              const SizedBox(height: 16),
              _buildRequirementItem('A clear selfie showing your face'),
              const SizedBox(height: 48),
              // Continue Setup Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResidentialAddressPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF76301),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Continue Setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SF Pro',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/Orange_checkmark.svg',
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: 0.035,
            ),
          ),
        ),
      ],
    );
  }
}
