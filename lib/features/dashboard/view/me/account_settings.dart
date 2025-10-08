import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valarpay/core/widgets/custom_toast.dart';
import '../../widgets/me_widgets/delete_confirmation_dialog.dart';

// State providers
final accountNameProvider = StateProvider<String>((ref) => 'John Smith Emmy');
final accountNumberProvider = StateProvider<String>((ref) => '0000000000');
final dailyLimitProvider = StateProvider<String>((ref) => '₦200,000');
final maxBalanceProvider = StateProvider<String>((ref) => '₦500,000');

// Linked accounts model
class LinkedAccount {
  final String name;
  final String number;
  final String iconPath;
  final bool isAccount;

  LinkedAccount({
    required this.name,
    required this.number,
    required this.iconPath,
    this.isAccount = false,
  });
}

final linkedAccountsProvider = StateProvider<List<LinkedAccount>>((ref) => [
      LinkedAccount(
        name: 'Valarpay Bank',
        number: '0000000000',
        iconPath: 'assets/images/valarpay.png',
      ),
      LinkedAccount(
        name: 'First Bank of Nigeria',
        number: '00000000',
        iconPath: 'assets/images/firstbank.png',
        isAccount: true,
      ),
      LinkedAccount(
        name: 'Wema Bank',
        number: '00000000',
        iconPath: 'assets/images/wema.png',
        isAccount: true,
      ),
    ]);

class AccountSettingsPage extends ConsumerWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkedAccounts = ref.watch(linkedAccountsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Color(0xFF111827),
            fontFamily: 'SF Pro',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tier Card
              Container(
                width: 335,
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tier 1',
                      style: TextStyle(
                        color: Color(0xFFF76301),
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                        letterSpacing: 0.06,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      ref,
                      'Account Name',
                      ref.watch(accountNameProvider),
                      showCopy: true,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      ref,
                      'Account Number',
                      ref.watch(accountNumberProvider),
                      showCopy: true,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      ref,
                      'Daily Transaction Limit',
                      ref.watch(dailyLimitProvider),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      ref,
                      'Maximum Balance',
                      ref.watch(maxBalanceProvider),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF76301),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Linked Card/Account Section
              const Text(
                'Linked Card/Account',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontFamily: 'SF Pro',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Single Card containing all linked accounts
              Container(
                width: 335,
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // All linked accounts in same card
                    ...linkedAccounts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final account = entry.value;
                      final isLast = index == linkedAccounts.length - 1;
                      return Column(
                        children: [
                          _buildLinkedAccountRow(
                            context,
                            ref,
                            account,
                            index,
                          ),
                          if (!isLast)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Container(
                                height: 2,
                                color: const Color(0xFFF1F4FB),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    WidgetRef ref,
    String label,
    String value, {
    bool showCopy = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontFamily: 'SF Pro',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontFamily: 'SF Pro',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: 0.035,
              ),
            ),
            if (showCopy) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  CustomToast.showAppToast(context:context, message:  'Copied to clipboard');
                },
                child: const Icon(
                  Icons.copy,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildLinkedAccountRow(
    BuildContext context,
    WidgetRef ref,
    LinkedAccount account,
    int index,
  ) {
    return Row(
      children: [
        // Bank Icon
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            account.iconPath,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Bank Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                  letterSpacing: 0.06,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    account.number,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontFamily: 'SF Pro',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.06,
                    ),
                  ),
                  if (account.isAccount) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF216EB2).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Account',
                        style: TextStyle(
                          color: Color(0xFF216EB2),
                          fontFamily: 'SF Pro',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        // Delete Button
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return DeleteConfirmationDialog(
                  onConfirm: () {
                    final accounts = ref.read(linkedAccountsProvider);
                    ref.read(linkedAccountsProvider.notifier).state = [
                      ...accounts.sublist(0, index),
                      ...accounts.sublist(index + 1),
                    ];
                  },
                );
              },
            );
          },
          child: SvgPicture.asset(
            'assets/icons/Delete.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF9CA3AF),
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}
