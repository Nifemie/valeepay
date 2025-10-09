import 'package:flutter/material.dart';
import '../../../view/services/electricity/electricity_screen.dart';
import '../../../view/services/electricity/saved_beneficiary_screen.dart';
import '../../../view/services/electricity/transaction_details_screen.dart';
import '../../../view/services/electricity/transaction_success_screen.dart';

class ElectricityNavigationHelper {
  static void navigateToElectricity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ElectricityScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SavedBeneficiaryScreen(),
      ),
    );
  }

  static void navigateToTransactionDetails(
    BuildContext context,
    Map<String, String> transactionData,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailsScreen(
          transactionData: transactionData,
        ),
      ),
    );
  }

  static void navigateToTransactionSuccess(
    BuildContext context,
    String amount,
    String transactionId,
    Map<String, String> details,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
