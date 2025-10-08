import 'package:flutter/material.dart';
import '../../../widgets/services_widgets/flight_widgets/payment_method_modal.dart';
import 'flight_success_screen.dart';

class FlightDetailsScreen extends StatelessWidget {
  final Map<String, String> flightData;
  final List<Map<String, dynamic>> passengers;

  const FlightDetailsScreen({
    super.key,
    required this.flightData,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Flight Details',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                      'Route',
                      '${flightData['departure']} → ${flightData['destination']}',
                      isDark),
                  _buildDetailRow('Airline', 'Airpeace', isDark),
                  _buildDetailRow(
                      'Class Type', flightData['class'] ?? 'Economy', isDark),
                  _buildDetailRow(
                      'Number of Passengers', '${passengers.length}', isDark),
                  _buildDetailRow('Phone Number',
                      flightData['phone'] ?? '0000000000000', isDark),
                  _buildDetailRow('Email Address',
                      flightData['email'] ?? '0000000000@gmail.com', isDark),
                  _buildDetailRow(
                      'Departure Date', '10 Oct 2025, 9:00 AM', isDark),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Fare Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fare Breakdown',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Adult Fare', '₦45,000', isDark),
                  _buildDetailRow('Children Fare', '₦45,000', isDark),
                  _buildDetailRow('Infant Fare', '₦45,000', isDark),
                  _buildDetailRow('Taxes & Fees', '₦45,000', isDark),
                  _buildDetailRow('Service Charges', '₦45,000', isDark),
                  const Divider(),
                  _buildDetailRow('Total Amount', '₦45,000', isDark,
                      isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pay Via section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay Via',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment methods
                  _buildPaymentMethod(
                    'Vconnect Bank',
                    Icons.account_balance,
                    Colors.orange,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethod(
                    'First Bank of Nigeria',
                    Icons.account_balance,
                    Colors.blue,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethod(
                    'Wema Bank',
                    Icons.account_balance,
                    Colors.purple,
                    isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Pay Flight Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentMethodModal(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF76301),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Pay Flight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
    String name,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        const Icon(
          Icons.star,
          color: Color(0xFFF76301),
          size: 20,
        ),
      ],
    );
  }

  void _showPaymentMethodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FlightPaymentMethodModal(
        onPaymentComplete: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FlightSuccessScreen(
                amount: '₦150,500.00',
                transactionId: 'TXN123456789',
                flightDetails: {
                  'Route':
                      '${flightData['departure']} → ${flightData['destination']}',
                  'Airline': 'Airpeace',
                  'Class': flightData['class'] ?? 'Economy',
                  'Passengers': '${passengers.length}',
                  'Date': '10 Oct 2025, 9:00 AM',
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
