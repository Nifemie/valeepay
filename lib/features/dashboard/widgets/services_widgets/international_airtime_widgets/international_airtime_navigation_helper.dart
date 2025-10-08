import 'package:flutter/material.dart';
import '../../../view/services/international_airtime/international_airtime_screen.dart';
import '../../../view/services/international_airtime/saved_beneficiary_screen.dart';
import '../../../view/services/international_airtime/country_provider_screen.dart';
import '../../../view/services/international_airtime/transaction_details_screen.dart';
import '../../../view/services/international_airtime/transaction_success_screen.dart';

class InternationalAirtimeNavigationHelper {
  static void navigateToInternationalAirtime(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InternationalAirtimeScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const InternationalAirtimeSavedBeneficiaryScreen(),
      ),
    );
  }

  static void navigateToCountryProvider(
    BuildContext context,
    String countryProvider,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryProviderScreen(
          countryProvider: countryProvider,
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
        builder: (context) => InternationalAirtimeTransactionDetailsScreen(
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
        builder: (context) => InternationalAirtimeTransactionSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          transactionDetails: details,
        ),
      ),
    );
  }
}
