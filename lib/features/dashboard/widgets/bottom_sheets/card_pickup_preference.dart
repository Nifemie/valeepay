import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class SelectPreferenceBottomSheet extends StatefulWidget {
  const SelectPreferenceBottomSheet({super.key});

  @override
  State<SelectPreferenceBottomSheet> createState() =>
      _SelectPreferenceBottomSheetState();
}

class _SelectPreferenceBottomSheetState
    extends State<SelectPreferenceBottomSheet> {
  String selectedOption = "branch"; // default selection

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // title bar
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: Colors.black87),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              const Text(
                "Select Preference",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // "Visit a branch" option
          _buildOption(
            title: "Visit a branch for collection",
            value: "branch",
          ),
          const Divider(height: 24),

          // "House delivery" option
          _buildOption(
            title: "House Delivery",
            value: "delivery",
          ),

          const SizedBox(height: 28),

          // confirm button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedOption);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({required String title, required String value}) {
    final bool isSelected = selectedOption == value;

    return InkWell(
      onTap: () => setState(() => selectedOption = value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? appTheme.primaryColor : Colors.grey,
                  width: 1.4,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
