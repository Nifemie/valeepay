import 'package:flutter/material.dart';
import 'saved_beneficiary_screen.dart';
import 'country_provider_screen.dart';

class InternationalAirtimeScreen extends StatefulWidget {
  const InternationalAirtimeScreen({super.key});

  @override
  State<InternationalAirtimeScreen> createState() =>
      _InternationalAirtimeScreenState();
}

class _InternationalAirtimeScreenState
    extends State<InternationalAirtimeScreen> {
  String selectedCountry = '';

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
          'International Airtime',
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
                  builder: (context) =>
                      const InternationalAirtimeSavedBeneficiaryScreen(),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Countries/Providers List
            Expanded(
              child: ListView(
                children: [
                  _buildCountryTile('MTN Ghana', isDark),
                  _buildCountryTile('AirtelTigo Ghana', isDark),
                  _buildCountryTile('Titus Canada', isDark),
                  _buildCountryTile('Safaricom Kenya', isDark),
                  _buildCountryTile('Airtel Kenya', isDark),
                  _buildCountryTile('Moor Africa', isDark),
                  _buildCountryTile('Orange Senegal', isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryTile(String countryProvider, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          countryProvider,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDark ? Colors.white70 : Colors.grey[600],
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CountryProviderScreen(
                countryProvider: countryProvider,
              ),
            ),
          );
        },
      ),
    );
  }
}
