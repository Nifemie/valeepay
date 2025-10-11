import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valarpay/core/widgets/custom_toast.dart';

// Transaction detail model
class TransactionDetail {
  final String label;
  final String value;
  final bool showCopyIcon;

  TransactionDetail({
    required this.label,
    required this.value,
    this.showCopyIcon = false,
  });
}

class TransactionReceiptWidget extends StatelessWidget {
  final String amount;
  final List<TransactionDetail> topDetails;
  final List<TransactionDetail>? bottomDetails;
  final VoidCallback onShareReceipt;

  const TransactionReceiptWidget({
    Key? key,
    required this.amount,
    required this.topDetails,
    this.bottomDetails,
    required this.onShareReceipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Success Icon
                SvgPicture.asset(
                  'assets/icons/tick-circle.svg',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 16),
                // Transaction Successful Text
                const Text(
                  'Transaction Successful',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontFamily: 'SF Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 8),
                // Amount
                Text(
                  '₦$amount',
                  style: const TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 32),
                // Top Details Card
                _buildDetailsCard(context, topDetails),
                const SizedBox(height: 16),
                // Bottom Details Card
                if (bottomDetails != null)
                  _buildDetailsCard(context, bottomDetails!),
                const SizedBox(height: 32),
                // Share Receipt Button
                Container(
                  width: 335,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF76301),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextButton(
                    onPressed: onShareReceipt,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.share,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Share Receipt',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SF Pro',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Done Button
                Container(
                  width: 335,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFBFC),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontFamily: 'SF Pro',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(
      BuildContext context, List<TransactionDetail> details) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: details.asMap().entries.map((entry) {
          final index = entry.key;
          final detail = entry.value;
          final isLast = index == details.length - 1;

          return Column(
            children: [
              _buildDetailRow(context, detail),
              if (!isLast) const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, TransactionDetail detail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Expanded(
          child: Text(
            detail.label,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontFamily: 'SF Pro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.33,
              letterSpacing: 0.06,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Value with optional copy icon
        Row(
          children: [
            Text(
              detail.value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.06,
              ),
            ),
            if (detail.showCopyIcon) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: detail.value));
                  CustomToast.showAppToast(
                      context: context, message: 'Copied to clipboard');
                },
                child: const Icon(
                  Icons.copy,
                  size: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
