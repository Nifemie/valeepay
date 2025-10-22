import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/models/transfer_models.dart';
import 'package:valarpay/features/notifiers/transfer_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class TransferAmountScreen extends ConsumerStatefulWidget {
  final Bank selectedBank;
  final AccountDetails accountDetails;

  const TransferAmountScreen({
    super.key,
    required this.selectedBank,
    required this.accountDetails,
  });

  @override
  ConsumerState<TransferAmountScreen> createState() =>
      _TransferAmountScreenState();
}

class _TransferAmountScreenState extends ConsumerState<TransferAmountScreen> {
  final TextEditingController amountController = TextEditingController();
  final NumberFormat formatter = NumberFormat('#,###');
  final TextEditingController descriptionController = TextEditingController();
  TransferFee? transferFee;
  bool isLoadingFee = false;
  bool isNotMinimumAmount = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      _onAmountChanged();
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

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    final amount = double.tryParse(amountController.text.replaceAll(',', ''));
    if (amount != null && amount > 0) {
      _getTransferFee(amount);
    } else {
      setState(() {
        transferFee = null;
      });
    }
  }

  void _getTransferFee(double amount) async {
    setState(() {
      isLoadingFee = true;
    });

    try {
      await ref.read(transferFeeNotifierProvider.notifier).getTransferFee(
            currency: 'NGN',
            amount: amount,
          );
    } catch (e) {
      // Error handling is done in the listener
    } finally {
      setState(() {
        isLoadingFee = false;
      });
    }
  }

  _showTransactionPinModal() {
    final amount = double.tryParse(amountController.text.replaceAll(',', ''));
    if (amount == null || amount < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    TransactionPinModal.show(context,
        onCompletePin: (pin) => _initiateTransfer(pin, amount));
  }

  void _initiateTransfer(String pin, double amount) async {
    Navigator.pop(context); // Close pin modal

    try {
      await ref.read(transferNotifierProvider.notifier).initiateTransfer(
            bankCode: widget.selectedBank.bankCode,
            accountNumber: widget.accountDetails.accountNumber,
            amount: amount,
            currency: 'NGN',
            description: descriptionController.text.trim(),
          );
    } catch (e) {
      // Error handling is done in the listener
    }
  }

  @override
  Widget build(BuildContext context) {
    final transferFeeState = ref.watch(transferFeeNotifierProvider);
    final transferState = ref.watch(transferNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen to transfer fee state
    ref.listen(transferFeeNotifierProvider, (previous, next) {
      if (next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
        setState(() {
          transferFee = next.data!.first;
        });
      }
    });

    // Listen to transfer state
    ref.listen(transferNotifierProvider, (previous, next) {
      if (next.isDataAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message ?? 'Transfer successful'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (next.message != null && !next.isDataAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final amount =
        double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;
    final totalAmount = amount + (transferFee?.fee ?? 0);

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
                          value: currencyFormatter(amount.toString())),
                      ShareableTransactionReceiptDetail(
                          label: 'Currency', value: 'NGN'),
                      ShareableTransactionReceiptDetail(
                          label: 'Transaction Type',
                          value: 'Inter-bank Transfer'),
                      ShareableTransactionReceiptDetail(
                          label: 'Sender Name', value: user?.fullname ?? ''),
                      ShareableTransactionReceiptDetail(
                          label: 'Beneficiary Details',
                          value:
                              '${widget.accountDetails.accountName} \n${widget.accountDetails.accountNumber}'),
                      ShareableTransactionReceiptDetail(
                          label: 'Beneficiary Bank',
                          value: widget.selectedBank.name),
                      if (descriptionController.text.isNotEmpty)
                        ShareableTransactionReceiptDetail(
                            label: 'Narration',
                            value: descriptionController.text),
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
            amount: totalAmount.toString(),
            topDetails: [
              TransactionDetail(
                  label: 'Amount', value: currencyFormatter(amount.toString())),
              TransactionDetail(
                  label: 'Fee',
                  value: currencyFormatter(transferFee?.fee.toString() ?? '')),
              TransactionDetail(
                  label: 'Amount',
                  value: currencyFormatter(totalAmount.toString())),
            ],
            bottomDetails: [
              TransactionDetail(
                label: 'Transaction Type',
                value: 'Inter-bank Transfer',
              ),
              TransactionDetail(
                label: 'Beneficiary Details',
                value:
                    '${widget.accountDetails.accountName} | \n${widget.accountDetails.accountNumber} | ${widget.selectedBank.name}',
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReuseableTransactionDetailsScreen(
            hasBottom: false,
            topTitleText: 'Transaction',
            topTransactionsDetailsList: [
              buildDetailRow(
                  'Account Name', widget.accountDetails.accountName, isDark),
              buildDetailRow('Bank', widget.selectedBank.name, isDark),
              buildDetailRow('Account Number',
                  widget.accountDetails.accountNumber, isDark),
              buildDetailRow(
                  'Amount', currencyFormatter(amountController.text), isDark),
              buildDetailRow('Fee',
                  currencyFormatter(transferFee?.fee.toString() ?? ''), isDark),
              buildDetailRow(
                  'Total Amount', currencyFormatter('$totalAmount'), isDark,
                  isTotal: true)
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transfer Amount",
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
            // Recipient Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recipient Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            appTheme.primaryColor.withValues(alpha: 0.1),
                        child: Text(
                          widget.selectedBank.name
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            color: appTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.accountDetails.accountName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.accountDetails.accountNumber} • ${widget.selectedBank.name}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Amount Input
            const Text(
              "Amount",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ReuseableAmountTextfield(
              prefixText: '₦',
              amountController: amountController,
              hintText: "Enter amount",
            ),
            if (isNotMinimumAmount) SizedBox(height: 5),
            if (isNotMinimumAmount)
              Text('Minimum transfer amount is ₦50',
                  style: TextStyle(color: Colors.red, fontSize: 13)),

            const SizedBox(height: 16),

            // Description Input
            const Text(
              "Description (Optional)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "What's this transfer for?",
                filled: true,
                fillColor: Theme.of(context).cardColor.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Fee Information
            if (isLoadingFee)
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text("Calculating fee..."),
                ],
              ),
            const SizedBox(height: 60),

            // Transfer Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: amount > 0 && transferFee != null
                      ? appTheme.primaryColor
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  _handleOnPressed();
                },
                child: transferState.isInitialLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Transfer",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),

            // SizedBox(
            //   width: double.infinity,
            //   height: 50,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: amount > 0 && transferFee != null
            //           ? appTheme.primaryColor
            //           : Colors.grey,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(25),
            //       ),
            //     ),
            //     onPressed: transferState.isInitialLoading
            //         ? null
            //         : amount > 0 && transferFee != null
            //             ? _showTransactionPinModal
            //             : null,
            //     child: transferState.isInitialLoading
            //         ? const SizedBox(
            //             width: 20,
            //             height: 20,
            //             child: CircularProgressIndicator(
            //               strokeWidth: 2,
            //               valueColor:
            //                   AlwaysStoppedAnimation<Color>(Colors.white),
            //             ),
            //           )
            //         : const Text(
            //             "Transfer",
            //             style: TextStyle(color: Colors.white, fontSize: 16),
            //           ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
