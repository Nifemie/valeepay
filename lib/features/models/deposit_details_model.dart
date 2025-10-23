class DepositDetails {
  final double? amount;
  final double? amountPaid;
  final String? senderName;
  final String? senderBankName;
  final String? beneficiaryName;
  final String? beneficiaryBankName;
  final String? senderAccountNumber;
  final String? beneficiaryAccountNumber;

  DepositDetails({
    this.amount,
    this.amountPaid,
    this.senderName,
    this.senderBankName,
    this.beneficiaryName,
    this.beneficiaryBankName,
    this.senderAccountNumber,
    this.beneficiaryAccountNumber,
  });

  factory DepositDetails.fromJson(Map<String, dynamic> json) {
    return DepositDetails(
      amount: json['amount']?.toDouble(),
      amountPaid: json['amountPaid']?.toDouble(),
      senderName: json['senderName'],
      senderBankName: json['senderBankName'],
      beneficiaryName: json['beneficiaryName'],
      beneficiaryBankName: json['beneficiaryBankName'],
      senderAccountNumber: json['senderAccountNumber'],
      beneficiaryAccountNumber: json['beneficiaryAccountNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'amountPaid': amountPaid,
    'senderName': senderName,
    'senderBankName': senderBankName,
    'beneficiaryName': beneficiaryName,
    'beneficiaryBankName': beneficiaryBankName,
    'senderAccountNumber': senderAccountNumber,
    'beneficiaryAccountNumber': beneficiaryAccountNumber,
  };
}
