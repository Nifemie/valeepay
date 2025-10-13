import 'package:intl/intl.dart';

String currencyFormatter(String amount, {String symbol = '₦'}) {
  final double? value = double.tryParse(amount.replaceAll(',', ''));
  if (value == null) return amount;
  final formatter = NumberFormat.currency(locale: 'en_NG', symbol: symbol);
  return formatter.format(value);
}
