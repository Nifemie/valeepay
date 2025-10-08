import 'package:flutter/material.dart';
import '../../../view/services/cabletv/cabletv_screen.dart';
import '../../../view/services/cabletv/saved_beneficiary_screen.dart';
import '../../../view/services/cabletv/provider_payment_screen.dart';
import '../../../view/services/cabletv/transaction_details_screen.dart';
import '../../../view/services/cabletv/transaction_success_screen.dart';

class CableTvNavigationHelper {
  static void navigateToCableTv(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CableTvScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CableTvSavedBeneficiaryScreen(),
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
        builder: (context) => CableTvProviderPaymentScreen(
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
        builder: (context) => CableTvTransactionDetailsScreen(
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
        builder: (context) => CableTvTransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
