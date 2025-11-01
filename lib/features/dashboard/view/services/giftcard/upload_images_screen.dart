import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

import '/core/themes/color_utils.dart';

class UploadImagesScreen extends StatefulWidget {
  const UploadImagesScreen({super.key});

  @override
  State<UploadImagesScreen> createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  // Six fixed upload slots. Each can be null or hold a picked image.
  final List<XFile?> _images = List<XFile?>.filled(6, null);
  final ImagePicker _picker = ImagePicker();

  // Show bottom sheet to let user pick camera or gallery
  void _showPickOptions(int index) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery, index);
              },
            ),
            SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Pick an image from the given source and assign to the slot
  Future<void> _pickImage(ImageSource source, int index) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _images[index] = picked;
        });
      }
    } catch (e) {
      // You may wish to show an error/snackbar here if needed
      // For now we silently ignore pick errors.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Images',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload instruction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.upload_file,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Choose the giftcard image directly from your phone gallery (max 2MB)',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Upload grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: 6, // Max 6 upload slots
                itemBuilder: (context, index) {
                  final XFile? img = _images[index];
                  if (img != null) {
                    // Show uploaded image preview
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(img.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images[index] = null;
                                });
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Placeholder slot
                  return GestureDetector(
                    onTap: () => _showPickOptions(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Continue Button
            FullWidthButton(
              text: 'Continue',
              isEnabled: _images.any((e) => e != null),
              onPressed: () {
                // Continue with uploaded images. For example, upload to server or navigate.
                AppMessenger.show(context,
                    message: 'Sell giftcards is coming soon',
                    type: MessageType.warning);
              },
            )
          ],
        ),
      ),
    );
  }
}
