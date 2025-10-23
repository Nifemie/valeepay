import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:valarpay/core/services/verification_service.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/dashboard/view/KYC/setup_pin.dart';
import 'package:valarpay/features/models/kyc_address_request.dart';
import 'package:valarpay/features/models/qore_bvn_face_verification_request.dart';
import '../../widgets/Kyc/kyc_progress_bar.dart';
import '../../widgets/Kyc/Dialog/profile_setup_dialog.dart';
import 'kyc_step_provider.dart';
import 'dart:convert';

class IdentityVerificationPage extends ConsumerStatefulWidget {
  final KycAddressRequest request;
  const IdentityVerificationPage({required this.request, Key? key})
    : super(key: key);

  @override
  ConsumerState<IdentityVerificationPage> createState() =>
      _IdentityVerificationPageState();
}

class _IdentityVerificationPageState
    extends ConsumerState<IdentityVerificationPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _isCaptured = false;
  bool _isLoading = false;
  File? _capturedImage;
  Timer? _countdownTimer;
  int _countdown = 10;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      _startCountdown();
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  void _startCountdown() {
    setState(() {
      _countdown = 10;
      _isCaptured = false;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        await _capturePhoto();
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() => _isCapturing = true);
      final image = await _controller!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/face_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedImage = await File(image.path).copy(imagePath);

      setState(() {
        _capturedImage = savedImage;
        _isCaptured = true;
        _isCapturing = false;
      });
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      setState(() => _isCapturing = false);
    }
  }

  void _retake() {
    setState(() {
      _capturedImage = null;
      _isCaptured = false;
    });
    _startCountdown();
  }

  Future<void> _verifyCapturedImage(File? capturedImage) async {
    if (capturedImage == null) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'No captured image found. Please try again.',
      );
      return;
    }

    try {
      log("Verification started");
      log(jsonEncode(widget.request));

      final bytes = await capturedImage.readAsBytes();
      final base64Image = base64Encode(bytes);
      

      final requestBody = QoreBvnFaceVerificationRequest(
        idNumber: widget.request.bvn.toString(),
        photoBase64: base64Image,
      );

      log(jsonEncode(requestBody));

      setState(() => _isLoading = true);
      final service = VerificationService();
      final response = await service.verifyBvnFace(requestBody);

      log(jsonEncode(response));

      if (response.summary?.faceVerificationCheck?.faceVerification != null) {
        final faceData =
            response.summary!.faceVerificationCheck!.faceVerification!;
        final name = "${faceData.firstname ?? ''} ${faceData.lastname ?? ''}";
        final phone = faceData.phone ?? 'N/A';

        AppMessenger.show(
          context,
          type: MessageType.success,
          message: 'BVN Verified Successfully!\nName: $name\nPhone: $phone',
        );
        _showSuccessDialog();
      } else {
        AppMessenger.show(
          context,
          type: MessageType.error,
          message:
              response.message ?? 'Face verification failed. Please retry.',
        );
      }
    } catch (e) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'Face verification failed: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProfileSetupSuccessDialog(
          onContinue: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SetupTransactionPinPage(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _countdownTimer?.cancel();
    super.dispose();
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
              StepProgressBar(currentStep: currentStep),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF76301),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_isCameraInitialized && !_isCaptured)
                          FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width:
                                  _controller!
                                      .value
                                      .previewSize!
                                      .height, // swap to correct ratio
                              height: _controller!.value.previewSize!.width,
                              child: CameraPreview(_controller!),
                            ),
                          )
                        else if (_capturedImage != null)
                          Image.file(_capturedImage!, fit: BoxFit.cover),
                        if (!_isCaptured && _isCameraInitialized)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                '$_countdown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (_isCapturing)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_isCameraInitialized && _isCaptured)
                TextButton(
                  onPressed: _isCameraInitialized ? _retake : null,
                  child: Icon(Icons.refresh, size: 40),
                ),
              // Title
              const Text(
                'Tips for a Successful Identity Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 16,
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

              const SizedBox(height: 20),
              FullWidthButton(
                text: 'Continue',
                isLoading: _isLoading,
                isEnabled: _capturedImage != null,
                onPressed: () {
                  if (_capturedImage != null) {
                    ref.read(kycStepProvider.notifier).state = 4;
                    _verifyCapturedImage(_capturedImage);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TipItem extends StatelessWidget {
  final String text;

  const TipItem({Key? key, required this.text}) : super(key: key);

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
            border: Border.all(color: const Color(0xFF9CA3AF), width: 1.5),
          ),
          child: const Icon(Icons.check, size: 12, color: Color(0xFF9CA3AF)),
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
