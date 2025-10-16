import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/constants/storage_keys.dart';
import 'package:valarpay/core/services/local_storage_service.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/widgets/terms_and_conditions_widget.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class BusinessDetailsScreen extends ConsumerStatefulWidget {
  final SignUpRequest request;
  const BusinessDetailsScreen({
    required this.request,
    super.key,
  });

  @override
  ConsumerState<BusinessDetailsScreen> createState() =>
      _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends ConsumerState<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _referralController = TextEditingController();
  bool _isRegistered = true;

  _registerBusiness() async {
    if (_formKey.currentState!.validate()) {
      SignUpRequest request = SignUpRequest(
        fullname: '${_firstNameController.text} ${_lastNameController.text}',
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        username: _usernameController.text,
        dateOfBirth: _dobController.text,
        countryCode: widget.request.countryCode,
        referralCode: _referralController.text,
      );

      FocusScope.of(context).unfocus();
      final notifier = ref.read(userNotifierProvider.notifier);
      await notifier.registerBusiness(request);
      final state = ref.read(userNotifierProvider);

      if (state.isDataAvailable) {
        await LocalStorageService.save(StorageKeys.email, request.email!);
        await LocalStorageService.save(
            StorageKeys.signupRequest, request.toString());

        context.push('/verify-email');
      } else {
        AppMessenger.show(
          context,
          message: state.message ?? 'Registration failed',
          type: MessageType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: AppBar(
        backgroundColor: appTheme.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: appTheme.darkColor),
        ),
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
                          'Your company information for account creation',
                          style: TextStyle(
                            fontSize: 14,
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

                        // Username
                        _buildTextField(
                          controller: _usernameController,
                          label: 'Username',
                          hint: 'Enter username',
                        ),
                        const SizedBox(height: 16),

                        // Date Of Birth
                        _buildDateField(
                          controller: _dateOfBirthController,
                          label: 'Date Of Birth',
                          hint: 'DD-MM-YYYY',
                        ),
                        const SizedBox(height: 24),

                        // Is Your Business Registered?
                        const Text(
                          'Is your Business Registered?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
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
                            const SizedBox(width: 24),
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
                            obscureText: true,
                          ),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom button and terms
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registerBusiness,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
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
              const SizedBox(height: 16),
              TermsAndConditionsWidget(),
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
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: appTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon:
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: appTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              controller.text =
                  '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
            }
          },
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
    _usernameController.dispose();
    _dateOfBirthController.dispose();
    _registrationNumberController.dispose();
    super.dispose();
  }
}
