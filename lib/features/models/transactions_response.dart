import 'package:valarpay/features/models/transaction_model.dart';

class TransactionsResponse {
  final List<TransactionModel> transactions;
  final int totalCount;
  final int totalPages;
  final String message;
  final int statusCode;

  TransactionsResponse({
    required this.transactions,
    required this.totalCount,
    required this.totalPages,
    required this.message,
    required this.statusCode,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      transactions:
          (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'transactions': transactions.map((e) => e.toJson()).toList(),
    'totalCount': totalCount,
    'totalPages': totalPages,
    'message': message,
    'statusCode': statusCode,
  };

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get hasTransactions => transactions.isNotEmpty;
}
