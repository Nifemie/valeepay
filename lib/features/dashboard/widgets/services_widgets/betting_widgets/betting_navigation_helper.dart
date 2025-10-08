import 'package:flutter/material.dart';
import '../../../view/services/betting/betting.dart';
import '../../../view/services/betting/saved_beneficiary_screen.dart';
import '../../../view/services/betting/provider_payment_screen.dart';
import '../../../view/services/betting/transaction_details_screen.dart';
import '../../../view/services/betting/transaction_success_screen.dart';

class BettingNavigationHelper {
  static void navigateToBetting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BettingScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BettingSavedBeneficiaryScreen(),
      ),
    );
  }

  static void navigateToProviderPayment(
    BuildContext context,
    String providerName,
    String userId,
    String amount,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BettingProviderPaymentScreen(
          providerName: providerName,
          userId: userId,
          amount: amount,
        ),
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
        builder: (context) => BettingTransactionDetailsScreen(
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
        builder: (context) => BettingTransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
