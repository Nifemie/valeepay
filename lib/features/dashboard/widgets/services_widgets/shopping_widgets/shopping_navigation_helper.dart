import 'package:flutter/material.dart';
import '../../../view/services/shopping/shopping.dart';
import '../../../view/services/shopping/saved_beneficiary_screen.dart';
import '../../../view/services/shopping/provider_payment_screen.dart';
import '../../../view/services/shopping/transaction_details_screen.dart';
import '../../../view/services/shopping/transaction_success_screen.dart';

class ShoppingNavigationHelper {
  static void navigateToShopping(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShoppingScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShoppingSavedBeneficiaryScreen(),
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
        builder: (context) => ShoppingProviderPaymentScreen(
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
        builder: (context) => ShoppingTransactionDetailsScreen(
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
        builder: (context) => ShoppingTransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
