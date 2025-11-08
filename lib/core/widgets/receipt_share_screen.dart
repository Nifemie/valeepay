import 'package:flutter/material.dart';

import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';

class ReceiptShareScreen extends StatefulWidget {
  final List<ShareableTransactionReceiptDetail> transactionDetailList;
  final String date;
  const ReceiptShareScreen({
    required this.transactionDetailList,
    required this.date,
    super.key,
  });

  @override
  State<ReceiptShareScreen> createState() => _ReceiptShareScreenState();
}

class _ReceiptShareScreenState extends State<ReceiptShareScreen> {
  void _copyReceiptToClipboard() {
    // Show a message that receipt details are displayed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Receipt details displayed. Share functionality coming soon.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction Receipt",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: ShareableTransactionReceipt(
              date: widget.date,
              transactionDetailList: widget.transactionDetailList,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _copyReceiptToClipboard,
        label: const Text("Share Receipt"),
        icon: const Icon(Icons.share),
      ),
    );
  }
}
