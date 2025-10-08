import 'package:flutter/material.dart';

class DatePickerModal {
  static void show(
    BuildContext context, {
    required String currentMonth,
    required Function(String) onDateSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DatePickerContent(
        currentMonth: currentMonth,
        onDateSelected: onDateSelected,
      ),
    );
  }
}

class _DatePickerContent extends StatefulWidget {
  final String currentMonth;
  final Function(String) onDateSelected;

  const _DatePickerContent({
    required this.currentMonth,
    required this.onDateSelected,
  });

  @override
  State<_DatePickerContent> createState() => _DatePickerContentState();
}

class _DatePickerContentState extends State<_DatePickerContent> {
  late String selectedMonth;
  late String selectedYear;
  late List<String> years;
  late ScrollController _monthScrollController;
  late ScrollController _yearScrollController;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    // Generate years from current year back to 1900
    final currentYear = DateTime.now().year;
    years = List.generate(
        currentYear - 1900 + 1, (index) => (currentYear - index).toString());

    _monthScrollController = ScrollController();
    _yearScrollController = ScrollController();

    // Parse current month (e.g., "AUG 2025")
    final parts = widget.currentMonth.split(' ');
    selectedYear = parts.length > 1 ? parts[1] : '2025';

    // Convert short month to full name
    final monthMap = {
      'JAN': 'January',
      'FEB': 'February',
      'MAR': 'March',
      'APR': 'April',
      'MAY': 'May',
      'JUN': 'June',
      'JUL': 'July',
      'AUG': 'August',
      'SEP': 'September',
      'OCT': 'October',
      'NOV': 'November',
      'DEC': 'December',
    };

    selectedMonth = monthMap[parts[0]] ?? 'June';
  }

  @override
  void dispose() {
    _monthScrollController.dispose();
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed background
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // Modal content
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Month and Year Pickers Side by Side
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      // Month Column (Scrollable)
                      Expanded(
                        child: ListView.builder(
                          controller: _monthScrollController,
                          itemCount: months.length,
                          itemBuilder: (context, index) {
                            final month = months[index];
                            final isSelected = month == selectedMonth;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMonth = month;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF111827)
                                        : const Color(0xFFD1D5DB),
                                    fontFamily: 'SF Pro',
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Year Column (Scrollable)
                      Expanded(
                        child: ListView.builder(
                          controller: _yearScrollController,
                          itemCount: years.length,
                          itemBuilder: (context, index) {
                            final year = years[index];
                            final isSelected = year == selectedYear;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedYear = year;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  year,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF111827)
                                        : const Color(0xFFD1D5DB),
                                    fontFamily: 'SF Pro',
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Done Button
                GestureDetector(
                  onTap: () {
                    // Convert full month name to short form
                    final monthShort =
                        selectedMonth.substring(0, 3).toUpperCase();
                    widget.onDateSelected('$monthShort $selectedYear');
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF76301),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
