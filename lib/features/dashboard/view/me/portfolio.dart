import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/features/providers/user_provider.dart';

// State providers
final isBalanceVisibleProvider = StateProvider<bool>((ref) => true);

// Finance items model
class FinanceItem {
  final String name;
  final String amount;

  FinanceItem({required this.name, required this.amount});
}

// TODO: Replace with actual API data when backend is ready
final financeItemsProvider = StateProvider<List<FinanceItem>>((ref) => []);

// TODO: Replace with actual API data when backend is ready
final investItemsProvider = StateProvider<List<FinanceItem>>((ref) => []);

class MyPortfolioPage extends ConsumerWidget {
  const MyPortfolioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isBalanceVisible = ref.watch(isBalanceVisibleProvider);
    final financeItems = ref.watch(financeItemsProvider);
    final investItems = ref.watch(investItemsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get real wallet balance
    final hasWallet = user?.wallets.isNotEmpty ?? false;
    final wallet = hasWallet ? user!.wallets.first : null;
    final balance = wallet?.balance ?? 0.0;
    final balanceText = currencyFormatter(balance.toString());
    final rewards = '₦0'; // TODO: Replace with real rewards when available

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
                      Text(
                        'Your Balance',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                          letterSpacing: 0.06,
                          color: isDark ? Colors.grey.shade400 : null,
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
                          color:
                              isDark
                                  ? Colors.grey.shade400
                                  : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isBalanceVisible ? balanceText : '₦ •••••',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontFamily: 'SF Pro',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      context.push('/my-rewards');
                    },
                    child: Container(
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
              _buildSectionTitle('Finance', isDark),
              const SizedBox(height: 16),
              financeItems.isEmpty
                  ? _buildEmptySection(context, isDark, 'No finance items yet')
                  : Container(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.grey.shade800
                              : const Color(0xFFFAFBFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children:
                          financeItems.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            final isLast = index == financeItems.length - 1;
                            return Column(
                              children: [
                                _buildListItem(item, isDark),
                                if (!isLast)
                                  Container(
                                    height: 2,
                                    color:
                                        isDark
                                            ? Colors.grey.shade700
                                            : const Color(0xFFF1F4FB),
                                  ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
              const SizedBox(height: 32),
              // Invest Section
              _buildSectionTitle('Invest', isDark),
              const SizedBox(height: 16),
              investItems.isEmpty
                  ? _buildEmptySection(context, isDark, 'No investments yet')
                  : Container(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.grey.shade800
                              : const Color(0xFFFAFBFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children:
                          investItems
                              .map((item) => _buildListItem(item, isDark))
                              .toList(),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySection(BuildContext context, bool isDark, String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 14,
            color: isDark ? Colors.grey.shade400 : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.5,
          color: isDark ? Colors.white : null,
        ),
      ),
    );
  }

  Widget _buildListItem(FinanceItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.name,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : const Color(0xFF9CA3AF),
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.43,
              letterSpacing: 0.035,
            ),
          ),
          Text(
            item.amount,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: 0.035,
              color: isDark ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }
}
