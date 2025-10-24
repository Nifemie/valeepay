import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
// unused imports removed
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';
import 'package:valarpay/features/notifiers/report_scam_notifier.dart';

class ReportScamScreen extends ConsumerStatefulWidget {
  const ReportScamScreen({super.key});

  @override
  ConsumerState<ReportScamScreen> createState() => _ReportScamScreenState();
}

class _ReportScamScreenState extends ConsumerState<ReportScamScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _screenshot;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      _screenshot = File(picked.path);
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      AppMessenger.show(
        context,
        message: 'Please provide title and description',
        type: MessageType.error,
      );
      return;
    }

    // call notifier to upload
    ref
        .read(reportScamNotifierProvider.notifier)
        .report(
          title: _titleController.text,
          description: _descriptionController.text,
          screenshot: _screenshot,
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportScamNotifierProvider);

    ref.listen(reportScamNotifierProvider, (previous, next) {
      if (!next.isInitialLoading) {
        if (next.isDataAvailable) {
          AppMessenger.show(
            context,
            message: 'Report submitted successfully',
            type: MessageType.success,
          );
          setState(() {
            _titleController.clear();
            _descriptionController.clear();
            _screenshot = null;
          });
        } else if (next.message != null) {
          AppMessenger.show(
            context,
            message: next.message!,
            type: MessageType.error,
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Scam'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Title',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Short title for the issue',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Describe the scam in details',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 24),
              const Text(
                'Screenshot',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Theme.of(context).cardColor,
                  ),
                  child:
                      _screenshot == null
                          ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.camera_alt, size: 36),
                                SizedBox(height: 8),
                                Text('Tap to attach screenshot'),
                              ],
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_screenshot!, fit: BoxFit.cover),
                          ),
                ),
              ),
              const SizedBox(height: 32),
              FullWidthButton(
                text: 'Submit Report',
                isEnabled:
                    _titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty,
                onPressed: _submit,
                isLoading: state.isInitialLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
