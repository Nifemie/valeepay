class SetWalletPinResponse {
  final String message;
  final int statusCode;

  SetWalletPinResponse({
    required this.message,
    required this.statusCode,
  });

  factory SetWalletPinResponse.fromJson(Map<String, dynamic> json) {
    return SetWalletPinResponse(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }
}
