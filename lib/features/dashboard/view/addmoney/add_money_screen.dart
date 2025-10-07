import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final List<Map<String, dynamic>> addMoneyOptions = [
    {
      "id": 1,
      "icon": Icons.account_balance,
      "title": "Via Bank Transfer",
      "subtitle":
          "Send money directly to your ValarPay account via bank transfer",
    },
    {
      "id": 2,
      "icon": Icons.store,
      "title": "Cash Deposit (Agent)",
      "subtitle":
          "Deposit cash safely at any authorized ValarPay agent near you",
    },
    {
      "id": 3,
      "icon": Icons.credit_card,
      "title": "Top Up with Card/Account",
      "subtitle":
          "Instantly fund your wallet using your debit card or linked bank account",
    },
    {
      "id": 4,
      "icon": Icons.qr_code,
      "title": "Scan My Code",
      "subtitle":
          "Add money instantly by scanning your unique ValarPay QR code",
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
          "Add Money",
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
              addMoneyOptions.map((option) {
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
                      // handle navigation to each option screen
                      if (option["id"] == 1 || option["id"] == 2) {
                        context.push("/add-money-via-transfer");
                      } else if (option["id"] == 4) {
                        context.push("/add-money-via-qrcode");
                      } else {
                        context.push("/coming-soon");
                      }
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
