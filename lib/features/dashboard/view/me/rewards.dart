import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Reward item model
class RewardItem {
  final String title;
  final String date;
  final String amount;

  RewardItem({
    required this.title,
    required this.date,
    required this.amount,
  });
}

final rewardsListProvider = StateProvider<List<RewardItem>>((ref) => [
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Betting Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Interbank Coupons',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
  RewardItem(
    title: 'Airtime Cashbacks',
    date: 'September 10,2025 10:11 PM',
    amount: '+₦70',
  ),
]);

class MyRewardsPage extends ConsumerWidget {
  const MyRewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardsListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Rewards',
          style: TextStyle(
            color: Color(0xFF111827),
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
            children: rewards.map((reward) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: _buildRewardItem(reward),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardItem(RewardItem reward) {
    return Row(
      children: [
        // Icon Container
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/valarpay.png',
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
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontFamily: 'SF Pro',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: 0.035,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                reward.date,
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
        // Amount
        Text(
          reward.amount,
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
    );
  }
}