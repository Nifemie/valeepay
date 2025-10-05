import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../me_widgets/me_reuseable_button.dart';

// State provider for selected status
final selectedStatusesProvider = StateProvider<List<String>>((ref) => ['All Status']);

class StatusSelectionSheet extends ConsumerWidget {
  const StatusSelectionSheet({Key? key}) : super(key: key);

  static final List<String> statuses = [
    'All Status',
    'Processing',
    'Successful',
    'Failed',
    'Cancelled',
    'Refunded',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatuses = ref.watch(selectedStatusesProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: statuses.map((status) {
              final isSelected = selectedStatuses.contains(status);
              return _buildStatusChip(
                context,
                ref,
                status,
                isSelected,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Buttons Row
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: () {
                    // Apply filters
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context,
      WidgetRef ref,
      String status,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () {
        final selected = ref.read(selectedStatusesProvider);
        if (status == 'All Status') {
          ref.read(selectedStatusesProvider.notifier).state = ['All Status'];
        } else {
          List<String> newSelected = List.from(selected);
          newSelected.remove('All Status');
          if (isSelected) {
            newSelected.remove(status);
            if (newSelected.isEmpty) {
              newSelected.add('All Status');
            }
          } else {
            newSelected.add(status);
          }
          ref.read(selectedStatusesProvider.notifier).state = newSelected;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFF1F4FB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkmark
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFFF76301) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xFFF76301) : const Color(0xFF9CA3AF),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              status,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Function to show status selection
void showStatusSelection(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const StatusSelectionSheet(),
  );
}