import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/models/transfer_models.dart';
import 'package:valarpay/features/notifiers/transfer_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class InternalTransferAmountScreen extends ConsumerStatefulWidget {
  final AccountDetails accountDetails;
  InternalTransferAmountScreen({required this.accountDetails, super.key});

  @override
  ConsumerState<InternalTransferAmountScreen> createState() =>
      _InternalTransferAmountScreenState();
}

class _InternalTransferAmountScreenState
    extends ConsumerState<InternalTransferAmountScreen> {
  final NumberFormat formatter = NumberFormat('#,###');

  TextEditingController amountController = TextEditingController();
  TextEditingController narrationController = TextEditingController();
  bool isNotMinimumAmount = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountController.addListener(() {
      final text = amountController.text.replaceAll(',', '');
      if (text.isEmpty) return;

      // Prevent recursive updates
      final newText = formatter.format(int.parse(text));
      if (newText != amountController.text) {
        final cursorPos = newText.length;
        amountController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPos),
        );
      }
      if (int.parse(text) < 50) {
        setState(() {
          isNotMinimumAmount = true;
        });
      } else {
        setState(() {
          isNotMinimumAmount = false;
        });
      }
    });
  }

bool _checkBalanceLeft(String balance, String totalAmount) {
  final doubleBalance = double.tryParse(balance.replaceAll(',', '')) ?? 0.0;
  final doubleTotal = double.tryParse(totalAmount.replaceAll(',', '')) ?? 0.0;

  if (doubleBalance < doubleTotal) {
    AppMessenger.show(
      context,
      message: 'Insufficient account balance, kindly top up and continue',
      type: MessageType.error,
    );
    return false;
  }

  return true; 
}


  void _initiateTransfer(String pin, double amount) async {
    Navigator.pop(context); // Close pin modal

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      print('🔐 Initiating ValarPay transfer with PIN...');
      print(
        '📤 Transfer details - Account: ${widget.accountDetails.accountNumber}, Amount: $amount',
      );

      // Proceed with internal transfer (backend will validate PIN)
      // For ValarPay to ValarPay, bankCode should be empty or null
      await ref
          .read(transferNotifierProvider.notifier)
          .initiateTransfer(
            bankCode: '', // Internal transfer doesn't need bank code
            accountNumber: widget.accountDetails.accountNumber,
            amount: amount,
            currency: 'NGN',
            description: narrationController.text.trim(),
            pin: pin,
            saveBeneficiary: true,
            sessionId: widget.accountDetails.sessionId,
          );

      Navigator.pop(context); // Close loading

      print('✅ ValarPay transfer completed successfully');
    } catch (e) {
      Navigator.pop(context); // Close loading
      print('❌ ValarPay transfer error: $e');
      AppMessenger.show(
        context,
        message: 'Transfer failed: ${e.toString()}',
        type: MessageType.error,
      );
    }
  }

  _handleOnPressed() {
    final user = ref.watch(userProvider);
    final wallet =
        user?.wallets.isNotEmpty == true ? user!.wallets.first : null;
    final balance = wallet?.balance ?? 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _checkBalanceLeft(
      balance.toString(),
      amountController.text.replaceAll(',', ''),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ReuseableTransactionDetailsScreen(
              hasBottom: false,
              topTitleText: 'Transaction',
              topTransactionsDetailsList: [
                buildDetailRow(
                  'Name',
                  widget.accountDetails.accountName,
                  isDark,
                ),
                buildDetailRow(
                  'Account Number',
                  widget.accountDetails.accountNumber,
                  isDark,
                ),
                buildDetailRow('Bank', 'ValarPay', isDark),
                buildDetailRow(
                  'Amount',
                  currencyFormatter(amountController.text),
                  isDark,
                ),
              ],
              onButtonPressed: () async {
                final amount =
                    double.tryParse(
                      amountController.text.replaceAll(',', ''),
                    ) ??
                    0;
                print('🔘 ValarPay transfer button pressed, amount: $amount');
                final pin = await BiometricTransactionPinModal.show(context);
                print(
                  '🔐 PIN received: ${pin != null ? "****" : "null"}, length: ${pin?.length}',
                );
                
                if (pin != null && pin.length == 4) {
                  // Ensure PIN is a string
                  final pinString = pin.toString();
                  print('🔐 PIN type check: ${pin.runtimeType}, converted: ${pinString.runtimeType}');
                  
                  if (mounted) {
                    print('✅ PIN valid, calling _initiateTransfer');
                    _initiateTransfer(pinString, amount);
                  }
                } else {
                  print('❌ PIN invalid or cancelled');
                }
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);
    
    // Get wallet data for current user's account number
    final wallet = user?.wallets.isNotEmpty == true ? user!.wallets.first : null;
    final userAccountNumber = wallet?.accountNumber ?? '0000000000';
    
    // Listen to transfer state
    ref.listen(transferNotifierProvider, (previous, next) {
      print(
        '🎧 ValarPay transfer listener triggered - isDataAvailable: ${next.isDataAvailable}, data: ${next.data}, message: ${next.message}',
      );

      if (next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
        print('✅ ValarPay transfer successful, navigating to receipt');
        
        if (!mounted) {
          print('⚠️ Widget not mounted, skipping navigation');
          return;
        }
        
        // Small delay to ensure any dialogs are closed
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) {
            print('⚠️ Widget not mounted after delay, skipping navigation');
            return;
          }
          
          print('🧾 Navigating to receipt screen');
          // Transfer successful - navigate to receipt
          final transferAmount =
              double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => TransactionReceiptWidget(
                  amount: currencyFormatter(transferAmount.toString()),
                  topDetails: [
                    TransactionDetail(
                      label: 'Transaction ID',
                      value: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                      showCopyIcon: true,
                    ),
                    TransactionDetail(
                      label: 'Recipient Name',
                      value: widget.accountDetails.accountName,
                    ),
                    TransactionDetail(
                      label: 'Recipient Account',
                      value: widget.accountDetails.accountNumber,
                    ),
                    TransactionDetail(label: 'Bank', value: 'ValarPay'),
                    TransactionDetail(
                      label: 'Amount',
                      value: currencyFormatter(transferAmount.toString()),
                    ),
                    if (narrationController.text.trim().isNotEmpty)
                      TransactionDetail(
                        label: 'Narration',
                        value: narrationController.text.trim(),
                      ),
                  ],
                  onShareReceipt: () {},
                ),
            ),
          );
        });
      } else if (next.message != null && !next.isDataAvailable) {
        AppMessenger.show(
          context,
          message: next.message!,
          type: MessageType.error,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Transfer to ValarPay Account',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: isDark 
                        ? const Color(0xFF374151) 
                        : const Color(0xFFF3F4F6),
                    child: ClipOval(
                      child: user?.profileImageUrl != null &&
                              user!.profileImageUrl!.isNotEmpty
                          ? Image.network(
                              user.profileImageUrl!,
                              width: 48.r,
                              height: 48.r,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 24.r,
                                  color: isDark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              size: 24.r,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.accountDetails.accountName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$userAccountNumber   ValarPay',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              // Amount Field
              Text(
                'Amount',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 8.h),
              ReuseableAmountTextfield(
                amountController: amountController,
                prefixText: '₦',
                hintText: 'Enter Amount',
              ),
              if (isNotMinimumAmount) SizedBox(height: 5),
              if (isNotMinimumAmount)
                Text(
                  'Minimum transfer amount is ₦50',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),

              SizedBox(height: 25.h),

              // Narration Field
              Text(
                'Narration (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  hintText: 'Enter narration',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: appTheme.primaryColor,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),

              // Continue Button
              FullWidthButton(
                text: 'Continue',
                isEnabled:
                    amountController.text.isNotEmpty &&
                    int.parse(amountController.text.replaceAll(',', '')) >= 50,
                onPressed: () {
                  _handleOnPressed();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
