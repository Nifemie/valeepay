class DecodeQrResponse {
  final String? bankCode;
  final String? accountNumber;
  final String? currency;
  final dynamic fee;
  final String? amount;
  final String? sessionId;

  DecodeQrResponse(
      {this.bankCode,
      this.accountNumber,
      this.currency,
      this.fee,
      this.amount,
      this.sessionId});

  factory DecodeQrResponse.fromJson(Map<String, dynamic> json) =>
      DecodeQrResponse(
        bankCode: json['bankCode']?.toString(),
        accountNumber: json['accountNumber']?.toString(),
        currency: json['currency']?.toString(),
        fee: json['fee'],
        amount: json['amount']?.toString(),
        sessionId: json['sessionId']?.toString(),
      );
}
