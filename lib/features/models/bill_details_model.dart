class BillDetails {
  final String? billType;
  final String? provider;
  final String? accountNumber;
  final double? amount;
  final String? reference;

  BillDetails({
    this.billType,
    this.provider,
    this.accountNumber,
    this.amount,
    this.reference,
  });

  factory BillDetails.fromJson(Map<String, dynamic> json) {
    return BillDetails(
      billType: json['billType'],
      provider: json['provider'],
      accountNumber: json['accountNumber'],
      amount: json['amount']?.toDouble(),
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() => {
    'billType': billType,
    'provider': provider,
    'accountNumber': accountNumber,
    'amount': amount,
    'reference': reference,
  };
}
