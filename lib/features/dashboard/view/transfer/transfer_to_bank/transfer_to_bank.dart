import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class TransferToBankScreen extends StatefulWidget {
  const TransferToBankScreen({super.key});

  @override
  State<TransferToBankScreen> createState() => _TransferToBankScreenState();
}

class _TransferToBankScreenState extends State<TransferToBankScreen> {
  final TextEditingController accountController = TextEditingController();
  String selectedBank = "First Bank";
  String selectedBeneficiary = "Emmy John Smith";
  bool isRecentTab = true;

  final List<Map<String, String>> recentBeneficiaries = [
    {
      "name": "John Smith",
      "account": "0000000000",
      "bank": "Fidelity Bank",
      "logo": "assets/images/bank.png",
    },
    {
      "name": "John Smith",
      "account": "0000000000",
      "bank": "Keystone Bank",
      "logo": "assets/images/bank.png",
    },
    {
      "name": "John Smith",
      "account": "0000000000",
      "bank": "Parallax Bank",
      "logo": "assets/images/bank.png",
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
          "Transfer to Bank Account",
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
            // Beneficiary Account Number
            const Text(
              "Beneficiary Account Number",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: accountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Account number of beneficiary",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Select Bank
            const Text(
              "Select Bank",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: ()=> context.push('/select-bank'),
              child: 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.apple, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedBank,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.black54),
                ],
              ),
            )),

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
                onPressed: () {},
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
                                "${b["account"]}   ${b["bank"]}",
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
                            color: Colors.black54,
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
