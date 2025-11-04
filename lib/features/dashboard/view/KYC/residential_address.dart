import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/models/kyc_address_request.dart';
import '../../widgets/Kyc/kyc_progress_bar.dart';
import 'kyc_step_provider.dart';

final stateProvider = StateProvider<String>((ref) => '');
final lgaProvider = StateProvider<String>((ref) => '');
final areaProvider = StateProvider<String>((ref) => '');
final houseAddressProvider = StateProvider<String>((ref) => '');
final landmarkProvider = StateProvider<String>((ref) => '');
final houseDescriptionProvider = StateProvider<String>((ref) => '');

class ResidentialAddressPage extends ConsumerStatefulWidget {
  const ResidentialAddressPage({Key? key}) : super(key: key);

  @override
  _ResidentialAddressPageState createState() => _ResidentialAddressPageState();
}

class _ResidentialAddressPageState extends ConsumerState<ResidentialAddressPage> {
  List<String> _lgas = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final lga = ref.watch(lgaProvider);
    final area = ref.watch(areaProvider);
    final houseAddress = ref.watch(houseAddressProvider);
    final landmark = ref.watch(landmarkProvider);
    final houseDescription = ref.watch(houseDescriptionProvider);
    final currentStep = ref.watch(kycStepProvider);

    // Check if form is valid
    final isFormValid = state.isNotEmpty &&
        lga.isNotEmpty &&
        area.isNotEmpty &&
        houseAddress.isNotEmpty &&
        landmark.isNotEmpty &&
        houseDescription.isNotEmpty;

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
                'Your Address',
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
                'Enter your current home address to help us verify your identity and location',
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
                placeholder: 'Select a state',
                value: state,
                items: NigerianStatesAndLGA.allStates,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(stateProvider.notifier).state = value;
                    ref.read(lgaProvider.notifier).state = '';
                    ref.read(areaProvider.notifier).state = '';
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
                placeholder: 'Select local government',
                value: lga,
                items: _lgas,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(lgaProvider.notifier).state = value;
                  }
                },
              ),
              const SizedBox(height: 20),
              // Area Field
              _buildInputField(
                context,
                ref,
                label: 'Area',
                placeholder: 'Select area',
                value: area,
                onChanged: (value) {
                  ref.read(areaProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // Address Field
              _buildInputField(
                context,
                ref,
                label: 'Address',
                placeholder: 'Select area',
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
                placeholder: 'Nearby feature like church school',
                value: landmark,
                onChanged: (value) {
                  ref.read(landmarkProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // Description of House Field
              _buildTextAreaField(
                context,
                ref,
                label: 'Description of House',
                placeholder: 'e.g describe the structure or colour',
                value: houseDescription,
                onChanged: (value) {
                  ref.read(houseDescriptionProvider.notifier).state = value;
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
                      area: area,
                      houseAddress: houseAddress,
                      landmark: landmark,
                      houseDescription: houseDescription,
                    );
                    ref.read(kycStepProvider.notifier).state = 2;
                    // Navigate to proof of address page
                    context.push('/proof-of-address', extra: addressRequest);
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
    required String placeholder,
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
            hint: Text(
              placeholder,
              style: const TextStyle(
                color: Color(0xFFD1D5DB),
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
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
          height: 48,
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

  Widget _buildTextAreaField(
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onChanged: onChanged,
            maxLines: 3,
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