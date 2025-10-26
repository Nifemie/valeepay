import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/reuseable_appbar_text_button.dart';
import 'package:valarpay/core/widgets/kyc_not_set_widget.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import 'saved_beneficiary_screen.dart';
import 'country_provider_screen.dart';

class InternationalAirtimeScreen extends ConsumerStatefulWidget {
  const InternationalAirtimeScreen({super.key});

  @override
  ConsumerState<InternationalAirtimeScreen> createState() =>
      _InternationalAirtimeScreenState();
}

class _InternationalAirtimeScreenState
    extends ConsumerState<InternationalAirtimeScreen> {
  String selectedCountry = '';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isBvnVerified = user?.isBvnVerified ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'International Airtime',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: isBvnVerified
            ? [
                ReuseableAppbarTextButton(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const InternationalAirtimeSavedBeneficiaryScreen(),
                          ),
                        ),
                    text: 'Saved Beneficiary')
              ]
            : null,
      ),
      body: !isBvnVerified
          ? const KycNotSetWidget(
              title: 'KYC Not Completed',
              subtitle:
                  'Complete your KYC verification to purchase international airtime',
            )
          : Padding(
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
