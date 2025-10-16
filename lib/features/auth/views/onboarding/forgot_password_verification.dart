import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/constants/storage_keys.dart';
import 'package:valarpay/core/services/local_storage_service.dart';
import 'package:valarpay/core/widgets/custom_toast.dart';
import 'package:valarpay/features/models/forgot_password.dart';
import 'package:valarpay/features/models/verify_forgot_password.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class ForgotPasswordVerificationScreen extends ConsumerStatefulWidget {
  const ForgotPasswordVerificationScreen({super.key});

  @override
  ConsumerState<ForgotPasswordVerificationScreen> createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends ConsumerState<ForgotPasswordVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendTimer = 50;
  Timer? _timer;
  bool _isLoading = false;
  String? username;

  _getUsername() async {
    String? username = await LocalStorageService.get(StorageKeys.username);
    setState(() {
      username = username;
    });
  }

  _resendOtp() async {
    String? username = await LocalStorageService.get(StorageKeys.username);
    if (username != null) {
      Navigator.pop(context);
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await ref
          .read(userNotifierProvider.notifier)
          .forgotPassword(ForgotPasswordRequest(username: username));
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

  _verifyOtp() async {
    String otp = _controllers.map((controller) => controller.text).join();
    String? username = await LocalStorageService.get(StorageKeys.username);
    if (username != null) {
      Navigator.pop(context);
    }

    if (otp.length == 4) {
      setState(() {
        _isLoading = true;
      });
      try {
        await ref.read(userNotifierProvider.notifier).verifyForgotPassword(
            VerifyForgotPassword(username: username, otpCode: otp));
        final userState = ref.read(userNotifierProvider);
        if (userState.isDataAvailable && mounted) {
          context.push('/reset-password');
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

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 50;
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

  @override
  void initState() {
    _getUsername();
    super.initState();
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                'Enter Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle with email
              Text(
                'Enter the code we sent to ${username ?? 'your email'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 60,
                    height: 60,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B35),
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

              const SizedBox(height: 24),

              // Resend Code Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resendTimer == 0 ? _resendOtp : null,
                    child: Text(
                      _resendTimer == 0
                          ? 'Resend'
                          : 'Resend in ${_resendTimer}seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: _resendTimer == 0
                            ? const Color(0xFFFF6B35)
                            : Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Continue Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
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

              const SizedBox(height: 24),
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
