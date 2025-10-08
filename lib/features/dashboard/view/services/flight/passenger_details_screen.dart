import 'package:flutter/material.dart';
import '../../../widgets/services_widgets/flight_widgets/gender_selector_modal.dart';
import 'flight_details_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final Map<String, String> flightData;

  const PassengerDetailsScreen({
    super.key,
    required this.flightData,
  });

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final List<Map<String, dynamic>> passengers = [];

  @override
  void initState() {
    super.initState();
    _initializePassengers();
  }

  void _initializePassengers() {
    final adults = int.parse(widget.flightData['adults'] ?? '0');
    final children = int.parse(widget.flightData['children'] ?? '0');

    // Add adults
    for (int i = 0; i < adults; i++) {
      passengers.add({
        'type': 'Adult ${i + 1} (12+ years)',
        'fullName': TextEditingController(),
        'dateOfBirth': null,
        'gender': 'Male',
      });
    }

    // Add children
    for (int i = 0; i < children; i++) {
      passengers.add({
        'type': 'Child ${i + 1} (2-11years)',
        'fullName': TextEditingController(),
        'dateOfBirth': null,
        'gender': 'Male',
      });
    }
  }

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
          'Passenger Details',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Instruction text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Enter traveller information as it appears on your valid ID or passport',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),

          // Passengers list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: passengers.length,
              itemBuilder: (context, index) {
                return _buildPassengerForm(passengers[index], index, isDark);
              },
            ),
          ),

          // Continue button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightDetailsScreen(
                        flightData: widget.flightData,
                        passengers: passengers,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF76301),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerForm(
      Map<String, dynamic> passenger, int index, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Passenger type
          Text(
            passenger['type'],
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          // Full Name
          Text(
            'Full Name',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passenger['fullName'],
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Colors.black : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date of Birth
          Text(
            'Date of Birth',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(passenger),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    passenger['dateOfBirth'] != null
                        ? '${passenger['dateOfBirth'].day}-${passenger['dateOfBirth'].month}-${passenger['dateOfBirth'].year}'
                        : 'DD-MM-YYYY',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Gender
          Text(
            'Gender',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showGenderSelector(passenger),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    passenger['gender'],
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(Map<String, dynamic> passenger) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        passenger['dateOfBirth'] = date;
      });
    }
  }

  void _showGenderSelector(Map<String, dynamic> passenger) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GenderSelectorModal(
        selectedGender: passenger['gender'],
        onGenderSelected: (gender) {
          setState(() {
            passenger['gender'] = gender;
          });
        },
      ),
    );
  }
}
