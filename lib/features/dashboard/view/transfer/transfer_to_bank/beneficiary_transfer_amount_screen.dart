import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/models/beneficiary_models.dart';
import 'package:valarpay/features/models/transfer_models.dart';
import 'package:valarpay/features/notifiers/transfer_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class BeneficiaryTransferAmountScreen extends ConsumerStatefulWidget {
  final Beneficiary beneficiaryDetails;

  const BeneficiaryTransferAmountScreen({
    super.key,
    required this.beneficiaryDetails,
  });

  @override
  ConsumerState<BeneficiaryTransferAmountScreen> createState() =>
      _BeneficiaryTransferAmountScreenState();
}

class _BeneficiaryTransferAmountScreenState
    extends ConsumerState<BeneficiaryTransferAmountScreen> {
  final TextEditingController amountController = TextEditingController();
  final NumberFormat formatter = NumberFormat('#,###');
  final TextEditingController descriptionController = TextEditingController();
  TransferFee? transferFee;
  bool isLoadingFee = false;
  bool isLoading = false;
  bool isNotMinimumAmount = false;
  bool saveBeneficiary = false;
  AccountDetails? verifiedAccount;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(beneficiaryAccountVerificationNotifierProvider.notifier)
          .verifyAccount(
            accountNumber: widget.beneficiaryDetails.accountNumber,
            bankCode: widget.beneficiaryDetails.bankCode,
          );
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
    Navigator.pop(context); // Close pin modal

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Proceed with transfer (backend will validate PIN)
      // Use bankCode from accountDetails (returned from account verification) not from selectedBank
      await ref
          .read(transferNotifierProvider.notifier)
          .initiateTransfer(
            bankCode: widget.beneficiaryDetails.bankCode,
            accountNumber: widget.beneficiaryDetails.accountNumber,
            amount: amount,
            currency: 'NGN',
            description: descriptionController.text.trim(),
            pin: pin,
            saveBeneficiary: saveBeneficiary,
            sessionId: verifiedAccount!.sessionId,
          );

      Navigator.pop(context); // Close loading
    } catch (e) {
      Navigator.pop(context); // Close loading
      AppMessenger.show(
        context,
        message: 'Transfer failed: ${e.toString()}',
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final transferState = ref.watch(transferNotifierProvider);
    final amount =
        double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;
    final totalAmount = amount + (transferFee?.fee ?? 0);

    // Listen to transfer fee state
    ref.listen(transferFeeNotifierProvider, (previous, next) {
      if (next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
        setState(() {
          transferFee = next.data!.first;
        });
      }
    });

    ref.listen(beneficiaryAccountVerificationNotifierProvider, (
      previous,
      next,
    ) {
      if (next.isInitialLoading) {
        setState(() {
          isLoading = true;
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context); // Close loading
        if (next.isDataAvailable &&
            next.data != null &&
            !next.isInitialLoading) {
          setState(() {
            verifiedAccount = next.data!.first;
          });
        } else if (next.message != null) {
          AppMessenger.show(
            context,
            message: next.message!,
            type: MessageType.error,
          );
        }
      }
    });

    // Capture required user data now (avoid capturing `ref` inside the
    // callback which may be invoked after this widget is disposed).
    final String _userFullname = ref.read(userProvider)?.fullname ?? '';

    _onShareTransactionReceiptPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ReceiptShareScreen(
                date:
                    '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                transactionDetailList: [
                  ShareableTransactionReceiptDetail(
                    label: 'Amount',
                    value: currencyFormatter(amount.toString()),
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Currency',
                    value: 'NGN',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Transaction Type',
                    value: 'Inter-bank Transfer',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Sender Name',
                    value: _userFullname,
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Beneficiary Details',
                    value:
                        '${widget.beneficiaryDetails.accountName} \n${widget.beneficiaryDetails.accountNumber}',
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Beneficiary Bank',
                    value: widget.beneficiaryDetails.bankName,
                  ),
                  if (descriptionController.text.isNotEmpty)
                    ShareableTransactionReceiptDetail(
                      label: 'Narration',
                      value: descriptionController.text,
                    ),
                  ShareableTransactionReceiptDetail(
                    label: 'Transaction ID',
                    value: verifiedAccount!.sessionId,
                  ),
                  ShareableTransactionReceiptDetail(
                    label: 'Status',
                    value: 'Successful',
                    isSuccessful: true,
                  ),
                ],
              ),
        ),
      );
    }

    // Listen to transfer state
    ref.listen(transferNotifierProvider, (previous, next) {
      if (next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
        if (!mounted) {
          return;
        }

        // Small delay to ensure any dialogs are closed
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) {
            return;
          }

          // Transfer successful - navigate to receipt
          final transferAmount =
              double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => TransactionReceiptWidget(
                    headerText: 'Transfer',
                    amount: currencyFormatter(transferAmount.toString()),
                    topDetails: [
                      TransactionDetail(
                        label: 'Transaction ID',
                        value: verifiedAccount!.sessionId,
                        showCopyIcon: true,
                      ),
                      TransactionDetail(
                        label: 'Recipient Name',
                        value: widget.beneficiaryDetails.accountName,
                      ),
                      TransactionDetail(
                        label: 'Recipient Account',
                        value: widget.beneficiaryDetails.accountNumber,
                      ),
                      TransactionDetail(
                        label: 'Bank',
                        value: widget.beneficiaryDetails.bankName,
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
                        value:
                            descriptionController.text.trim().isEmpty
                                ? 'No description'
                                : descriptionController.text.trim(),
                      ),
                    ],
                    onShareReceipt: _onShareTransactionReceiptPressed,
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

      _handlePinEntry() async {
      final pin = await TransactionPinModal.show(context);

      if (pin != null && pin.length == 4) {
        // Ensure PIN is a string
        final pinString = pin.toString();

        if (mounted) {
          _initiateTransfer(pinString, amount);
        }
      }
    }

    _handleBiometricPinEntry() async {
      final pin = await BiometricTransactionPinModal.show(context);

      if (pin != null && pin.length == 4) {
        // Ensure PIN is a string
        final pinString = pin.toString();

        if (mounted) {
          _initiateTransfer(pinString, amount);
        }
      }
    }

    _handleOnPressed() {
      final user = ref.watch(userProvider);
      final wallet =
          user?.wallets.isNotEmpty == true ? user!.wallets.first : null;
      final balance = wallet?.balance ?? 0.0;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final hasEnoughBalance = checkBalanceLeft(
        context,
        balance.toString(),
        totalAmount.toString(),
      );

      if (!hasEnoughBalance) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ReuseableTransactionDetailsScreen(
                hasBottom: false,
                saveBeneficiary: saveBeneficiary,
                onSaveBeneficiaryChanged: (value) {
                  setState(() {
                    saveBeneficiary = value;
                  });
                },
                topTitleText: 'Transaction',
                topTransactionsDetailsList: [
                  buildDetailRow(
                    'Account Name',
                    widget.beneficiaryDetails.accountName,
                    isDark,
                  ),
                  buildDetailRow(
                    'Bank',
                    widget.beneficiaryDetails.bankName,
                    isDark,
                  ),
                  buildDetailRow(
                    'Account Number',
                    widget.beneficiaryDetails.accountNumber,
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
                onButtonPressed: _handlePinEntry,
                onBiometricButtonPressed: _handleBiometricPinEntry,
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
                          widget.beneficiaryDetails.bankName
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
                              widget.beneficiaryDetails.accountName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.beneficiaryDetails.accountNumber} • ${widget.beneficiaryDetails.bankName}",
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
              onPressed: _handleOnPressed,
            ),
          ],
        ),
      ),
    );
  }
}
