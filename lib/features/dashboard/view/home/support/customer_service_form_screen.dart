import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';

class CustomerServiceFormScreen extends StatefulWidget {
  final String title;

  const CustomerServiceFormScreen({super.key, required this.title});

  @override
  State<CustomerServiceFormScreen> createState() =>
      _CustomerServiceFormScreenState();
}

class _CustomerServiceFormScreenState extends State<CustomerServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issueController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        // Show success message
        AppMessenger.show(
          context,
          type: MessageType.success,
          message: 'Your complaint has been submitted successfully',
        );

        // Clear the form
        _issueController.clear();
        _formKey.currentState!.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('${widget.title} Complaint'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.paddingAll16,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with icon
                Container(
                  width: double.infinity,
                  padding: ResponsiveUtils.paddingAll16,
                  decoration: BoxDecoration(
                    color: appTheme.primaryColor.withOpacity(0.1),
                    borderRadius: ResponsiveUtils.borderRadius12,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: appTheme.primaryColor,
                        child: Icon(
                          _getIconForTitle(widget.title),
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing12),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.fontSize20,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing4),
                      Text(
                        'Please describe the issue you\'re experiencing',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: ResponsiveUtils.fontSize14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveUtils.spacing24),

                // Form label
                Text(
                  'Describe Your Issue',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.fontSize16,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing8),

                // Issue description field
                TextFormField(
                  controller: _issueController,
                  maxLines: 8,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText:
                        'Tell us what happened and how we can help you...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: ResponsiveUtils.fontSize14,
                    ),
                    filled: true,
                    fillColor:
                        isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: ResponsiveUtils.borderRadius12,
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: ResponsiveUtils.borderRadius12,
                      borderSide: BorderSide(
                        color:
                            isDark
                                ? const Color(0xFF4B5563)
                                : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: ResponsiveUtils.borderRadius12,
                      borderSide: BorderSide(
                        color: appTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: ResponsiveUtils.borderRadius12,
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: ResponsiveUtils.borderRadius12,
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: ResponsiveUtils.paddingAll16,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please describe your issue';
                    }
                    if (value.trim().length < 10) {
                      return 'Please provide more details (at least 10 characters)';
                    }
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveUtils.spacing24),

                // Info card
                Container(
                  padding: ResponsiveUtils.paddingAll12,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: ResponsiveUtils.borderRadius8,
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
                      SizedBox(width: ResponsiveUtils.spacing8),
                      Expanded(
                        child: Text(
                          'Our support team will review your complaint and get back to you within 24-48 hours.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[700],
                            fontSize: ResponsiveUtils.fontSize12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveUtils.spacing32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: ResponsiveUtils.paddingVertical16,
                      shape: RoundedRectangleBorder(
                        borderRadius: ResponsiveUtils.borderRadius12,
                      ),
                      disabledBackgroundColor: appTheme.primaryColor
                          .withOpacity(0.6),
                    ),
                    child:
                        _isSubmitting
                            ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 20.sp),
                                SizedBox(width: ResponsiveUtils.spacing8),
                                Text(
                                  'Submit Complaint',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.fontSize16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),

                SizedBox(height: ResponsiveUtils.spacing16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'card issue':
        return Icons.credit_card_outlined;
      case 'transfer dispute':
        return Icons.swap_horiz;
      case 'phone number change':
        return Icons.phone_outlined;
      case 'theme':
        return Icons.palette_outlined;
      case 'pin settings':
        return Icons.settings_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
