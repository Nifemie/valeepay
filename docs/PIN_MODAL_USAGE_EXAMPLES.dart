// Example: How to use Transaction PIN Modal in your screens

import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';

// Example 1: Send Money Screen
class SendMoneyExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Money')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Show PIN modal with backend verification
            final pin = await TransactionPinModal.show(
              context,
              title: 'Confirm Transfer',
              verifyWithBackend: true, // Verifies with API
            );

            if (pin != null) {
              // PIN verified! Proceed with transaction
              print('PIN verified: $pin');
              // Call your transfer API here
              await _processTransfer();
            } else {
              // User cancelled or verification failed
              _showError(context, 'Transaction cancelled');
            }
          },
          child: Text('Transfer ₦5,000'),
        ),
      ),
    );
  }

  Future<void> _processTransfer() async {
    // Your transfer logic here
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Example 2: Bill Payment Screen
class BillPaymentExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final pin = await TransactionPinModal.show(
          context,
          title: 'Confirm Payment',
          onForgotPin: () {
            // Handle forgot PIN
            Navigator.pushNamed(context, '/forgot-pin');
          },
        );

        if (pin != null) {
          // Process bill payment
          await _payBill();
        }
      },
      child: Text('Pay Bill'),
    );
  }

  Future<void> _payBill() async {
    // Your bill payment logic
  }
}

// Example 3: Settings - Change PIN
class ChangePinExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // First verify old PIN
        final oldPin = await TransactionPinModal.show(
          context,
          title: 'Enter Current PIN',
        );

        if (oldPin != null) {
          // Old PIN verified, show new PIN setup
          Navigator.pushNamed(context, '/setup-new-pin');
        }
      },
      child: Text('Change PIN'),
    );
  }
}

// Example 4: High-Value Transaction with Extra Verification
class HighValueTransactionExample extends StatelessWidget {
  final double amount = 100000; // Large amount

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // For large amounts, require PIN verification
        if (amount > 50000) {
          final pin = await TransactionPinModal.show(
            context,
            title: 'Large Transaction - Verify PIN',
          );

          if (pin == null) {
            _showError(context, 'Verification required for large transactions');
            return;
          }
        }

        // Proceed with transaction
        await _processTransaction();
      },
      child: Text('Transfer ₦${amount.toStringAsFixed(0)}'),
    );
  }

  Future<void> _processTransaction() async {
    // Your transaction logic
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Example 5: Without Backend Verification (Testing Only)
class TestingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // For testing, skip backend verification
        final pin = await TransactionPinModal.show(
          context,
          verifyWithBackend: false, // No API call
        );

        if (pin != null) {
          print('User entered PIN: $pin');
          // Use PIN locally
        }
      },
      child: Text('Test PIN Entry'),
    );
  }
}

// Example 6: Complete Transaction Flow
class CompleteTransactionExample extends StatefulWidget {
  @override
  _CompleteTransactionExampleState createState() =>
      _CompleteTransactionExampleState();
}

class _CompleteTransactionExampleState
    extends State<CompleteTransactionExample> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isProcessing ? null : _handleTransaction,
      child: _isProcessing
          ? CircularProgressIndicator(color: Colors.white)
          : Text('Send Money'),
    );
  }

  Future<void> _handleTransaction() async {
    // Step 1: Show PIN modal
    final pin = await TransactionPinModal.show(
      context,
      title: 'Confirm Transaction',
    );

    // Step 2: Check if verified
    if (pin == null) {
      _showMessage('Transaction cancelled');
      return;
    }

    // Step 3: Process transaction
    setState(() => _isProcessing = true);

    try {
      // Your API call here
      await _sendMoney();

      // Step 4: Show success
      _showSuccess();
    } catch (e) {
      // Step 5: Show error
      _showMessage('Transaction failed: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _sendMoney() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Transaction completed successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
