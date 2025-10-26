import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
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
      await ref
          .read(transferFeeNotifierProvider.notifier)
          .getTransferFee(currency: 'NGN', amount: amount);
    } catch (e) {
      // Error handling is done in the listener
    } finally {
      setState(() {
        isLoadingFee = false;
      });
    }
  }

  void _initiateTransfer(String pin, double amount) async {
    print(
      '🚀 _initiateTransfer called with amount: $amount, pin length: ${pin.length}',
    );
    Navigator.pop(context); // Close pin modal

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      print('🔐 Initiating transfer with PIN...');
      print(
        '📤 Transfer details - Bank: ${widget.accountDetails.bankCode}, Account: ${widget.accountDetails.accountNumber}, Amount: $amount',
      );

      // Proceed with transfer (backend will validate PIN)
      // Use bankCode from accountDetails (returned from account verification) not from selectedBank
      await ref.read(transferNotifierProvider.notifier).initiateTransfer(
          bankCode: widget.accountDetails.bankCode,
          accountNumber: widget.accountDetails.accountNumber,
          amount: amount,
          currency: 'NGN',
          description: descriptionController.text.trim(),
          pin: pin,
          saveBeneficiary: true,
          sessionId: widget.accountDetails.sessionId);

      Navigator.pop(context); // Close loading

      print('✅ Transfer completed successfully');
    } catch (e) {
      Navigator.pop(context); // Close loading
      print('❌ Transfer error: $e');
      AppMessenger.show(
        context,
        message: 'Transfer failed: ${e.toString()}',
        type: MessageType.error,
      );
    }
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

  @override
  Widget build(BuildContext context) {
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
      print(
        '🎧 Transfer listener triggered - isDataAvailable: ${next.isDataAvailable}, data: ${next.data}, message: ${next.message}',
      );

      if (next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
        print('✅ Transfer successful, navigating to receipt');
        // Transfer successful - navigate to receipt
        final transferAmount =
            double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionReceiptWidget(
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
                TransactionDetail(
                  label: 'Bank',
                  value: widget.selectedBank.name,
                ),
                TransactionDetail(
                  label: 'Amount',
                  value: currencyFormatter(transferAmount.toString()),
                ),
                if (transferFee != null)
                  TransactionDetail(
                    label: 'Transfer Fee',
                    value: currencyFormatter(transferFee!.fee.toString()),
                  ),
                if (transferFee != null)
                  TransactionDetail(
                    label: 'Total',
                    value: currencyFormatter(
                      (transferAmount + transferFee!.fee).toString(),
                    ),
                  ),
                TransactionDetail(
                  label: 'Description',
                  value: descriptionController.text.trim().isEmpty
                      ? 'No description'
                      : descriptionController.text.trim(),
                ),
              ],
              onShareReceipt: () {},
            ),
          ),
        );
      } else if (next.message != null && !next.isDataAvailable) {
        AppMessenger.show(
          context,
          message: next.message!,
          type: MessageType.error,
        );
      }
    });

    final amount =
        double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;
    final totalAmount = amount + (transferFee?.fee ?? 0);

    _handleOnPressed() {
      final user = ref.watch(userProvider);
      final wallet =
          user?.wallets.isNotEmpty == true ? user!.wallets.first : null;
      final balance = wallet?.balance ?? 0.0;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final hasEnoughBalance =
          _checkBalanceLeft(balance.toString(), totalAmount.toString());

      if (!hasEnoughBalance) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReuseableTransactionDetailsScreen(
            hasBottom: false,
            topTitleText: 'Transaction',
            topTransactionsDetailsList: [
              buildDetailRow(
                'Account Name',
                widget.accountDetails.accountName,
                isDark,
              ),
              buildDetailRow('Bank', widget.selectedBank.name, isDark),
              buildDetailRow(
                'Account Number',
                widget.accountDetails.accountNumber,
                isDark,
              ),
              buildDetailRow(
                'Amount',
                currencyFormatter(amountController.text),
                isDark,
              ),
              buildDetailRow(
                'Fee',
                currencyFormatter(transferFee?.fee.toString() ?? ''),
                isDark,
              ),
              buildDetailRow(
                'Total Amount',
                currencyFormatter('$totalAmount'),
                isDark,
                isTotal: true,
              ),
            ],
            onButtonPressed: () async {
              print('🔘 Transfer button pressed, amount: $amount');
              final pin = await TransactionPinModal.show(context);
              print(
                '🔐 PIN received: ${pin != null ? "****" : "null"}, length: ${pin?.length}',
              );
              if (pin != null && pin.length == 4 && mounted) {
                print('✅ PIN valid, calling _initiateTransfer');
                _initiateTransfer(pin, amount);
              } else {
                print('❌ PIN invalid or cancelled');
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: appTheme.primaryColor.withValues(
                          alpha: 0.1,
                        ),
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
              Text(
                'Minimum transfer amount is ₦50',
                style: TextStyle(color: Colors.red, fontSize: 13),
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
            FullWidthButton(
                text: 'Transfer',
                isEnabled: amount > 0 && transferFee != null,
                isLoading: transferState.isInitialLoading,
                onPressed: _handleOnPressed)
          ],
        ),
      ),
    );
  }
}
