import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/Kyc/KYC_reusable_button.dart';
import '../../widgets/Kyc/kyc_progress_bar.dart';
import '../../widgets/Kyc/Dialog/profile_setup_dialog.dart';
import 'setup_passcode.dart';
import 'kyc_step_provider.dart';

class IdentityVerificationTipsPage extends ConsumerStatefulWidget {
  const IdentityVerificationTipsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<IdentityVerificationTipsPage> createState() =>
      _IdentityVerificationTipsPageState();
}

class _IdentityVerificationTipsPageState
    extends ConsumerState<IdentityVerificationTipsPage> {
  @override
  void initState() {
    super.initState();
    // Show dialog after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProfileSetupSuccessDialog(
          onContinue: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
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
          }
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
              // Head Capture Image with Dashed Border
              Container(
                width: 150,
                height: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF76301),
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: CustomPaint(
                  painter: DashedCirclePainter(
                    color: const Color(0xFFF76301),
                    strokeWidth: 1,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/head_capture.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Tips for a Successful Identity Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Tips List
              const TipItem(
                text:
                'Stay in a bright, well-lit environment for clear visibility',
              ),
              const SizedBox(height: 16),
              const TipItem(
                text:
                'Hold your phone steady at eye level without shaking hands',
              ),
              const SizedBox(height: 16),
              const TipItem(
                text:
                'Keep your entire face clearly visible inside the camera frame',
              ),
              const SizedBox(height: 16),
              const TipItem(
                text:
                'Remove caps, glasses, or face coverings for accurate detection',
              ),
              const SizedBox(height: 40),
              // Continue Button
              FullWidthButton(
                text: 'Continue',
                isEnabled: true,
                onPressed: () {
                  ref.read(kycStepProvider.notifier).state = 4;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupTransactionPinPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Retake Button
              TextButton(
                onPressed: () {
                  // Go back to retake
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  'Retake',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tip Item Widget
class TipItem extends StatelessWidget {
  final String text;

  const TipItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF9CA3AF),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.check,
            size: 12,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Dashed Circle Border
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1,
    this.dashWidth = 5,
    this.dashSpace = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * 3.141592653589793 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashWidth + dashSpace) / radius);
      final sweepAngle = dashWidth / radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}