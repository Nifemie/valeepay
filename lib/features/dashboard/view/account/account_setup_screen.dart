import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1998, 8, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.paddingAll16,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Get USD Account",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Enter your required personal details to open a secure dollar account",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),

              // First Name
              _buildTextField("First Name", firstNameController),

              SizedBox(height: 16.h),

              // Last Name
              _buildTextField("Last Name", lastNameController),

              SizedBox(height: 16.h),

              // Username
              _buildTextField("Username", usernameController),

              SizedBox(height: 16.h),

              // Date of Birth
              Text(
                "Date Of Birth",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: dobController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    size: 18.sp,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: ResponsiveUtils.borderRadius12,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Referral Code
              _buildTextField(
                "Referral Code (Optional)",
                referralController,
                isOptional: true,
              ),

              SizedBox(height: 30.h),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submit
                    }
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Disclaimer
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "By clicking Continue, you agree to our ",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                    children: [
                      TextSpan(
                        text: "Terms and Conditions",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text field
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (!isOptional && (value == null || value.isEmpty)) {
              return "$label is required";
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: ResponsiveUtils.borderRadius12,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}