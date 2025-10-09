import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/app.dart';
import '../../widgets/me_widgets/modal/calendar_picker_moadal.dart';
import 'package:valarpay/core/widgets/custom_toast.dart';

// State providers
final startDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final endDateProvider = StateProvider<DateTime>(
    (ref) => DateTime.now().add(const Duration(days: 5)));
final selectedAccountProvider = StateProvider<String>((ref) => 'NGN Account');
final emailProvider = StateProvider<String>((ref) => '');

class AccountStatementPage extends ConsumerWidget {
  const AccountStatementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = ref.watch(startDateProvider);
    final endDate = ref.watch(endDateProvider);
    final selectedAccount = ref.watch(selectedAccountProvider);
    final email = ref.watch(emailProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Statement',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date
            const Text(
              'Start Date',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontFamily: 'SF Pro',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                CalendarPickerModal.show(
                  context,
                  initialDate: startDate,
                  onDateSelected: (date) {
                    ref.read(startDateProvider.notifier).state = date;
                  },
                );
              },
              child: Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(startDate),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                        letterSpacing: 0.035,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // End Date
            const Text(
              'End Date',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontFamily: 'SF Pro',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                CalendarPickerModal.show(
                  context,
                  initialDate: endDate,
                  onDateSelected: (date) {
                    ref.read(endDateProvider.notifier).state = date;
                  },
                );
              },
              child: Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(endDate),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                        letterSpacing: 0.035,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Select Account
            const Text(
              'Select Account',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontFamily: 'SF Pro',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _showAccountSelection(context, ref);
              },
              child: Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/nigerian.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedAccount,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontFamily: 'SF Pro',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Email Address
            const Text(
              'Email Address',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontFamily: 'SF Pro',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) {
                  ref.read(emailProvider.notifier).state = value;
                },
                decoration: const InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(
                    color: Color(0xFF6B7280),
                    fontFamily: 'SF Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    letterSpacing: 0.035,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: 0.035,
                ),
              ),
            ),
            const Spacer(),

            // Generate Button
            GestureDetector(
              onTap: () {
                _handleGenerate(context, ref);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF76301),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'Generate',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.43,
                      letterSpacing: 0.035,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _showAccountSelection(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Account',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontFamily: 'SF Pro',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildAccountOption(
                context,
                ref,
                'NGN Account',
                'assets/images/nigerian.png',
              ),
              const SizedBox(height: 12),
              _buildAccountOption(
                context,
                ref,
                'USD Account',
                'assets/images/USA.png',
              ),
              const SizedBox(height: 12),
              _buildAccountOption(
                context,
                ref,
                'pounds Account',
                'assets/images/POUNDS.png',
              ),
              const SizedBox(height: 12),
              _buildAccountOption(
                context,
                ref,
                'Euro Account',
                'assets/images/EURO.png',
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountOption(
    BuildContext context,
    WidgetRef ref,
    String accountName,
    String iconPath,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedAccountProvider.notifier).state = accountName;
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Text(
              accountName,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontFamily: 'SF Pro',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGenerate(BuildContext context, WidgetRef ref) {
    final startDate = ref.read(startDateProvider);
    final endDate = ref.read(endDateProvider);
    final account = ref.read(selectedAccountProvider);
    final email = ref.read(emailProvider);

    // Validate email
    if (email.isEmpty) {
      CustomToast.showErrorToast(
          context: context, message: 'Please enter an email address');

      return;
    }

    // Handle generate statement logic
    print('Generating statement:');
    print('Start Date: ${_formatDate(startDate)}');
    print('End Date: ${_formatDate(endDate)}');
    print('Account: $account');
    print('Email: $email');

    // Show success message
    CustomToast.showAppToast(
        context: context, message: 'tatement will be sent to your email');
  }
}
