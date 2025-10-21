import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/features/models/transfer_models.dart';
import 'package:valarpay/features/notifiers/transfer_notifier.dart';

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
  final TextEditingController descriptionController = TextEditingController();
  TransferFee? transferFee;
  bool isLoadingFee = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(_onAmountChanged);
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
                            const SizedBox(height: 2),
                            Text(
                              "${widget.accountDetails.accountNumber} • ${widget.selectedBank.name}",
                              style: const TextStyle(
                                fontSize: 12,
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
              prefixText: 'N',
              amountController: amountController,
              hintText: "Enter amount",
            ),

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
                fillColor: Colors.grey.shade100,
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
              )
            else if (transferFee != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Amount"),
                        Text(currencyFormatter(amount.toString())),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Transfer Fee"),
                        Text(currencyFormatter(transferFee!.fee.toString())),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          currencyFormatter(totalAmount.toString()),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const Spacer(),

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
                onPressed: transferState.isInitialLoading
                    ? null
                    : amount > 0 && transferFee != null
                        ? _showTransactionPinModal
                        : null,
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
          ],
        ),
      ),
    );
  }
}
