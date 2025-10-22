import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/models/transfer_models.dart';
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

  _shareTransactionReceipt() {
    final user = ref.read(userProvider);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReceiptShareScreen(
                  date:
                      '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                  transactionDetailList: [
                    ShareableTransactionReceiptDetail(
                        label: 'Amount',
                        value: currencyFormatter(amountController.text)),
                    ShareableTransactionReceiptDetail(
                        label: 'Currency', value: 'NGN'),
                    ShareableTransactionReceiptDetail(
                        label: 'Transaction Type',
                        value: 'Intra-bank Transfer'),
                    ShareableTransactionReceiptDetail(
                        label: 'Sender Name', value: user?.fullname ?? ''),
                    ShareableTransactionReceiptDetail(
                        label: 'Beneficiary Details',
                        value:
                            '${widget.accountDetails.accountName} \n${widget.accountDetails.accountNumber}'),
                    ShareableTransactionReceiptDetail(
                        label: 'Beneficiary Bank', value: 'ValarPay'),
                    if (narrationController.text.isNotEmpty)
                      ShareableTransactionReceiptDetail(
                          label: 'Narration', value: narrationController.text),
                    ShareableTransactionReceiptDetail(
                        label: 'Transaction ID',
                        value: widget.accountDetails.sessionId),
                    ShareableTransactionReceiptDetail(
                        label: 'Status',
                        value: 'Successful',
                        isSuccessful: true)
                  ],
                )));
  }

  _showTransactionReceipt() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionReceiptWidget(
          amount: amountController.text,
          topDetails: [
            TransactionDetail(
                label: 'Transaction ID',
                value: widget.accountDetails.sessionId,
                showCopyIcon: true),
            TransactionDetail(
              label: 'Beneficiary Details',
              value:
                  '${widget.accountDetails.accountName} | \n${widget.accountDetails.accountNumber} | ValarPay',
            ),
            TransactionDetail(
              label: 'Payment Source',
              value: 'ValarPay Account',
            ),
            TransactionDetail(
              label: 'Date & Time',
              value:
                  '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
            ),
          ],
          onShareReceipt: () {
            _shareTransactionReceipt();
          },
        ),
      ),
    );
  }

  _handleOnPressed() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReuseableTransactionDetailsScreen(
          hasBottom: false,
          topTitleText: 'Transaction',
          topTransactionsDetailsList: [
            buildDetailRow('Name', widget.accountDetails.accountName, isDark),
            buildDetailRow(
                'Account Number', widget.accountDetails.accountNumber, isDark),
            buildDetailRow('Bank', 'ValarPay', isDark),
            buildDetailRow(
                'Amount', currencyFormatter(amountController.text), isDark),
          ],
          onButtonPressed: () async {
            final pin = await TransactionPinModal.show(context);
            if (pin != null && pin.length == 4 && mounted) {
              _showTransactionReceipt();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Transfer to ValarPay Account',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
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
                    backgroundImage:
                        AssetImage('assets/images/account_image.jpg'),
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
                        '0000000000   ValarPay',
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
                  hintText: 'Enter Amount'),
              if (isNotMinimumAmount) SizedBox(height: 5),
              if (isNotMinimumAmount)
                Text('Minimum transfer amount is ₦50',
                    style: TextStyle(color: Colors.red, fontSize: 13)),

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
                  isEnabled: amountController.text.isNotEmpty &&
                      int.parse(amountController.text.replaceAll(',', '')) >=
                          50,
                  onPressed: () {
                    _handleOnPressed();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
