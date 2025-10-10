import 'package:flutter/material.dart';
import '../../../widgets/services_widgets/flight_widgets/destination_selector_modal.dart';
import '../../../widgets/services_widgets/flight_widgets/class_selector_modal.dart';
import 'saved_beneficiary_screen.dart';
import 'passenger_details_screen.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  String selectedDeparture = 'Benin City';
  String selectedDestination = 'Abuja';
  String selectedClass = 'Economy';
  DateTime? departureDate;
  final TextEditingController controller = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  int adults = 1;
  int children = 0;
  int infants = 0;

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
          'Flight',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlightSavedBeneficiaryScreen(),
                ),
              );
            },
            child: const Text(
              'Saved Beneficiary',
              style: TextStyle(
                color: Color(0xFFF76301),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place of Departure
            _buildSectionTitle('Place of Departure', isDark),
            const SizedBox(height: 8),
            _buildDropdownField(
              selectedDeparture,
              () => _showDestinationSelector(context, true),
              isDark,
            ),

            const SizedBox(height: 24),

            // Departure Date
            _buildSectionTitle('Departure Date', isDark),
            const SizedBox(height: 8),
            _buildDateField(isDark),

            const SizedBox(height: 24),

            // Destination
            _buildSectionTitle('Destination', isDark),
            const SizedBox(height: 8),
            _buildDropdownField(
              selectedDestination,
              () => _showDestinationSelector(context, false),
              isDark,
            ),

            const SizedBox(height: 24),

            // Class Type
            _buildSectionTitle('Class Type', isDark),
            const SizedBox(height: 8),
            _buildDropdownField(
              selectedClass,
              () => _showClassSelector(context),
              isDark,
            ),

            const SizedBox(height: 24),

            // Email Address
            _buildSectionTitle('Email Address', isDark),
            const SizedBox(height: 8),
            _buildTextField(emailController, '', isDark),

            const SizedBox(height: 24),

            // Phone Number
            _buildSectionTitle('Phone Number', isDark),
            const SizedBox(height: 8),
            _buildPhoneField(isDark),

            const SizedBox(height: 24),

            // Passengers
            _buildSectionTitle('Passengers', isDark),
            const SizedBox(height: 16),
            _buildPassengerCounter('Adults (12+ years)', adults, (value) {
              setState(() => adults = value);
            }, isDark),
            const SizedBox(height: 12),
            _buildPassengerCounter('Children (2-11 years)', children, (value) {
              setState(() => children = value);
            }, isDark),
            const SizedBox(height: 12),
            _buildPassengerCounter('Infants (under 2 years)', infants, (value) {
              setState(() => infants = value);
            }, isDark),

            const SizedBox(height: 40),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PassengerDetailsScreen(
                        flightData: {
                          'departure': selectedDeparture,
                          'destination': selectedDestination,
                          'class': selectedClass,
                          'departureDate': departureDate?.toString() ?? '',
                          'adults': adults.toString(),
                          'children': children.toString(),
                          'infants': infants.toString(),
                          'email': emailController.text,
                          'phone': controller.text,
                        },
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white70 : Colors.grey[600],
        fontSize: 14,
      ),
    );
  }

  Widget _buildDropdownField(String value, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
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
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, bool isDark) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400]),
        filled: true,
        fillColor: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDateField(bool isDark) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => departureDate = date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              departureDate != null
                  ? '${departureDate!.day}-${departureDate!.month}-${departureDate!.year}'
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
    );
  }

  Widget _buildPhoneField(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '+234',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: '0000000000',
              hintStyle:
                  TextStyle(color: isDark ? Colors.white38 : Colors.grey[400]),
              filled: true,
              fillColor: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerCounter(
      String title, int count, Function(int) onChanged, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: count > 0 ? () => onChanged(count - 1) : null,
              icon: Icon(
                Icons.remove_circle_outline,
                color: count > 0
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.grey,
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () => onChanged(count + 1),
              icon: Icon(
                Icons.add_circle_outline,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDestinationSelector(BuildContext context, bool isDeparture) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DestinationSelectorModal(
        isDeparture: isDeparture,
        selectedDestination:
            isDeparture ? selectedDeparture : selectedDestination,
        onDestinationSelected: (destination) {
          setState(() {
            if (isDeparture) {
              selectedDeparture = destination;
            } else {
              selectedDestination = destination;
            }
          });
        },
      ),
    );
  }

  void _showClassSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClassSelectorModal(
        selectedClass: selectedClass,
        onClassSelected: (classType) {
          setState(() {
            selectedClass = classType;
          });
        },
      ),
    );
  }
}
