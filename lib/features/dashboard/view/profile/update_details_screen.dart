import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/notifiers/update_details_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class UpdateUserDetailsScreen extends ConsumerStatefulWidget {
  final String title;
  final String currentValue;
  final String description;
  final String fieldLabel;
  final Function() onContinuePressed;
  final TextEditingController controller;

  const UpdateUserDetailsScreen({
    super.key,
    required this.title,
    required this.controller,
    required this.description,
    required this.currentValue,
    required this.fieldLabel,
    required this.onContinuePressed,
  });

  @override
  ConsumerState<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState
    extends ConsumerState<UpdateUserDetailsScreen> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasChanges = widget.controller.text != widget.currentValue;
    });
  }

  @override
  void dispose() {
    // Don't dispose the controller since it was passed from outside
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(updateDetailsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
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
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFF76301),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.description,
                      style: const TextStyle(
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
              style: const TextStyle(
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
                controller: widget.controller,
                style: const TextStyle(
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
              isEnabled:
                  _hasChanges && widget.controller.text.trim().isNotEmpty,
              onPressed: widget.onContinuePressed,
              isLoading: state.isInitialLoading,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
