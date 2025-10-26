import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/reuseable_amount_textfield.dart';
import 'package:valarpay/features/notifiers/generate_qr_notifier.dart';

class GenerateQrScreen extends ConsumerStatefulWidget {
  const GenerateQrScreen({super.key});

  @override
  ConsumerState<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends ConsumerState<GenerateQrScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _generatedDataUri;
  bool _saving = false;
  final NumberFormat formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final text = _amountController.text.replaceAll(',', '');
      if (text.isEmpty) return;
      // Prevent recursive updates
      final newText = formatter.format(int.parse(text));
      if (newText != _amountController.text) {
        final cursorPos = newText.length;
        _amountController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPos),
        );
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onGenerate() async {
    final text = _amountController.text.replaceAll(',', '').trim();
    if (text.isEmpty) {
      AppMessenger.show(context,
          message: 'Please enter an amount', type: MessageType.warning);

      return;
    }
    final amount = double.tryParse(text);
    if (amount == null) {
      AppMessenger.show(context,
          message: 'Invalid amount', type: MessageType.error);

      return;
    }

    await ref.read(generateQrNotifierProvider.notifier).generate(amount);
    final state = ref.read(generateQrNotifierProvider);
    if (state.isDataAvailable && state.data != null && state.data!.isNotEmpty) {
      setState(() {
        _generatedDataUri = state.data!.first.data;
      });
    } else {
      AppMessenger.show(context,
            message: state.message ?? 'Failed to generate QR', type: MessageType.error);
      
    }
  }

  Future<void> _saveToDevice() async {
    if (_generatedDataUri == null) return;
    setState(() => _saving = true);
    try {
      // data:image/png;base64,....
      final uri = _generatedDataUri!;
      final idx = uri.indexOf('base64,');
      final base64Str = idx >= 0 ? uri.substring(idx + 7) : uri;
      final bytes = base64Decode(base64Str);

      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/valeepay_qr_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      AppMessenger.show(
        context,
        message: 'Saved to ${file.path}',
        type: MessageType.success,
      );
    } catch (e) {
      AppMessenger.show(
        context,
        message: 'Save failed  $e',
        type: MessageType.error,
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(generateQrNotifierProvider);
    final isLoading = state.isInitialLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate QR')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWide ? 600 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24),
                    const Text(
                      'Enter amount to generate a payment QR code',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ReuseableAmountTextfield(
                      amountController: _amountController,
                      prefixText: '₦',
                      hintText: 'Enter Amount',
                      onChanged: (s) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 24),
                    Spacer(),
                    const SizedBox(height: 24),
                    if (_generatedDataUri != null) ...[
                      Center(
                        child: Text(
                          'Generated QR',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Builder(
                          builder: (_) {
                            final uri = _generatedDataUri!;
                            final idx = uri.indexOf('base64,');
                            final base64Str =
                                idx >= 0 ? uri.substring(idx + 7) : uri;
                            final bytes = base64Decode(base64Str);
                            return Image.memory(
                              bytes,
                              height: 260,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      FullWidthButton(
                        isEnabled: !_saving,
                        isLoading: isLoading,
                        text: 'Save To Device',
                        onPressed: _saveToDevice,
                      ),
                    ],
                    FullWidthButton(
                      isEnabled: _amountController.text.isNotEmpty,
                      isLoading: isLoading,
                      text: 'Generate',
                      onPressed: _onGenerate,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
