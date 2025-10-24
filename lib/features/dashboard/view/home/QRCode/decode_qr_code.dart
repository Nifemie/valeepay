import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/features/dashboard/view/home/QRCode/generate_qr_screen.dart';
import 'package:valarpay/features/notifiers/decode_qr_notifier.dart';
import 'package:valarpay/features/dashboard/view/home/QRCode/decode_qr_result.dart';

class DecodeQrCodeScreen extends ConsumerStatefulWidget {
  const DecodeQrCodeScreen({super.key});

  @override
  ConsumerState<DecodeQrCodeScreen> createState() => _DecodeQrCodeScreenState();
}

class _DecodeQrCodeScreenState extends ConsumerState<DecodeQrCodeScreen> {
  final ImagePicker _picker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController();
  bool _hasPermission = false;
  bool _isProcessing = false;
  File? _pickedImage;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() => _hasPermission = true);
    } else {
      final result = await Permission.camera.request();
      setState(() => _hasPermission = result.isGranted);
    }
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
    await _processImageFile(File(picked.path));
  }

  Future<void> _processImageFile(File? file, {String? qrString}) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      if (qrString != null && qrString.isNotEmpty) {
        // If scanner provides raw QR string, send it directly
        await ref
            .read(decodeQrNotifierProvider.notifier)
            .decodeFromRawString(qrString);
      } else if (file != null) {
        // If uploading an image file, decode QR code locally first
        try {
          final qrCode = await QrCodeToolsPlugin.decodeFrom(file.path);
          if (qrCode != null && qrCode.isNotEmpty) {
            // Send the decoded QR string to the API
            await ref
                .read(decodeQrNotifierProvider.notifier)
                .decodeFromRawString(qrCode);
          } else {
            throw Exception('No QR code found in the image');
          }
        } catch (e) {
          // If local decoding fails, fallback to sending base64 to backend
          final bytes = await file.readAsBytes();
          final base64Data = base64Encode(bytes);
          await ref
              .read(decodeQrNotifierProvider.notifier)
              .decodeFromBase64(base64Data);
        }
      }

      final state = ref.read(decodeQrNotifierProvider);
      if (state.isDataAvailable &&
          state.data != null &&
          state.data!.isNotEmpty) {
        final parsed = state.data!.first;
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DecodeQrResultScreen(data: parsed)),
        );
      } else {
        if (!mounted) return;
        AppMessenger.show(
          context,
          message: state.message ?? 'Failed to decode QR',
          type: MessageType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decode QR Code'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // three-dot icon
            onSelected: (value) {
              if (value == 'generate') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenerateQrScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  value: 'generate',
                  child: Text('Generate QR Code'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      _hasPermission
                          ? MobileScanner(
                            controller: _scannerController,
                            onDetect: (BarcodeCapture capture) async {
                              final barcode = capture.barcodes.first;
                              if (_isProcessing) return;
                              final raw = barcode.rawValue;
                              if (raw == null || raw.isEmpty) return;
                              await _processImageFile(null, qrString: raw);
                            },
                          )
                          : Container(
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Camera permission required'),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await openAppSettings();
                                    },
                                    child: const Text('Open settings'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Image'),
                ),
              ),
              const SizedBox(height: 24),
              if (_pickedImage != null) ...[
                Center(
                  child: const Text(
                    'Picked Image:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _pickedImage!,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
