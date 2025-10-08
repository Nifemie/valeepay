import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../me_widgets/me_reuseable_button.dart';

// State provider for selected categories
final selectedCategoriesProvider =
    StateProvider<List<String>>((ref) => ['All Categories']);

class CategorySelectionSheet extends ConsumerWidget {
  const CategorySelectionSheet({Key? key}) : super(key: key);

  static final List<String> categories = [
    'All Categories',
    'Inter-bank transfer',
    'Intra-bank transfer',
    'Airtime',
    'Betting',
    'Mobile data',
    'Electricity',
    'Hotel',
    'Cable tv',
    'Insurance',
    'Shopping',
    'Currency conversion',
    'Education',
    'Health',
    'Government fee',
    'Flight',
    'International airtime',
    'WAEC & JAMB',
    'Pay water',
    'Internet',
    'TSA & states',
    'Bus tickets',
    'Pay tax',
    'Sell giftcards',
    'Movie tickets',
    'Buy giftcards',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Categories Grid
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = selectedCategories.contains(category);
                  return _buildCategoryChip(
                    context,
                    ref,
                    category,
                    isSelected,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SecondaryButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
              PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  // Apply filters
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    WidgetRef ref,
    String category,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        final selected = ref.read(selectedCategoriesProvider);
        if (category == 'All Categories') {
          ref.read(selectedCategoriesProvider.notifier).state = [
            'All Categories'
          ];
        } else {
          List<String> newSelected = List.from(selected);
          newSelected.remove('All Categories');
          if (isSelected) {
            newSelected.remove(category);
            if (newSelected.isEmpty) {
              newSelected.add('All Categories');
            }
          } else {
            newSelected.add(category);
          }
          ref.read(selectedCategoriesProvider.notifier).state = newSelected;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
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
                color:
                    isSelected ? const Color(0xFFF76301) : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFF76301)
                      : const Color(0xFF9CA3AF),
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
              category,
              style: const TextStyle(
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

// Function to show category selection
void showCategorySelection(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const CategorySelectionSheet(),
  );
}
