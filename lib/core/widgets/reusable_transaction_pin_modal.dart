import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valarpay/core/utils/color_utils.dart';

// State provider for the PIN
final pinProvider =
    StateNotifierProvider.autoDispose<PinNotifier, List<String>>(
  (ref) => PinNotifier(),
);

class PinNotifier extends StateNotifier<List<String>> {
  PinNotifier() : super(['', '', '', '']);

  void addDigit(String digit) {
    final index = state.indexWhere((element) => element.isEmpty);
    if (index != -1) {
      final newState = List<String>.from(state);
      newState[index] = digit;
      state = newState;
    }
  }

  void removeDigit() {
    final index = state.lastIndexWhere((element) => element.isNotEmpty);
    if (index != -1) {
      final newState = List<String>.from(state);
      newState[index] = '';
      state = newState;
    }
  }

  void reset() {
    state = ['', '', '', ''];
  }

  String getPin() => state.join();
  bool isComplete() => state.every((element) => element.isNotEmpty);
}

class TransactionPinModal extends ConsumerStatefulWidget {
  final String title;
  final Function(String pin)? onComplete;
  final VoidCallback? onForgotPin;

  const TransactionPinModal({
    Key? key,
    this.title = 'Enter Transaction Pin',
    this.onComplete,
    this.onForgotPin,
  }) : super(key: key);

  @override
  ConsumerState<TransactionPinModal> createState() =>
      _TransactionPinModalState();

  // Static method to show the modal
  static Future<String?> show(
    BuildContext context, {
    String title = 'Enter Transaction Pin',
    VoidCallback? onForgotPin,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionPinModal(
        title: title,
        onForgotPin: onForgotPin,
      ),
    );
  }
}

class _TransactionPinModalState extends ConsumerState<TransactionPinModal> {
  @override
  void initState() {
    super.initState();
    // Reset PIN when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pinProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pin = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);

    // Auto-complete when all digits are entered
    ref.listen(pinProvider, (previous, next) {
      if (next.every((element) => element.isNotEmpty)) {
        final completePin = next.join();
        if (widget.onComplete != null) {
          widget.onComplete!(completePin);
        } else {
          Navigator.of(context).pop(completePin);
        }
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 10),
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance the back button
              ],
            ),
            const SizedBox(height: 32),

            // PIN Input Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index < 3 ? 12 : 0,
                  ),
                  child: _PinBox(
                    value: pin[index],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Forgot Pin
            TextButton(
              onPressed: widget.onForgotPin,
              child: const Text(
                'Forgot Pin?',
                style: TextStyle(
                  fontSize: 14,
                  color: appTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Number Pad
            _NumberPad(
              onNumberPressed: (number) => pinNotifier.addDigit(number),
              onDeletePressed: () => pinNotifier.removeDigit(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PinBox extends StatelessWidget {
  final String value;

  const _PinBox({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF9CA3AF),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: value.isNotEmpty
          ? Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: appTheme.primaryColor,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _NumberPad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;

  const _NumberPad({
    Key? key,
    required this.onNumberPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 12),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 12),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 12),
        _buildRow(['', '0', 'delete']),
      ],
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      children: numbers.map((number) {
        if (number.isEmpty) {
          return const Expanded(child: SizedBox());
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _NumberButton(
              value: number,
              onPressed: () {
                if (number == 'delete') {
                  onDeletePressed();
                } else {
                  onNumberPressed(number);
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String value;
  final VoidCallback onPressed;

  const _NumberButton({
    Key? key,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDelete = value == 'delete';

    return Material(
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 52,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: isDelete
                ? SvgPicture.asset(
                    'assets/icons/close_icon.svg',
                    width: 24,
                    height: 24,
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
