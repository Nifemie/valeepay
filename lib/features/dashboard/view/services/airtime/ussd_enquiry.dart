import 'package:flutter/material.dart';
import '../../../widgets/services_widgets/ussd_service_tile.dart';
import '../../../widgets/services_widgets/network_section.dart';

class USSDEnquiryScreen extends StatelessWidget {
  const USSDEnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // MTN Section
            NetworkSection(
              networkName: 'MTN',
              networkColor: Colors.yellow,
              networkIcon: 'M',
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
              networkColor: Colors.red,
              networkIcon: 'A',
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
              networkColor: Colors.green,
              networkIcon: 'G',
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
              networkColor: Colors.green,
              networkIcon: '9',
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
