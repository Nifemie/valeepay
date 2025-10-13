import 'package:flutter/material.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/network_section.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/ussd_service_tile.dart';

class DataUSSDEnquiryScreen extends StatelessWidget {
  const DataUSSDEnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'USSD Enquiry',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MTN Section
            NetworkSection(
              networkName: 'MTN',
              imagePath: 'assets/images/mtn.png',
              services: const [
                USSDService(
                  title: 'Check mobile phone number',
                  code: '*663#',
                ),
                USSDService(
                  title: 'Check mobile balance',
                  code: '*310#',
                ),
                USSDService(
                  title: 'Check data usage',
                  code: '*323#',
                ),
                USSDService(
                  title: 'General short code',
                  code: '*301#',
                ),
                USSDService(
                  title: 'Share services',
                  code: '*321#',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Airtel Section
            NetworkSection(
              networkName: 'Airtel',
              imagePath: 'assets/images/airtel.png',
              services: const [
                USSDService(
                  title: 'Check mobile phone number',
                  code: '*121*9#',
                ),
                USSDService(
                  title: 'Check mobile balance',
                  code: '*310#',
                ),
                USSDService(
                  title: 'Check data usage',
                  code: '*323#',
                ),
                USSDService(
                  title: 'General short code',
                  code: '*301#',
                ),
                USSDService(
                  title: 'Share services',
                  code: '*321#',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Glo Section
            NetworkSection(
              networkName: 'Glo',
              imagePath: 'assets/images/glo.png',
              services: const [
                USSDService(
                  title: 'Check mobile phone number',
                  code: '*777#',
                ),
                USSDService(
                  title: 'Check mobile balance',
                  code: '*310#',
                ),
                USSDService(
                  title: 'Check data usage',
                  code: '*323#',
                ),
                USSDService(
                  title: 'General short code',
                  code: '*301#',
                ),
                USSDService(
                  title: 'Share services',
                  code: '*321#',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 9mobile Section
            NetworkSection(
              networkName: '9mobile',
              imagePath: 'assets/images/9mobile.png',
              services: const [
                USSDService(
                  title: 'Check mobile phone number',
                  code: '*248#',
                ),
                USSDService(
                  title: 'Check mobile balance',
                  code: '*310#',
                ),
                USSDService(
                  title: 'Check data usage',
                  code: '*323#',
                ),
                USSDService(
                  title: 'General short code',
                  code: '*301#',
                ),
                USSDService(
                  title: 'Share services',
                  code: '*321#',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}