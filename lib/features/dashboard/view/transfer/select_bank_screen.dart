import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({super.key});

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> matchedBanks = [
    {"name": "Tangerine Money MFB", "logo": "assets/images/bank.png"},
    {"name": "9ja Service Bank", "logo": "assets/images/bank.png"},
    {"name": "Abbey Mortgage Bank", "logo": "assets/images/bank.png"},
    {"name": "Access Bank", "logo": "assets/images/bank.png"},
    {"name": "Aku Microfinance Bank", "logo": "assets/images/bank.png"},
    {"name": "Alat", "logo": "assets/images/bank.png"},
  ];

  final List<Map<String, String>> frequentBanks = [
    {"name": "Tangerine Money MFB", "logo": "assets/images/bank.png"},
    {"name": "9ja Service Bank", "logo": "assets/images/bank.png"},
    {"name": "Abbey Mortgage Bank", "logo": "assets/images/bank.png"},
    {"name": "Access Bank", "logo": "assets/images/bank.png"},
    {"name": "Aku Microfinance Bank", "logo": "assets/images/bank.png"},
    {"name": "Alat", "logo": "assets/images/bank.png"},
  ];

  final List<Map<String, String>> otherBanks = [
    {"name": "ABU MFB", "logo": "assets/images/bank.png"},
    {"name": "ADA MFB", "logo": "assets/images/bank.png"},
    {"name": "ASO Saving", "logo": "assets/images/bank.png"},
    {"name": "Baobab Microfinance Bank", "logo": "assets/images/bank.png"},
    {"name": "Bellbank Microfinance Bank", "logo": "assets/images/bank.png"},
    {"name": "Bowen Microfinance Bank", "logo": "assets/images/bank.png"},
    {"name": "Branch", "logo": "assets/images/bank.png"},
    {"name": "Fidelity Bank", "logo": "assets/images/bank.png"},
    {"name": "Globus Bank", "logo": "assets/images/bank.png"},
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
          "Select Bank",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            TextField(
              controller: searchController,
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

            const SizedBox(height: 20),

            // Matched Banks
            const Text(
              "Matched Banks",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _BankGrid(banks: matchedBanks),

            const SizedBox(height: 20),

            // Frequently Used Banks
            const Text(
              "Frequently Used Banks",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _BankGrid(banks: frequentBanks),

            const SizedBox(height: 20),

            // Other Banks
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => context.push('/transfer-amount'),
                child: Column(
                  children: List.generate(otherBanks.length, (index) {
                    final bank = otherBanks[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage(bank["logo"]!),
                      ),
                      title: Text(
                        bank["name"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        // handle bank selection
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Bank Grid
class _BankGrid extends StatelessWidget {
  final List<Map<String, String>> banks;

  const _BankGrid({required this.banks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0, // more balanced height for wrapping
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          return InkWell(
            onTap: () {
              context.push('/transfer-amount');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(bank["logo"]!),
                  radius: 18,
                ),
                const SizedBox(height: 6),
                Text(
                  bank["name"]!,
                  textAlign: TextAlign.center,
                  maxLines: 2, // allow up to 2 lines
                  overflow: TextOverflow.ellipsis, // prevent overflow
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.2, // tighter line spacing
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
