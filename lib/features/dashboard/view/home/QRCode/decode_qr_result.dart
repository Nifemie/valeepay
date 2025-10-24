import 'package:flutter/material.dart';
import 'package:valarpay/features/models/decode_qr_response.dart';

class DecodeQrResultScreen extends StatelessWidget {
  final DecodeQrResponse data;
  const DecodeQrResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Decode Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8),
          Text('Decoded Data',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          _row('Bank Code', data.bankCode ?? '-'),
          _row('Account Number', data.accountNumber ?? '-'),
          _row('Currency', data.currency ?? '-'),
          _row('Fee', '${data.fee ?? '-'}'),
          _row('Amount', data.amount ?? '-'),
          _row('Session ID', data.sessionId ?? '-'),
        ]),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value))
        ]),
      );
}
