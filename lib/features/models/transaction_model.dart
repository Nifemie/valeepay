import 'package:valarpay/features/models/deposit_details_model.dart';
import 'package:valarpay/features/models/transfer_details_model.dart';
import 'package:valarpay/features/models/bill_details_model.dart';

class TransactionModel {
  final String id;
  final String walletId;
  final String? transactionRef;
  final String type; // CREDIT or DEBIT
  final String category; // DEPOSIT, TRANSFER, BILL_PAYMENT, etc.
  final String currency;
  final String status; // success, pending, failed
  final String description;
  final double previousBalance;
  final double currentBalance;
  final String? reference;
  final BillDetails? billDetails;
  final TransferDetails? transferDetails;
  final DepositDetails? depositDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.walletId,
    this.transactionRef,
    required this.type,
    required this.category,
    required this.currency,
    required this.status,
    required this.description,
    required this.previousBalance,
    required this.currentBalance,
    this.reference,
    this.billDetails,
    this.transferDetails,
    this.depositDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      walletId: json['walletId'] ?? '',
      transactionRef: json['transactionRef'],
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      currency: json['currency'] ?? 'NGN',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      previousBalance: (json['previousBalance'] ?? 0).toDouble(),
      currentBalance: (json['currentBalance'] ?? 0).toDouble(),
      reference: json['reference'],
      billDetails:
          json['billDetails'] != null
              ? BillDetails.fromJson(json['billDetails'])
              : null,
      transferDetails:
          json['transferDetails'] != null
              ? TransferDetails.fromJson(json['transferDetails'])
              : null,
      depositDetails:
          json['depositDetails'] != null
              ? DepositDetails.fromJson(json['depositDetails'])
              : null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'walletId': walletId,
    'transactionRef': transactionRef,
    'type': type,
    'category': category,
    'currency': currency,
    'status': status,
    'description': description,
    'previousBalance': previousBalance,
    'currentBalance': currentBalance,
    'reference': reference,
    'billDetails': billDetails?.toJson(),
    'transferDetails': transferDetails?.toJson(),
    'depositDetails': depositDetails?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  // Helper getters
  bool get isCredit => type.toUpperCase() == 'CREDIT';
  bool get isDebit => type.toUpperCase() == 'DEBIT';
  bool get isSuccessful => status.toLowerCase() == 'success';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';

  double get amount => (currentBalance - previousBalance).abs();

  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    return '$sign₦${amount.toStringAsFixed(2)}';
  }
}
