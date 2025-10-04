import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class WithdrawMerchantScreen extends StatefulWidget {
  const WithdrawMerchantScreen({super.key});

  @override
  State<WithdrawMerchantScreen> createState() => _WithdrawMerchantScreenState();
}

class _WithdrawMerchantScreenState extends State<WithdrawMerchantScreen> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isRecentTab = true;
  String selectedBeneficiary = "Emmy John Smith";

  final List<Map<String, String>> recentBeneficiaries = [
    {
      "name": "John Smith",
      "bank": "ValarPay",
      "logo": "assets/images/user.png",
    },
    {
      "name": "John Smith",
      "bank": "ValarPay",
      "logo": "assets/images/user.png",
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
          "Withdraw via Merchant",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient Account Number
            const Text(
              "Recipient Account Number",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: accountController,
              decoration: InputDecoration(
                hintText: "Enter account name/number",
                suffixIcon: Icon(Icons.copy, color: Colors.black45, size: 20),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Amount
            const Text(
              "Amount",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "₦ ",
                prefixStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Selected Beneficiary
            Row(
              children: [
                Icon(Icons.check_circle, color: appTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  selectedBeneficiary,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appTheme.primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Continue Button
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
                  // Handle continue
                  context.push("/transaction-details");
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tabs (Recent & Saved)
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => isRecentTab = true),
                  child: Column(
                    children: [
                      Text(
                        "Recent",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              isRecentTab
                                  ? appTheme.primaryColor
                                  : Colors.black54,
                        ),
                      ),
                      if (isRecentTab)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 3,
                          width: 40,
                          color: appTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => setState(() => isRecentTab = false),
                  child: Column(
                    children: [
                      Text(
                        "Saved Beneficiary",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              !isRecentTab
                                  ? appTheme.primaryColor
                                  : Colors.black54,
                        ),
                      ),
                      if (!isRecentTab)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 3,
                          width: 40,
                          color: appTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Search Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                hintText: "Searching",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Beneficiaries List
            Expanded(
              child: ListView.builder(
                itemCount: recentBeneficiaries.length,
                itemBuilder: (context, index) {
                  final b = recentBeneficiaries[index];
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
                          backgroundImage: AssetImage(b["logo"]!),
                          radius: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b["name"]!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${b["bank"]}   ValarPay",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.bookmark_add_outlined,
                            size: 20,
                            color: Colors.black45,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
