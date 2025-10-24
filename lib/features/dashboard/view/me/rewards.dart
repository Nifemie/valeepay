import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Reward item model
class RewardItem {
  final String title;
  final String date;
  final String amount;

  RewardItem({required this.title, required this.date, required this.amount});

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'] ?? '₦0',
    );
  }
}

// TODO: Replace with actual API provider when backend is ready
final rewardsListProvider = StateProvider<List<RewardItem>>((ref) => []);

class MyRewardsPage extends ConsumerStatefulWidget {
  const MyRewardsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyRewardsPage> createState() => _MyRewardsPageState();
}

class _MyRewardsPageState extends ConsumerState<MyRewardsPage> {
  @override
  void initState() {
    super.initState();
    // TODO: Fetch rewards from API when backend is ready
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(rewardsNotifierProvider.notifier).fetchRewards();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final rewards = ref.watch(rewardsListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Rewards',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.43,
            letterSpacing: 0.035,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body:
          rewards.isEmpty
              ? _buildEmptyState(context, isDark)
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children:
                        rewards.map((reward) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: _buildRewardItem(context, reward, isDark),
                          );
                        }).toList(),
                  ),
                ),
              ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF76301).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.card_giftcard,
                size: 64,
                color: const Color(0xFFF76301),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Rewards Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start using ValarPay services to earn rewards and cashbacks!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(
    BuildContext context,
    RewardItem reward,
    bool isDark,
  ) {
    return Row(
      children: [
        // Icon Container
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.grey.shade800
                    : Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 36,
              height: 34,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 36,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF76301),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Title and Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reward.title,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: 0.035,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                reward.date,
                style: TextStyle(
                  color:
                      isDark ? Colors.grey.shade400 : const Color(0xFF9CA3AF),
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
        // Amount
        Text(
          reward.amount,
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.035,
            color: isDark ? Colors.green.shade400 : Colors.green.shade700,
          ),
        ),
      ],
    );
  }
}
