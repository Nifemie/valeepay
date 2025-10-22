import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';

class TransferToBankRecentAndSavedBeneficiaries extends StatefulWidget {
  const TransferToBankRecentAndSavedBeneficiaries({super.key});

  @override
  State<TransferToBankRecentAndSavedBeneficiaries> createState() => _TransferToBankRecentAndSavedBeneficiariesState();
}

class _TransferToBankRecentAndSavedBeneficiariesState extends State<TransferToBankRecentAndSavedBeneficiaries> {
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
    return Column(
      children: [
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
                          color: isRecentTab ? appTheme.primaryColor : null,
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
                          color: !isRecentTab ? appTheme.primaryColor : null,
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
                hintText: "Search",
                filled: true,
                fillColor: Theme.of(context).cardColor.withValues(alpha: 0.5),
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
                      color: Theme.of(context).cardColor.withOpacity(0.5),
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
    );
  }
}