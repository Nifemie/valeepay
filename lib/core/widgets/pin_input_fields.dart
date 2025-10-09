import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInputField extends StatefulWidget {
  final Function(String) onChanged;
  final int pinLength;

  const PinInputField({
    Key? key,
    required this.onChanged,
    this.pinLength = 4,
  }) : super(key: key);

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.pinLength,
          (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.pinLength,
          (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.pinLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    // Notify parent of complete PIN
    final pin = _controllers.map((c) => c.text).join();
    widget.onChanged(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.pinLength, (index) {
        return Container(
          width: 60,
          height: 55,
          margin: EdgeInsets.only(
            right: index < widget.pinLength - 1 ? 16 : 0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF9CA3AF),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            obscureText: true,
            obscuringCharacter: '●',
            style: const TextStyle(
              color: Color(0xFF111827),
              fontFamily: 'SF Pro',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => _onChanged(index, value),
            
            onSubmitted: (value) {
              if (index < widget.pinLength - 1) {
                _focusNodes[index + 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}