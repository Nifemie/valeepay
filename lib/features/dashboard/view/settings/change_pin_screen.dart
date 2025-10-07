import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  String currentPin = '';
  String newPin = '';
  String confirmPin = '';
  int step = 1; // 1: current pin, 2: new pin, 3: confirm pin
  final int pinLength = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Text(
                _getSubtitle(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pinLength, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        index < _getCurrentPin().length ? '•' : '',
                        style: TextStyle(
                            fontSize: 12, color: appTheme.primaryColor),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 48),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double buttonSize = (constraints.maxWidth - 60) / 3;
                    buttonSize = buttonSize > 80 ? 80 : buttonSize;

                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: buttonSize * 4 + 30, // 4 rows + spacing
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.0,
                        children: [
                          ...List.generate(9, (index) {
                            return _buildNumberButton(
                                '${index + 1}', buttonSize);
                          }),
                          const SizedBox.shrink(),
                          _buildNumberButton('0', buttonSize),
                          _buildNumberButton('⌫', buttonSize, isDelete: true),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (step) {
      case 1:
        return 'Enter Current PIN';
      case 2:
        return 'Enter New PIN';
      case 3:
        return 'Confirm New PIN';
      default:
        return 'Change PIN';
    }
  }

  String _getSubtitle() {
    switch (step) {
      case 1:
        return 'Please enter your current transaction PIN';
      case 2:
        return 'Please enter your new transaction PIN';
      case 3:
        return 'Please confirm your new transaction PIN';
      default:
        return '';
    }
  }

  String _getCurrentPin() {
    switch (step) {
      case 1:
        return currentPin;
      case 2:
        return newPin;
      case 3:
        return confirmPin;
      default:
        return '';
    }
  }

  Widget _buildNumberButton(String text, double size, {bool isDelete = false}) {
    return GestureDetector(
      onTap: () {
        if (isDelete) {
          _deleteDigit();
        } else {
          _addDigit(text);
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: size * 0.25, // Responsive font size
              fontWeight: FontWeight.w600,
              color: isDelete ? Colors.grey[700] : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  void _addDigit(String digit) {
    String currentPinValue = _getCurrentPin();
    if (currentPinValue.length < pinLength) {
      setState(() {
        switch (step) {
          case 1:
            currentPin += digit;
            break;
          case 2:
            newPin += digit;
            break;
          case 3:
            confirmPin += digit;
            break;
        }
      });

      if (_getCurrentPin().length == pinLength) {
        _handlePinComplete();
      }
    }
  }

  void _deleteDigit() {
    String currentPinValue = _getCurrentPin();
    if (currentPinValue.isNotEmpty) {
      setState(() {
        switch (step) {
          case 1:
            currentPin = currentPin.substring(0, currentPin.length - 1);
            break;
          case 2:
            newPin = newPin.substring(0, newPin.length - 1);
            break;
          case 3:
            confirmPin = confirmPin.substring(0, confirmPin.length - 1);
            break;
        }
      });
    }
  }

  void _handlePinComplete() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        switch (step) {
          case 1:
            // Verify current PIN (simulate verification)
            setState(() {
              step = 2;
            });
            break;
          case 2:
            setState(() {
              step = 3;
            });
            break;
          case 3:
            if (newPin == confirmPin) {
              _showSuccessDialog();
            } else {
              _showErrorDialog();
            }
            break;
        }
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'PIN Changed Successfully',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your transaction PIN has been successfully changed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('PIN Mismatch'),
        content:
            const Text('The PINs you entered do not match. Please try again.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                newPin = '';
                confirmPin = '';
                step = 2;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
