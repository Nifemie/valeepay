import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/models/transfer_models.dart';
import 'package:valarpay/features/notifiers/transfer_notifier.dart';

class SelectBankScreen extends ConsumerStatefulWidget {
  const SelectBankScreen({super.key});

  @override
  ConsumerState<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends ConsumerState<SelectBankScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Bank> filteredBanks = [];
  List<Bank> allBanks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(banksNotifierProvider.notifier).fetchBanks(currency: 'NGN');
    });
    searchController.addListener(_filterBanks);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterBanks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredBanks = allBanks
          .where((bank) => bank.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final banksState = ref.watch(banksNotifierProvider);

    ref.listen(banksNotifierProvider, (previous, next) {
      if (next.isDataAvailable && next.data != null) {
        setState(() {
          allBanks = next.data!;
          filteredBanks = allBanks;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Bank",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                hintText: "Search for bank",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Banks List
            Expanded(
              child: banksState.isInitialLoading
                  ? const Center(child: CircularProgressIndicator())
                  : banksState.message != null && !banksState.isDataAvailable
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                banksState.message!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(banksNotifierProvider.notifier)
                                      .fetchBanks(currency: 'NGN');
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : filteredBanks.isEmpty
                          ? const Center(
                              child: Text(
                                'No banks found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredBanks.length,
                              itemBuilder: (context, index) {
                                final bank = filteredBanks[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: appTheme.primaryColor
                                          .withValues(alpha: 0.1),
                                      child: Text(
                                        bank.name.substring(0, 1).toUpperCase(),
                                        style: TextStyle(
                                          color: appTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      bank.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      bank.bankCode,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context, bank);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    tileColor: Theme.of(context)
                                        .cardColor
                                        .withValues(alpha: 0.5),
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
