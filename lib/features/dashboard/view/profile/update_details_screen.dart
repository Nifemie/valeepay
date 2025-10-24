import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

class UpdateUserDetailsScreen extends ConsumerStatefulWidget {
  final String title;
  final String currentValue;
  final String description;
  final String fieldLabel;
  final Function() onContinuePressed;

  const UpdateUserDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.currentValue,
    required this.fieldLabel,
    required this.onContinuePressed
  });

  @override
  ConsumerState<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends ConsumerState<UpdateUserDetailsScreen> {
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
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
                      widget.description,
                      style: TextStyle(
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            // Text field
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
               
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(
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
              onPressed: widget.onContinuePressed,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
