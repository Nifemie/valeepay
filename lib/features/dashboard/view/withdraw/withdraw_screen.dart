import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final List<Map<String, dynamic>> withdrawOptions = [
    {
      "id": 1,
      "icon": Icons.account_balance,
      "title": "Withdraw via Bank Branch",
      "subtitle": "Withdraw cash easily from any bank branch",
    },
    {
      "id": 2,
      "icon": Icons.credit_card,
      "title": "Withdraw via ValarPay ATM",
      "subtitle": "Get instant cash anytime using your ValarPay card",
    },
    {
      "id": 3,
      "icon": Icons.store,
      "title": "Withdraw via Merchant",
      "subtitle": "Withdraw at authorized ValarPay merchants",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.darkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Withdraw",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              withdrawOptions.map((option) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: appTheme.primaryColor,
                      child: Icon(
                        option["icon"],
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      option["title"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      option["subtitle"],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.black45,
                    ),
                    onTap: () {
                      if (option['id'] == 1) {
                        context.push('/withdraw-via-bank');
                      } else if (option['id'] == 2) {
                      } else if (option['id'] == 3) {
                        context.push('/withdraw-via-marchant');
                      }
                      // Handle navigation for each withdraw option
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
