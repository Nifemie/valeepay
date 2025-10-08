import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/Kyc/KYC_reusable_button.dart';
import '../../widgets/Kyc/kyc_progress_bar.dart';
import 'BVN.dart';
import 'kyc_step_provider.dart';


// State providers for form fields
final stateProvider = StateProvider<String>((ref) => '');
final lgaProvider = StateProvider<String>((ref) => '');
final houseAddressProvider = StateProvider<String>((ref) => '');
final landmarkProvider = StateProvider<String>((ref) => '');

class ResidentialAddressPage extends ConsumerWidget {
  const ResidentialAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final lga = ref.watch(lgaProvider);
    final houseAddress = ref.watch(houseAddressProvider);
    final landmark = ref.watch(landmarkProvider);
    final currentStep = ref.watch(kycStepProvider);

    // Check if form is valid
    final isFormValid = state.isNotEmpty &&
        lga.isNotEmpty &&
        houseAddress.isNotEmpty &&
        landmark.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Progress Bar
              StepProgressBar(currentStep: currentStep),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Residential Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontFamily: 'SF Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                'Enter your current home address to verify your identity',
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
              // State Field
              _buildInputField(
                context,
                ref,
                label: 'State',
                value: state,
                onChanged: (value) {
                  ref.read(stateProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // LGA Field
              _buildInputField(
                context,
                ref,
                label: 'LGA',
                value: lga,
                onChanged: (value) {
                  ref.read(lgaProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // House Address Field
              _buildInputField(
                context,
                ref,
                label: 'House Address',
                placeholder: 'Include your house number',
                value: houseAddress,
                onChanged: (value) {
                  ref.read(houseAddressProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // Landmark Field
              _buildInputField(
                context,
                ref,
                label: 'Landmark',
                value: landmark,
                onChanged: (value) {
                  ref.read(landmarkProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 40),
              // Continue Button
              Center(
                child: FullWidthButton(
                  text: 'Continue',
                  isEnabled: isFormValid,
                  onPressed: () {
                    ref.read(kycStepProvider.notifier).state = 2;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BVNPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      BuildContext context,
      WidgetRef ref, {
        required String label,
        String? placeholder,
        required String value,
        required Function(String) onChanged,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
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
          width: 335,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFFD1D5DB),
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}



