import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/me_widgets/category.dart';
import '../../widgets/me_widgets/status_selection.dart';
import 'account_statement.dart'; // Import the new file
import '../../widgets/me_widgets/modal/date_picker_modal.dart';
import 'account_statement.dart';// Import the new file

// Transaction status enum
enum TransactionStatus { successful, pending, failed }

// Transaction model
class Transaction {
  final String title;
  final String date;
  final String amount;
  final TransactionStatus status;

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });
}

// State providers
final selectedMonthProvider = StateProvider<String>((ref) => 'AUG 2025');
final totalInProvider = StateProvider<String>((ref) => '₦7,850');
final totalOutProvider = StateProvider<String>((ref) => '₦23,400');

final transactionsProvider = StateProvider<List<Transaction>>((ref) => [
      Transaction(
        title: 'Interbank Transfer',
        date: 'September 10,2025 10:11 PM',
        amount: '+₦7,850',
        status: TransactionStatus.successful,
      ),
      Transaction(
        title: 'Interbank Transfer',
        date: 'September 10,2025 10:11 PM',
        amount: '+₦7,850',
        status: TransactionStatus.failed,
      ),
      Transaction(
        title: 'Interbank Transfer',
        date: 'September 10,2025 10:11 PM',
        amount: '+₦7,850',
        status: TransactionStatus.pending,
      ),
      Transaction(
        title: 'Interbank Transfer',
        date: 'September 10,2025 10:11 PM',
        amount: '+₦7,850',
        status: TransactionStatus.pending,
      ),
      Transaction(
        title: 'Interbank Transfer',
        date: 'September 10,2025 10:11 PM',
        amount: '+₦7,850',
        status: TransactionStatus.pending,
      ),
      Transaction(
        title: 'Interbank Transfer',
        date: 'September 10,2025 10:11 PM',
        amount: '+₦7,850',
        status: TransactionStatus.pending,
      ),
    ]);

class TransactionHistoryPage extends ConsumerWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final totalIn = ref.watch(totalInProvider);
    final totalOut = ref.watch(totalOutProvider);
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  context.push('/account-statement');
                },
                child: const Text(
                  'Statement',
                  style: TextStyle(
                    color: Color(0xFFF76301),
                    fontFamily: 'SF Pro',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.06,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB0B0B0).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: 'SF Pro',
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Month Selector and Sort By
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Month Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          DatePickerModal.show(
                            context,
                            currentMonth: selectedMonth,
                            onDateSelected: (newDate) {
                              ref.read(selectedMonthProvider.notifier).state =
                                  newDate;
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              selectedMonth,
                              style: const TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'In $totalIn',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontFamily: 'SF Pro',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Out $totalOut',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontFamily: 'SF Pro',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Sort By Button
                  GestureDetector(
                    onTap: () {
                      _showFilterBottomSheet(context, ref);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF76301),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.filter_list,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Sort by',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SF Pro',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Transactions List
              ...transactions.map((transaction) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTransactionItem(context, transaction),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // All Categories Dropdown
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close current sheet
                  showCategorySelection(context); // Show category selection
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'All Categories',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // All Status Dropdown
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close current sheet
                  showStatusSelection(context); // Show status selection
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'All Status',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/convert.svg',
                width: 36,
                height: 34,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFF76301),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    letterSpacing: 0.035,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontFamily: 'SF Pro',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.06,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: 0.035,
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusBadge(transaction.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case TransactionStatus.successful:
        backgroundColor = const Color(0xFF216EB2).withOpacity(0.15);
        textColor = const Color(0xFF216EB2);
        text = 'Successful';
        break;
      case TransactionStatus.pending:
        backgroundColor = const Color(0xFFFFB020).withOpacity(0.15);
        textColor = const Color(0xFFFFB020);
        text = 'Pending';
        break;
      case TransactionStatus.failed:
        backgroundColor = const Color(0xFFF11515).withOpacity(0.15);
        textColor = const Color(0xFFF11515);
        text = 'Failed';
        break;
    }

    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontFamily: 'SF Pro',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.4,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
