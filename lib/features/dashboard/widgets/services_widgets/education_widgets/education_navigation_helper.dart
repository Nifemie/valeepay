import 'package:flutter/material.dart';
import '../../../view/services/education/education.dart';
import '../../../view/services/education/saved_beneficiary_screen.dart';
import '../../../view/services/education/institution_payment_screen.dart';
import '../../../view/services/education/transaction_details_screen.dart';
import '../../../view/services/education/transaction_success_screen.dart';

class EducationNavigationHelper {
  static void navigateToEducation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EducationScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EducationSavedBeneficiaryScreen(),
      ),
    );
  }

  static void navigateToInstitutionPayment(
    BuildContext context,
    String institutionName,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstitutionPaymentScreen(
          institutionName: institutionName,
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
        builder: (context) => EducationTransactionDetailsScreen(
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
        builder: (context) => EducationTransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
