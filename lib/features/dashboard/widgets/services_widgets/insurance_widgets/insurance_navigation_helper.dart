import 'package:flutter/material.dart';
import '../../../view/services/insurance/insurance.dart';
import '../../../view/services/insurance/saved_beneficiary_screen.dart';
import '../../../view/services/insurance/insurance_provider_screen.dart';
import '../../../view/services/insurance/transaction_details_screen.dart';
import '../../../view/services/insurance/transaction_success_screen.dart';

class InsuranceNavigationHelper {
  static void navigateToInsurance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InsuranceScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InsuranceSavedBeneficiaryScreen(),
      ),
    );
  }

  static void navigateToInsuranceProvider(
    BuildContext context,
    String providerName,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsuranceProviderScreen(
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
        builder: (context) => InsuranceTransactionDetailsScreen(
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
        builder: (context) => InsuranceTransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
