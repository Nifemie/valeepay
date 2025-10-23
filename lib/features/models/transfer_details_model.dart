class TransferDetails {
  final double? amount;
  final String? senderName;
  final String? senderBankName;
  final String? beneficiaryName;
  final String? beneficiaryBankName;
  final String? senderAccountNumber;
  final String? beneficiaryAccountNumber;
  final String? narration;

  TransferDetails({
    this.amount,
    this.senderName,
    this.senderBankName,
    this.beneficiaryName,
    this.beneficiaryBankName,
    this.senderAccountNumber,
    this.beneficiaryAccountNumber,
    this.narration,
  });

  factory TransferDetails.fromJson(Map<String, dynamic> json) {
    return TransferDetails(
      amount: json['amount']?.toDouble(),
      senderName: json['senderName'],
      senderBankName: json['senderBankName'],
      beneficiaryName: json['beneficiaryName'],
      beneficiaryBankName: json['beneficiaryBankName'],
      senderAccountNumber: json['senderAccountNumber'],
      beneficiaryAccountNumber: json['beneficiaryAccountNumber'],
      narration: json['narration'],
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'senderName': senderName,
    'senderBankName': senderBankName,
    'beneficiaryName': beneficiaryName,
    'beneficiaryBankName': beneficiaryBankName,
    'senderAccountNumber': senderAccountNumber,
    'beneficiaryAccountNumber': beneficiaryAccountNumber,
    'narration': narration,
  };
}
