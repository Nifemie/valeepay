import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({super.key});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  int selectedBank = 0;
  bool saveBeneficiary = false;

  final banks = [
    {
      "name": "logo Bank",
      "account": "0000000000",
      "logo": "assets/images/logo.png",
    },
    {
      "name": "First Bank of Nigeria",
      "account": "0000000000",
      "logo": "assets/images/logo.png",
    },
    {
      "name": "Wema Bank",
      "account": "0000000000",
      "logo": "assets/images/logo.png",
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Details
              const Text(
                "Transaction Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _DetailRow(label: "Name", value: "JOHN SMITH EMMY"),
                    SizedBox(height: 8),
                    _DetailRow(label: "Account No", value: "00000000000"),
                    SizedBox(height: 8),
                    _DetailRow(label: "Bank", value: "Valarpay"),
                    SizedBox(height: 8),
                    _DetailRow(label: "Amount", value: "₦100,500"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Pay Via
              const Text(
                "Pay Via",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(banks.length, (index) {
                final bank = banks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(bank["logo"]!),
                        radius: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bank["name"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bank["account"]!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<int>(
                        value: index,
                        groupValue: selectedBank,
                        activeColor: appTheme.primaryColor,
                        onChanged: (val) {
                          setState(() => selectedBank = val!);
                        },
                      ),
                    ],
                  ),
                );
              }),

              const Spacer(),

              // Save Beneficiary Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Save Beneficiary",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Switch(
                    value: saveBeneficiary,
                    activeColor: appTheme.primaryColor,
                    onChanged: (val) => setState(() => saveBeneficiary = val),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    context.push('/transfer-success');
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
