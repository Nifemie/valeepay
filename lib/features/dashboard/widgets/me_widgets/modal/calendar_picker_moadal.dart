import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPickerModal {
  static void show(
      BuildContext context, {
        required DateTime initialDate,
        required Function(DateTime) onDateSelected,
      }) {
    showDialog(
      context: context,
      builder: (context) => _CalendarPickerContent(
        initialDate: initialDate,
        onDateSelected: onDateSelected,
      ),
    );
  }
}

class _CalendarPickerContent extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const _CalendarPickerContent({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<_CalendarPickerContent> createState() => _CalendarPickerContentState();
}

class _CalendarPickerContentState extends State<_CalendarPickerContent> {
  late DateTime currentMonth;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    selectedDate = widget.initialDate;
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void _showYearPicker() {
    showDialog(
      context: context,
      builder: (context) => _YearPickerDialog(
        currentYear: currentMonth.year,
        onYearSelected: (year) {
          setState(() {
            currentMonth = DateTime(year, currentMonth.month);
          });
        },
      ),
    );
  }

  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    final days = <DateTime?>[];

    // Add empty cells for days before the first day of month
    for (int i = 0; i < firstDay.weekday % 7; i++) {
      days.add(null);
    }

    // Add all days in the month
    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, day));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final monthYear = DateFormat('MMMM yyyy').format(currentMonth);
    final days = _getDaysInMonth();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with year selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF76301),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _showYearPicker,
                    child: Row(
                      children: [
                        Text(
                          currentMonth.year.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'SF Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Month navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _previousMonth,
                    color: const Color(0xFF111827),
                  ),
                  Text(
                    monthYear,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontFamily: 'SF Pro',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                    color: const Color(0xFF111827),
                  ),
                ],
              ),
            ),

            // Weekday headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                  return SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontFamily: 'SF Pro',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Calendar grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final date = days[index];
                  if (date == null) {
                    return const SizedBox.shrink();
                  }

                  final isSelected = date.year == selectedDate.year &&
                      date.month == selectedDate.month &&
                      date.day == selectedDate.day;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                      widget.onDateSelected(date);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF76301)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF111827),
                            fontFamily: 'SF Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Year Picker Dialog
class _YearPickerDialog extends StatefulWidget {
  final int currentYear;
  final Function(int) onYearSelected;

  const _YearPickerDialog({
    required this.currentYear,
    required this.onYearSelected,
  });

  @override
  State<_YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<_YearPickerDialog> {
  late int selectedYear;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.currentYear;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<int> _getYearsList() {
    final currentYear = DateTime.now().year;
    return List.generate(100, (index) => currentYear - index);
  }

  @override
  Widget build(BuildContext context) {
    final years = _getYearsList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Year list
            Flexible(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 20),
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF111827)
                              : const Color(0xFFD1D5DB),
                          fontFamily: 'SF Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Done Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  widget.onYearSelected(selectedYear);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}