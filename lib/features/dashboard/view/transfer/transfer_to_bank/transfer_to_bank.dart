import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/models/transfer_models.dart';
import 'package:valarpay/features/notifiers/transfer_notifier.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_to_bank/select_bank_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_to_bank/transfer_amount_screen.dart';

class TransferToBankScreen extends ConsumerStatefulWidget {
  const TransferToBankScreen({super.key});

  @override
  ConsumerState<TransferToBankScreen> createState() =>
      _TransferToBankScreenState();
}

class _TransferToBankScreenState extends ConsumerState<TransferToBankScreen> {
  final TextEditingController accountController = TextEditingController();
  Bank? selectedBank;
  AccountDetails? verifiedAccount;
  bool isRecentTab = true;
  bool isVerifying = false;

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
  void initState() {
    super.initState();
    accountController.addListener(_onAccountNumberChanged);
  }

  @override
  void dispose() {
    accountController.dispose();
    super.dispose();
  }

  void _onAccountNumberChanged() {
    if (accountController.text.length == 10 && selectedBank != null) {
      _verifyAccount();
    } else {
      setState(() {
        verifiedAccount = null;
      });
    }
  }

  void _verifyAccount() async {
    if (selectedBank == null || accountController.text.length != 10) return;

    setState(() {
      isVerifying = true;
      verifiedAccount = null;
    });

    try {
      await ref
          .read(accountVerificationNotifierProvider.notifier)
          .verifyAccount(
            accountNumber: accountController.text,
            bankCode: selectedBank!.bankCode,
          );
    } catch (e) {
      // Error handling is done in the listener
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  void _selectBank() async {
    final result = await Navigator.push<Bank>(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectBankScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        selectedBank = result;
        verifiedAccount = null;
      });
      if (accountController.text.length == 10) {
        _verifyAccount();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountVerificationState =
        ref.watch(accountVerificationNotifierProvider);

    // Listen to account verification state
    ref.listen(accountVerificationNotifierProvider, (previous, next) {
      if (next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
        setState(() {
          verifiedAccount = next.data!.first;
        });
      } else if (next.message != null && !next.isDataAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transfer to Bank Account",
          style: TextStyle(
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
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: accountController,
              keyboardType: TextInputType.number,
              maxLength: 10,
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
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),

            GestureDetector(
                onTap: _selectBank,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: selectedBank != null
                            ? appTheme.primaryColor.withValues(alpha: 0.1)
                            : Colors.black,
                        child: selectedBank != null
                            ? Text(
                                selectedBank!.name
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: appTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              )
                            : const Icon(Icons.account_balance,
                                color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selectedBank?.name ?? "Select Bank",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedBank != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.black54),
                    ],
                  ),
                )),

            const SizedBox(height: 20),

            // Account Verification Status
            if (isVerifying)
              Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(appTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Verifying account...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              )
            else if (verifiedAccount != null)
              Row(
                children: [
                  Icon(Icons.check_circle, color: appTheme.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      verifiedAccount!.accountName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              )
            else if (accountController.text.length == 10 &&
                selectedBank != null)
              Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  const Text(
                    "Account verification failed",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
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
                  backgroundColor:
                      verifiedAccount != null && selectedBank != null
                          ? appTheme.primaryColor
                          : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: verifiedAccount != null && selectedBank != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransferAmountScreen(
                              selectedBank: selectedBank!,
                              accountDetails: verifiedAccount!,
                            ),
                          ),
                        );
                      }
                    : null,
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
        ),
      ),
    );
  }
}
