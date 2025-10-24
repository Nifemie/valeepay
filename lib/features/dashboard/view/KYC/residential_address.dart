import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/models/kyc_address_request.dart';

import '../../widgets/Kyc/kyc_progress_bar.dart';
import 'BVN.dart';
import 'kyc_step_provider.dart';

final stateProvider = StateProvider<String>((ref) => '');
final lgaProvider = StateProvider<String>((ref) => '');
final houseAddressProvider = StateProvider<String>((ref) => '');
final landmarkProvider = StateProvider<String>((ref) => '');

class ResidentialAddressPage extends ConsumerStatefulWidget {
  const ResidentialAddressPage({Key? key}) : super(key: key);

  @override
  _ResidentialAddressPageState createState() => _ResidentialAddressPageState();
}

class _ResidentialAddressPageState extends ConsumerState<ResidentialAddressPage> {
  List<String> _lgas = [];

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(kycStepProvider.notifier).state = 1;
              Navigator.pop(context);
            }),
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
              _buildDropdownField(
                context,
                ref,
                label: 'State',
                value: state,
                items: NigerianStatesAndLGA.allStates,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(stateProvider.notifier).state = value;
                    ref.read(lgaProvider.notifier).state = '';
                    setState(() {
                      _lgas = NigerianStatesAndLGA.getStateLGAs(value);
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              // LGA Field
              _buildDropdownField(
                context,
                ref,
                label: 'LGA',
                value: lga,
                items: _lgas,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(lgaProvider.notifier).state = value;
                  }
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
                    final addressRequest = KycAddressRequest(
                      state: state,
                      lga: lga,
                      houseAddress: houseAddress,
                      landmark: landmark,
                    );
                    ref.read(kycStepProvider.notifier).state = 2;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BVNPage(request: addressRequest)),
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

  Widget _buildDropdownField(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : Colors.black,
            ),
            dropdownColor: Theme.of(context).cardColor,
            isExpanded: true,
          ),
        ),
      ],
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
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(
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