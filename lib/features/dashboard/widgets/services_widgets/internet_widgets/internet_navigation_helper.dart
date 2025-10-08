import 'package:flutter/material.dart';
import '../../../view/services/internet/internet_screen.dart';
import '../../../view/services/internet/saved_beneficiary_screen.dart';
import '../../../view/services/internet/provider_payment_screen.dart';
import '../../../view/services/internet/transaction_details_screen.dart';
import '../../../view/services/internet/transaction_success_screen.dart';

class InternetNavigationHelper {
  static void navigateToInternet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InternetScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InternetSavedBeneficiaryScreen(),
      ),
    );
  }

  static void navigateToProviderPayment(
    BuildContext context,
    String providerName,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderPaymentScreen(
          providerName: providerName,
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
        builder: (context) => InternetTransactionDetailsScreen(
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
        builder: (context) => InternetTransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
