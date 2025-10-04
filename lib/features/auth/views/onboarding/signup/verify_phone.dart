import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              const Text(
                'Verify Phone Number',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the code we sent to +234 0000000000',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                index == 1 || index == 2
                                    ? appTheme.primaryColor
                                    : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                index == 1 || index == 2
                                    ? appTheme.primaryColor
                                    : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: appTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Didn't receive code
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Resend code logic
                    },
                    child: const Text(
                      'Resend in 50 seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: appTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 80),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate OTP
                    String otp =
                        _controllers
                            .map((controller) => controller.text)
                            .join();
                    if (otp.length == 4) {
                      context.push('/signup-success');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter the complete verification code',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill some fields to match the design
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllers[1].text = '1';
      _controllers[2].text = '2';
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
