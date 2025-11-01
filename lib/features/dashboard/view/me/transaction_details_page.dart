import 'package:flutter/material.dart';
import 'package:valarpay/features/models/transaction_model.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';

class TransactionDetailsPage extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailsPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTransfer = transaction.category.toUpperCase() == 'TRANSFER';
    final isBill = transaction.category.toUpperCase().contains('BILL');
    final isDeposit = transaction.category.toUpperCase() == 'DEPOSIT';

    List<Widget> topDetails = [];
    List<Widget> bottomDetails = [];
    String topTitle = '';
    String? bottomTitle;
    bool hasBottom = false;

    if (isTransfer && transaction.transferDetails != null) {
      topTitle = 'Transfer';
      topDetails = [
        buildDetailRow(
          'Amount',
          '₦${transaction.transferDetails!.amount}',
          false,
        ),
        buildDetailRow('Fee', '₦${transaction.transferDetails!.fee}', false),
        buildDetailRow('Status', transaction.status, false),
        buildDetailRow('Date', transaction.createdAt.toString(), false),
        buildDetailRow(
          'Sender Name',
          transaction.transferDetails!.senderName ?? '',
          false,
        ),
        buildDetailRow(
          'Sender Bank',
          transaction.transferDetails!.senderBankName ?? '',
          false,
        ),
        buildDetailRow(
          'Sender Account',
          transaction.transferDetails!.senderAccountNumber ?? '',
          false,
        ),
      ];
      hasBottom = true;
      bottomTitle = 'Beneficiary';
      bottomDetails = [
        buildDetailRow(
          'Bank',
          transaction.transferDetails!.beneficiaryBankName ?? '',
          false,
        ),
        buildDetailRow(
          'Account',
          transaction.transferDetails!.beneficiaryAccountNumber ?? '',
          false,
        ),
      ];
    } else if (isBill && transaction.billDetails != null) {
      topTitle = 'Bill Payment';
      topDetails = [
        buildDetailRow('Amount', '₦${transaction.billDetails!.amount}', false),
        buildDetailRow(
          'Provider',
          transaction.billDetails!.provider ?? '',
          false,
        ),
        buildDetailRow('Type', transaction.billDetails!.billType ?? '', false),
        buildDetailRow('Status', transaction.status, false),
        buildDetailRow('Date', transaction.createdAt.toString(), false),
      ];
      hasBottom = false;
    } else if (isDeposit && transaction.depositDetails != null) {
      topTitle = 'Deposit';
      topDetails = [
        buildDetailRow(
          'Amount',
          '₦${transaction.depositDetails!.amount}',
          false,
        ),
        buildDetailRow(
          'Sender',
          transaction.depositDetails!.senderName ?? '',
          false,
        ),
        buildDetailRow('Status', transaction.status, false),
        buildDetailRow('Date', transaction.createdAt.toString(), false),
      ];
      hasBottom = false;
    } else {
      topTitle = transaction.category;
      topDetails = [
        buildDetailRow('Amount', '₦${transaction.amount}', false),
        buildDetailRow('Status', transaction.status, false),
        buildDetailRow('Date', transaction.createdAt.toString(), false),
      ];
      hasBottom = false;
    }

    return ReuseableTransactionDetailsScreen(
      saveBeneficiary: false,
      onSaveBeneficiaryChanged: (value) {},
      topTransactionsDetailsList: topDetails,
      topTitleText: topTitle,
      hasBottom: hasBottom,
      bottomTitleText: bottomTitle,
      bottomTransactionsDetailsList: hasBottom ? bottomDetails : null,
      onButtonPressed: null,
      showActions: false,
    );
  }
}
