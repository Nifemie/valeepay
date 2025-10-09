import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String amount;
  final String transactionId;
  final Map<String, String> transactionDetails;

  const TransactionSuccessScreen({
    super.key,
    required this.amount,
    required this.transactionId,
    required this.transactionDetails,
  });

  @override
  Widget build(BuildContext context) {
    return TransactionReceiptWidget(
      amount: amount,
      topDetails: transactionDetails.entries
          .map((entry) => TransactionDetail(label: entry.key, value: entry.value))
          .toList(),
      bottomDetails: [
        TransactionDetail(label: 'Transaction ID', value: transactionId, showCopyIcon: true),
      ],
      onShareReceipt: () {
        // Handle share receipt
      },
      onDone: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}
