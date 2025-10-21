import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State providers
final balanceProvider = StateProvider<String>((ref) => '₦7,500.00');
final rewardsProvider = StateProvider<String>((ref) => '₦7,500');
final isBalanceVisibleProvider = StateProvider<bool>((ref) => true);

// Finance items model
class FinanceItem {
  final String name;
  final String amount;

  FinanceItem({required this.name, required this.amount});
}

final financeItemsProvider = StateProvider<List<FinanceItem>>((ref) => [
  FinanceItem(name: 'Fixed Savings', amount: '₦200,000'),
  FinanceItem(name: 'Target Savings', amount: '₦500,000'),
  FinanceItem(name: 'Easylife', amount: '₦500,000'),
  FinanceItem(name: 'Fixed Deposit', amount: '₦500,000'),
]);

final investItemsProvider = StateProvider<List<FinanceItem>>((ref) => [
  FinanceItem(name: 'Investment', amount: '₦200,000'),
]);

class MyPortfolioPage extends ConsumerWidget {
  const MyPortfolioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final rewards = ref.watch(rewardsProvider);
    final isBalanceVisible = ref.watch(isBalanceVisibleProvider);
    final financeItems = ref.watch(financeItemsProvider);
    final investItems = ref.watch(investItemsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Portfolio',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Balance Card
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Your Balance',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                          letterSpacing: 0.06,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          ref.read(isBalanceVisibleProvider.notifier).state =
                          !isBalanceVisible;
                        },
                        child: Icon(
                          isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 16,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isBalanceVisible ? balance : '₦****',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontFamily: 'SF Pro',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF216EB2).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Your Rewards: $rewards',
                          style: const TextStyle(
                            color: Color(0xFF216EB2),
                            fontFamily: 'SF Pro',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 8,
                          color: Color(0xFF216EB2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF76301),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Finance Section
              _buildSectionTitle('Finance'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: financeItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isLast = index == financeItems.length - 1;
                    return Column(
                      children: [
                        _buildListItem(item),
                        if (!isLast)
                          Container(
                            height: 2,
                            color: const Color(0xFFF1F4FB),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              // Invest Section
              _buildSectionTitle('Invest'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: investItems.map((item) => _buildListItem(item)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontFamily: 'SF Pro',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildListItem(FinanceItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.43,
              letterSpacing: 0.035,
            ),
          ),
          Text(
            item.amount,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: 0.035,
            ),
          ),
        ],
      ),
    );
  }
}