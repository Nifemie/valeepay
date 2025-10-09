import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/services_widgets/education_widget/education_button.dart';

// Import your reusable button
// import '../widgets/reusable_buttons.dart';

// State providers
final serviceTypeProvider = StateProvider<String?>((ref) => null);
final profileCodeProvider = StateProvider<String>((ref) => '');
final phoneNumberProvider = StateProvider<String>((ref) => '');

class JAMBPaymentPage extends ConsumerWidget {
  const JAMBPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceType = ref.watch(serviceTypeProvider);
    final profileCode = ref.watch(profileCodeProvider);
    final phoneNumber = ref.watch(phoneNumberProvider);

    final isFormValid = serviceType != null &&
        profileCode.isNotEmpty &&
        phoneNumber.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'JAMB',
          style: TextStyle(
            color: Color(0xFF111827),
            fontFamily: 'SF Pro',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Type Dropdown
              _buildDropdownField(
                context,
                ref,
                label: 'Service Type',
                value: serviceType,
                items: ['Option 1', 'Option 2', 'Option 3'],
                onChanged: (value) {
                  ref.read(serviceTypeProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // Profile Code Input
              _buildInputField(
                context,
                ref,
                label: 'Profile Code',
                placeholder: 'Enter Candidate\'s confirmation code',
                value: profileCode,
                onChanged: (value) {
                  ref.read(profileCodeProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // Candidate Phone Number Input
              _buildInputField(
                context,
                ref,
                label: 'Candidate Phone Number',
                placeholder: 'Enter Phone Number',
                value: phoneNumber,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  ref.read(phoneNumberProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              // Note Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note:',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontFamily: 'SF Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontFamily: 'SF Pro',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Text NIN Epin 11-digit NIN# to ',
                          ),
                          TextSpan(
                            text: '55019',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: ' to get your confirmation code (Example: send ',
                          ),
                          TextSpan(
                            text: 'NIN 01111111111',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: ' to ',
                          ),
                          TextSpan(
                            text: '55019',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: ')',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Current Rate Section
              Container(
                width: 335,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Current Rate',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '₦500',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Continue Button
              Center(
                child: FullWidthButton(
                  text: 'Continue',
                  isEnabled: isFormValid,
                  onPressed: () {
                    // Process payment
                    print('Continue to payment');
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
        required String? value,
        required List<String> items,
        required Function(String?) onChanged,
      }) {
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
          width: 335,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: const Text(
                'Select option',
                style: TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
              style: const TextStyle(
                color: Color(0xFF111827),
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
      BuildContext context,
      WidgetRef ref, {
        required String label,
        required String placeholder,
        required String value,
        required Function(String) onChanged,
        TextInputType? keyboardType,
      }) {
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
          width: 335,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onChanged: onChanged,
            keyboardType: keyboardType,
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

