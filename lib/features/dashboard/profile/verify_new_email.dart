import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/constants/storage_keys.dart';
import 'package:valarpay/core/services/local_storage_service.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/custom_toast.dart';
import 'package:valarpay/core/widgets/terms_and_conditions_widget.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/models/verify_email_request.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class VerifyNewEmailScreen extends ConsumerStatefulWidget {
  String emailAddress;
   VerifyNewEmailScreen({required this.emailAddress, super.key});

  @override
  ConsumerState<VerifyNewEmailScreen> createState() => _VerifyNewEmailScreenState();
}

class _VerifyNewEmailScreenState extends ConsumerState<VerifyNewEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;


  _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }

  _verifyOtp() async {
    String otp = _controllers.map((controller) => controller.text).join();
    String? email = await LocalStorageService.get(StorageKeys.email);
    if (email != null) {
      Navigator.pop(context);
    }

    if (otp.length == 4) {
      setState(() {
        _isLoading = true;
      });
      try {
        await ref
            .read(userNotifierProvider.notifier)
            .verifyEmail(VerifyEmailRequest(email: email, otpCode: otp));
        final userState = ref.read(userNotifierProvider);
        if (userState.isDataAvailable && mounted) {
          String? savedRequest =
              await LocalStorageService.get(StorageKeys.signupRequest);
          String firstName = "Dear";
          if (savedRequest != null) {
            SignUpRequest signUpRequest =
                SignUpRequest.fromJson(jsonDecode(savedRequest));
            setState(() {
              firstName = signUpRequest.fullname ?? "Dear";
            });
          }
          context.push('/signup-success', extra: {"firstName": firstName});
        } else if (mounted) {
          CustomToast.showErrorToast(
              context: context,
              message: userState.message ?? 'Invalid otp or expired');
        }
      } catch (e) {
        CustomToast.showErrorToast(
            context: context,
            message: 'An unexpected error occurred: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      CustomToast.showErrorToast(
          context: context,
          message: 'Please enter the complete verification code');
    }
  }

  _resendOtp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // await ref
      //     .read(userNotifierProvider.notifier)
      //     .validateEmail(EmailRequest(email: username));
      CustomToast.showSuccessToast(
          context: context, message: 'Verification code sent to your email.');
      _startResendTimer();
    } catch (e) {
      CustomToast.showErrorToast(
          context: context, message: 'Failed to resend code: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Verify Email Address',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the code we sent to ${widget.emailAddress}.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 45,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
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
                          borderSide: const BorderSide(
                            color: appTheme.primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Didn't receive code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: _resendTimer == 0 ? _resendOtp : null,
                    child: Text(
                      _resendTimer == 0
                          ? 'Resend Code'
                          : 'Resend in $_resendTimer seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: _resendTimer == 0
                            ? appTheme.primaryColor
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              TermsAndConditionsWidget(),
              const SizedBox(height: 50),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FullWidthButton(text: 'Continue', onPressed: _verifyOtp),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
