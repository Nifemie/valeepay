import 'package:flutter/material.dart';
import '../../../widgets/home_widgets/support_widgets.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Frequently Asked Questions (FAQs)'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FAQTile(
            question: 'How do I fund my ValarPay wallet?',
            answer:
                'You can fund your wallet using your debit card, bank transfer, or through a merchant/agent deposit.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'How do I fund my ValarPay wallet?',
                    answer:
                        'You can fund your wallet using your debit card, bank transfer, or through a merchant/agent deposit.',
                  ),
                ),
              );
            },
          ),
          FAQTile(
            question: 'How long does it take for transfers to reflect?',
            answer:
                'Transfers are usually instant, but may take up to 5 minutes during peak periods.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'How long does it take for transfers to reflect?',
                    answer:
                        'Transfers are usually instant, but may take up to 5 minutes during peak periods.',
                  ),
                ),
              );
            },
          ),
          FAQTile(
            question: 'How do I pay bills with ValarPay?',
            answer:
                'Navigate to the Bills section, select your service provider, enter your details, and complete payment.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'How do I pay bills with ValarPay?',
                    answer:
                        'Navigate to the Bills section, select your service provider, enter your details, and complete payment.',
                  ),
                ),
              );
            },
          ),
          FAQTile(
            question: 'How secure is ValarPay?',
            answer:
                'ValarPay uses bank-level security with 256-bit encryption and multi-factor authentication.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'How secure is ValarPay?',
                    answer:
                        'ValarPay uses bank-level security with 256-bit encryption and multi-factor authentication.',
                  ),
                ),
              );
            },
          ),
          FAQTile(
            question: 'What do I need to complete KYC?',
            answer:
                'You need a valid government-issued ID, proof of address, and a clear selfie photo.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'What do I need to complete KYC?',
                    answer:
                        'You need a valid government-issued ID, proof of address, and a clear selfie photo.',
                  ),
                ),
              );
            },
          ),
          FAQTile(
            question: 'How do I lock money in savings?',
            answer:
                'Go to Savings, select a plan, choose your amount and duration, then confirm the lock.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'How do I lock money in savings?',
                    answer:
                        'Go to Savings, select a plan, choose your amount and duration, then confirm the lock.',
                  ),
                ),
              );
            },
          ),
          FAQTile(
            question: 'How do I change my phone number on ValarPay?',
            answer:
                'Contact customer support or visit any of our office branches with valid identification.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'How do I change my phone number on ValarPay?',
                    answer:
                        'Contact customer support or visit any of our office branches with valid identification.',
                  ),
                ),
              );
            },
          ),
          FAQTile(
            question: 'What documents are required for KYC?',
            answer:
                'Valid government ID (NIN, Driver\'s License, Passport), proof of address, and a clear selfie.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FAQDetailScreen(
                    question: 'What documents are required for KYC?',
                    answer:
                        'Valid government ID (NIN, Driver\'s License, Passport), proof of address, and a clear selfie.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FAQDetailScreen extends StatelessWidget {
  final String question;
  final String answer;

  const FAQDetailScreen({
    super.key,
    required this.question,
    required this.answer,
  });

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                answer,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
