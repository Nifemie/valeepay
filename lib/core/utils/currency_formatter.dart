import 'package:intl/intl.dart';

/// Formats numeric strings with thousand separators while preserving
/// any decimals the user provided.
/// Examples:
///  "50000.67" -> "₦50,000.67"
///  ".67"      -> "₦0.67"
///  "50000"    -> "₦50,000"
String currencyFormatter(String amount, {String symbol = '₦ '}) {
  if (amount.trim().isEmpty) return amount;

  // Remove spaces and trim
  final raw = amount.trim().replaceAll(' ', '');

  // Handle sign
  final isNegative = raw.startsWith('-');
  final withoutSign = raw.replaceFirst(RegExp(r'^[+-]'), '');

  // Remove grouping commas (if any)
  final cleaned = withoutSign.replaceAll(',', '');

  // Split integer and decimal parts (support multiple dots by joining remainder)
  String intPart;
  String? decPart;
  if (cleaned.contains('.')) {
    final parts = cleaned.split('.');
    intPart = parts[0]; // may be empty for inputs like ".67"
    decPart = parts.length > 1 ? parts.sublist(1).join('.') : null;
    if (decPart != null && decPart.isEmpty)
      decPart = null; // "50000." -> no decimal
  } else {
    intPart = cleaned;
  }

  // Keep only digits in integer part (fallback to "0" if empty)
  intPart = intPart.replaceAll(RegExp(r'[^0-9]'), '');
  if (intPart.isEmpty) intPart = '0';

  // Format integer part with thousands separators using intl
  final formattedInt =
      NumberFormat.decimalPattern('en_NG').format(int.parse(intPart));

  // Rebuild final string: preserve original decimal digits if present
  final numberString =
      decPart != null ? '$formattedInt.$decPart' : formattedInt;
  final signed = isNegative ? '-$numberString' : numberString;

  // Prepend symbol if provided
  return (symbol.isNotEmpty ? '$symbol$signed' : signed);
}
