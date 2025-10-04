import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/auth/widgets/need_help_modal.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _addressController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  bool _isRegistered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: appTheme.darkColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              NeedHelpModal.show(context);
            },
            child: const Text(
              'Need Help?',
              style: TextStyle(color: appTheme.primaryColor, fontSize: 14),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Scrollable form
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Business Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Provide your company information to create your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Business Name
                        _buildTextField(
                          controller: _businessNameController,
                          label: 'Business Name',
                          hint: 'Enter your business name',
                        ),
                        const SizedBox(height: 16),

                        // Organization
                        _buildTextField(
                          controller: _organizationController,
                          label: 'Organization',
                          hint: 'Enter your organization',
                        ),
                        const SizedBox(height: 16),

                        // Address
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                          hint: 'Enter your business address',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),

                        // Is Registered
                        Row(
                          children: [
                            const Text(
                              'Is Your Business Registered?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Radio<bool>(
                              value: true,
                              groupValue: _isRegistered,
                              onChanged: (value) {
                                setState(() {
                                  _isRegistered = value!;
                                });
                              },
                              activeColor: appTheme.primaryColor,
                            ),
                            const Text('Yes'),
                            const SizedBox(width: 16),
                            Radio<bool>(
                              value: false,
                              groupValue: _isRegistered,
                              onChanged: (value) {
                                setState(() {
                                  _isRegistered = value!;
                                });
                              },
                              activeColor: appTheme.primaryColor,
                            ),
                            const Text('No'),
                          ],
                        ),

                        if (_isRegistered) ...[
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _registrationNumberController,
                            label: 'Business Registration Number',
                            hint: 'Enter registration number',
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Terms
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'By clicking Continue, you agree to our ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: appTheme.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              ' and ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: appTheme.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom button pinned
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.push('/email-password');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: appTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _organizationController.dispose();
    _addressController.dispose();
    _registrationNumberController.dispose();
    super.dispose();
  }
}
