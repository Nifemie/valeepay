import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

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
  final bool verifyWithBackend; // New parameter for backend verification

  const TransactionPinModal({
    Key? key,
    this.title = 'Enter Transaction Pin',
    this.onComplete,
    this.onForgotPin,
    this.verifyWithBackend = true, // Default to true for security
  }) : super(key: key);

  @override
  ConsumerState<TransactionPinModal> createState() =>
      _TransactionPinModalState();

  // Static method to show the modal
  static Future<String?> show(
    BuildContext context, {
    String title = 'Enter Transaction Pin',
    VoidCallback? onForgotPin,
    Function(String)? onCompletePin,
    bool verifyWithBackend = true, // Add verification parameter
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionPinModal(
        title: title,
        onForgotPin: onForgotPin,
        onComplete: onCompletePin,
        verifyWithBackend: verifyWithBackend,
      ),
    );
  }
}

class _TransactionPinModalState extends ConsumerState<TransactionPinModal> {
  bool _isCompleting = false;
  bool _isVerifying = false;
  String? _errorMessage;
  int _attemptCount = 0;
  static const int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    // Reset PIN when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pinProvider.notifier).reset();
    });
  }

  void _onNumberPressed(String number) {
    // Clear error when user starts typing again
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }

    final pinNotifier = ref.read(pinProvider.notifier);
    pinNotifier.addDigit(number);
  }

  Future<void> _verifyPinWithBackend(String pin) async {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final isValid =
          await ref.read(userNotifierProvider.notifier).verifyWalletPin(pin);

      if (!mounted) return;

      if (isValid) {
        // PIN is correct
        if (widget.onComplete != null) {
          widget.onComplete!(pin);
        } else {
          Navigator.of(context).pop(pin);
        }
      } else {
        // PIN is wrong
        _attemptCount++;

        if (_attemptCount >= _maxAttempts) {
          // Max attempts reached - close modal
          setState(() {
            _errorMessage = 'Maximum attempts reached. Please try again later.';
          });

          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.of(context).pop(null);
          }
        } else {
          // Show error and allow retry
          final remainingAttempts = _maxAttempts - _attemptCount;
          setState(() {
            _errorMessage =
                'Wrong PIN. $remainingAttempts attempt${remainingAttempts > 1 ? 's' : ''} remaining.';
            _isVerifying = false;
          });

          // Reset PIN input
          ref.read(pinProvider.notifier).reset();
        }
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Network error. Please try again.';
        _isVerifying = false;
      });

      // Reset PIN input
      ref.read(pinProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pin = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);

    // Check if PIN is complete and not already completing/verifying
    if (pin.every((element) => element.isNotEmpty) &&
        !_isCompleting &&
        !_isVerifying) {
      final completePin = pin.join();
      _isCompleting = true;

      // Schedule verification or completion for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (widget.verifyWithBackend) {
            // Verify with backend before returning
            _verifyPinWithBackend(completePin);
          } else {
            // Skip verification, return immediately
            if (widget.onComplete != null) {
              widget.onComplete!(completePin);
            } else {
              Navigator.of(context).pop(completePin);
            }
          }
        }
      });
    }

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
              margin: const EdgeInsets.only(top: 8),
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
                      fontFamily: 'SF Pro',
                      fontSize: 16,
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
                    right: index < 3 ? 16 : 0,
                  ),
                  child: _PinBox(
                    value: pin[index],
                    hasError: _errorMessage != null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading or Error Message
            SizedBox(
              height: 24,
              child: _isVerifying
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              appTheme.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Verifying PIN...',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : _errorMessage != null
                      ? Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),

            // Forgot Pin
            TextButton(
              onPressed: widget.onForgotPin,
              child: const Text(
                'Forgot Pin?',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  color: appTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Number Pad
            _NumberPad(
              onNumberPressed: _isVerifying ? (_) {} : _onNumberPressed,
              onDeletePressed:
                  _isVerifying ? () {} : () => pinNotifier.removeDigit(),
              enabled: !_isVerifying,
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
  final bool hasError;

  const _PinBox({
    Key? key,
    required this.value,
    this.hasError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasError ? Colors.red : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: value.isNotEmpty
          ? Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: hasError ? Colors.red : appTheme.primaryColor,
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
  final bool enabled;

  const _NumberPad({
    Key? key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 16),
        _buildRow(['', '0', 'delete']),
      ],
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number.isEmpty) {
          return const SizedBox(width: 80);
        }
        return _NumberButton(
          value: number,
          enabled: enabled,
          onPressed: () {
            if (number == 'delete') {
              onDeletePressed();
            } else {
              onNumberPressed(number);
            }
          },
        );
      }).toList(),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String value;
  final VoidCallback onPressed;
  final bool enabled;

  const _NumberButton({
    Key? key,
    required this.value,
    required this.onPressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDelete = value == 'delete';

    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(40),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Container(
          width: 80,
          height: 60,
          alignment: Alignment.center,
          child: isDelete
              ? Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF111827),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
      ),
    );
  }
}
