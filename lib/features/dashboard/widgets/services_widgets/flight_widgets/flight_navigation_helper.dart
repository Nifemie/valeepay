import 'package:flutter/material.dart';
import '../../../view/services/flight/flight_screen.dart';
import '../../../view/services/flight/saved_beneficiary_screen.dart';
import '../../../view/services/flight/passenger_details_screen.dart';
import '../../../view/services/flight/flight_details_screen.dart';
import '../../../view/services/flight/flight_success_screen.dart';

class FlightNavigationHelper {
  static void navigateToFlight(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlightScreen(),
      ),
    );
  }

  static void navigateToSavedBeneficiaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlightSavedBeneficiaryScreen(),
      ),
    );
  }

  static void navigateToPassengerDetails(
    BuildContext context,
    Map<String, String> flightData,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerDetailsScreen(
          flightData: flightData,
        ),
      ),
    );
  }

  static void navigateToFlightDetails(
    BuildContext context,
    Map<String, String> flightData,
    List<Map<String, dynamic>> passengers,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightDetailsScreen(
          flightData: flightData,
          passengers: passengers,
        ),
      ),
    );
  }

  static void navigateToFlightSuccess(
    BuildContext context,
    String amount,
    String transactionId,
    Map<String, String> flightDetails,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSuccessScreen(
          amount: amount,
          transactionId: transactionId,
          flightDetails: flightDetails,
        ),
      ),
    );
  }
}
