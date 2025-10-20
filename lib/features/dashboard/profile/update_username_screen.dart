import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

class UpdateUsernameScreen extends ConsumerStatefulWidget {
  final String title;
  final String currentValue;
  final String fieldLabel;

  const UpdateUsernameScreen({
    super.key,
    required this.title,
    required this.currentValue,
    required this.fieldLabel,
  });

  @override
  ConsumerState<UpdateUsernameScreen> createState() =>
      _UpdateUsernameScreenState();
}

class _UpdateUsernameScreenState extends ConsumerState<UpdateUsernameScreen> {
  late TextEditingController _controller;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasChanges = _controller.text != widget.currentValue;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF76301).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFFF76301),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enter your username that will be used in your profile',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Field label
            Text(
              widget.fieldLabel,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            // Text field
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Smith',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const Spacer(),

            // Continue button
            FullWidthButton(
              text: 'Continue',
              isEnabled: _hasChanges && _controller.text.trim().isNotEmpty,
              onPressed: () {
                if (_hasChanges && _controller.text.trim().isNotEmpty) {
                  // Handle update logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${widget.fieldLabel} updated successfully'),
                      backgroundColor: const Color(0xFFF76301),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
