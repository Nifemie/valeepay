import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/dashboard/view/KYC/setup_pin.dart';
import 'package:valarpay/features/models/bvn_validate_request.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';
import '../../widgets/Kyc/kyc_progress_bar.dart';
import 'kyc_step_provider.dart';

/// BVN OTP Verification Screen
///
/// This screen is shown after user submits their BVN.
/// Backend sends OTP to the phone number linked to the BVN.
/// User must enter the OTP to verify BVN ownership.
///
/// Flow: BVN Entry → Initialize BVN API → THIS SCREEN → Validate BVN API → Transaction PIN Setup
///
/// ✅ IMPLEMENTED:
/// 1. initializeBvn() called from BVN.dart before navigating here
/// 2. verificationId passed from initializeBvn response
/// 3. validateBvn() called with verificationId + otpCode
/// 4. Navigates to PIN setup on success
///
/// 📝 NOTE: Camera Permission and Identity Verification screens are skipped for now.
/// They will be used later for KYC Level 2 (NIN verification with selfie capture).

// State provider for verification ID (from initialize BVN response)
final bvnVerificationIdProvider = StateProvider<String?>((ref) => null);

class BvnOtpVerificationPage extends ConsumerStatefulWidget {
  final String bvn; // The BVN entered in previous screen
  final String? verificationId; // From initializeBvn API response

  const BvnOtpVerificationPage({
    Key? key,
    required this.bvn,
    this.verificationId,
  }) : super(key: key);

  @override
  ConsumerState<BvnOtpVerificationPage> createState() =>
      _BvnOtpVerificationPageState();
}

class _BvnOtpVerificationPageState extends ConsumerState<BvnOtpVerificationPage>
    with CodeAutoFill {
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-read SMS OTP
    listenForCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    setState(() {
      _otp = code ?? '';
    });
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        if (mounted) setState(() {});
      } else {
        if (mounted) {
          setState(() {
            _resendTimer--;
          });
        }
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'Please enter the complete 6-digit OTP',
      );
      return;
    }

    // Validate BVN with OTP
    setState(() => _isLoading = true);
    try {
      final verificationId =
          widget.verificationId ?? ref.read(bvnVerificationIdProvider);

      if (verificationId == null) {
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: 'Verification session expired. Please restart.',
        );
        Navigator.pop(context);
        return;
      }

      final request = BvnValidateRequest(
        verificationId: verificationId,
        otpCode: _otp,
      );

      final response =
          await ref.read(userNotifierProvider.notifier).validateBvn(request);

      if (response != null) {
        // Success - BVN verified, proceed to PIN setup
        AppMessenger.show(
          context,
          type: MessageType.success,
          message: response.message,
        );

        // Navigate to PIN setup (skip camera/identity for now - needed for KYC Level 2)
        ref.read(kycStepProvider.notifier).state = 4;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SetupTransactionPinPage(),
          ),
        );
      } else {
        // Error
        final userState = ref.read(userNotifierProvider);
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: userState.message ?? 'Invalid OTP. Please try again.',
        );
      }
    } catch (e) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'Verification failed: ${e.toString()}',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    // TODO: When backend is ready, call initializeBvn again
    /*
    setState(() => _isLoading = true);
    try {
      final request = BvnInitializeRequest(bvn: widget.bvn);
      await ref.read(kycNotifierProvider.notifier).initializeBvn(request);
      
      final kycState = ref.read(kycNotifierProvider);
      if (kycState.isDataAvailable) {
        // Update verification ID
        ref.read(bvnVerificationIdProvider.notifier).state = 
          kycState.data?.first.verificationId;
        
        AppMessenger.show(
          context,
          type: MessageType.success,
          message: 'OTP resent to your phone',
        );
        _startResendTimer();
      }
    } catch (e) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'Failed to resend OTP: ${e.toString()}',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
    */

    // Temporary
    AppMessenger.show(
      context,
      type: MessageType.info,
      message: 'Resend OTP will be enabled when backend is ready',
    );
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(kycStepProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(kycStepProvider.notifier).state = 2;
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Step Progress Bar
              StepProgressBar(currentStep: currentStep),
              const SizedBox(height: 40),

              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF76301).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sms_outlined,
                  size: 40,
                  color: Color(0xFFF76301),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Verify Your BVN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Enter the 6-digit OTP sent to the phone number\nlinked to your BVN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // BVN Display (masked)
              Text(
                'BVN: ${widget.bvn.substring(0, 3)}****${widget.bvn.substring(widget.bvn.length - 3)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFF76301),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // OTP Input
              PinFieldAutoFill(
                codeLength: 6,
                currentCode: _otp,
                onCodeChanged: (code) {
                  setState(() => _otp = code ?? '');
                },
                decoration: BoxLooseDecoration(
                  strokeColorBuilder: PinListenColorBuilder(
                    const Color(0xFFE5E7EB),
                    const Color(0xFFF76301),
                  ),
                  bgColorBuilder: const FixedColorBuilder(Colors.transparent),
                  radius: const Radius.circular(8),
                  strokeWidth: 1.5,
                  gapSpace: 12,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),

              // Verify Button
              FullWidthButton(
                text: 'Verify BVN',
                isEnabled: _otp.length == 6,
                isLoading: _isLoading,
                onPressed: _verifyOtp,
              ),
              const SizedBox(height: 24),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive OTP? ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  if (_resendTimer > 0)
                    Text(
                      'Resend in ${_resendTimer}s',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _isLoading ? null : _resendOtp,
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Color(0xFFF76301),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFCD34D),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFD97706),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The OTP was sent to the phone number registered with your BVN',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
