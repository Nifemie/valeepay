class VerifyWalletPinResponse {
  final String message;
  final int statusCode;

  VerifyWalletPinResponse({
    required this.message,
    required this.statusCode,
  });

  factory VerifyWalletPinResponse.fromJson(Map<String, dynamic> json) {
    return VerifyWalletPinResponse(
      message: json['message'] as String? ?? '',
      statusCode: json['statusCode'] as int? ?? 200,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
    };
  }

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
