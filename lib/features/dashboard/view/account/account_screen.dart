import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool showNairaBalance = false;
  bool showDollarBalance = false;

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
          "Account",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Naira Account Card
            _accountCard(
              currency: "₦",
              isVisible: showNairaBalance,
              onToggle:
                  () => setState(() => showNairaBalance = !showNairaBalance),
            ),
            const SizedBox(height: 16),

            // Dollar Account Card
            _accountCard(
              currency: "\$",
              isVisible: showDollarBalance,
              onToggle:
                  () => setState(() => showDollarBalance = !showDollarBalance),
            ),
            const SizedBox(height: 20),

            // Get Euro Account
            _accountSetupCard(
              flag: "assets/images/euflag.png",
              title: "Get Euro Account",
              subtitle: "Open a secure euro account",
              onTap: () {
                context.push('/account-setup');
              },
            ),
            const SizedBox(height: 12),

            // Get Pound Account
            _accountSetupCard(
              flag: "assets/images/usflag.png",
              title: "Get Pound Account",
              subtitle: "Open a secure pounds account",
              onTap: () {
                // handle setup
                context.push('/account-setup');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Account Card
  Widget _accountCard({
    required String currency,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Your Balance",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black45,
                      size: 20,
                    ),
                    onPressed: onToggle,
                  ),
                ],
              ),
              Text(
                "Tier 1",
                style: TextStyle(
                  color: appTheme.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isVisible ? "$currency 150,000.00" : "$currency ***********",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Bank Name
          _infoRow("Bank Name", "ValarPay"),
          const SizedBox(height: 12),

          // Account Name
          _infoRow("Account Name", "John Smith Emmy"),
          const SizedBox(height: 12),

          // Account Number
          _infoRow("Account Number", "0000000000"),
        ],
      ),
    );
  }

  // Info Row with copy icon
  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18, color: Colors.black45),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$label copied to clipboard")),
            );
          },
        ),
      ],
    );
  }

  // Account setup card (Euro / Pound)
  Widget _accountSetupCard({
    required String flag,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(radius: 18, backgroundImage: AssetImage(flag)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing: TextButton(
          onPressed: onTap,
          child: const Text(
            "Setup",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
