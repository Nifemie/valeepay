import 'package:flutter/material.dart';
import '../../../view/services/swap_currency/transaction_success_screen.dart';

class SwapCurrencyPaymentMethodModal extends StatelessWidget {
  final Map<String, String> transactionData;
  final Function(String) onPaymentMethodSelected;

  const SwapCurrencyPaymentMethodModal({
    super.key,
    required this.transactionData,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final paymentMethods = [
      {
        'name': 'Vconnect Bank',
        'icon': Icons.account_balance,
        'color': Colors.orange,
      },
      {
        'name': 'First Bank of Nigeria',
        'icon': Icons.account_balance,
        'color': Colors.blue,
      },
      {
        'name': 'Wema Bank',
        'icon': Icons.account_balance,
        'color': Colors.purple,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2725) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Pay Via',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Payment methods
          ...paymentMethods.map((method) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: method['color'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  method['icon'] as IconData,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                method['name'] as String,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.star,
                color: Color(0xFFF76301),
                size: 20,
              ),
              onTap: () {
                onPaymentMethodSelected(method['name'] as String);
                Navigator.pop(context);
                _showPinEntry(context);
              },
            );
          }).toList(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showPinEntry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SwapCurrencyPinEntryModal(
        transactionData: transactionData,
      ),
    );
  }
}

class SwapCurrencyPinEntryModal extends StatefulWidget {
  final Map<String, String> transactionData;

  const SwapCurrencyPinEntryModal({
    super.key,
    required this.transactionData,
  });

  @override
  State<SwapCurrencyPinEntryModal> createState() =>
      _SwapCurrencyPinEntryModalState();
}

class _SwapCurrencyPinEntryModalState extends State<SwapCurrencyPinEntryModal> {
  String pin = '';
  final int pinLength = 4;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2725) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Enter Transaction Pin',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // PIN dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pinLength, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < pin.length
                      ? const Color(0xFFF76301)
                      : Colors.grey[300],
                ),
              );
            }),
          ),

          const Spacer(),

          // Number pad
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              if (index == 9) {
                return const SizedBox(); // Empty space
              } else if (index == 10) {
                return _buildNumberButton('0');
              } else if (index == 11) {
                return _buildDeleteButton();
              } else {
                return _buildNumberButton('${index + 1}');
              }
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (pin.length < pinLength) {
          setState(() {
            pin += number;
          });

          if (pin.length == pinLength) {
            // Handle PIN completion
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SwapCurrencyTransactionSuccessScreen(
                    transactionData: widget.transactionData,
                  ),
                ),
              );
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (pin.isNotEmpty) {
          setState(() {
            pin = pin.substring(0, pin.length - 1);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: isDark ? Colors.white : Colors.black,
            size: 24,
          ),
        ),
      ),
    );
  }
}
