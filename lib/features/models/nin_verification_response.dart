class NinVerificationResponse {
  final String? message;
  final String? error;
  final int? statusCode;
  final dynamic user;

  const NinVerificationResponse({
    this.message,
    this.error,
    this.statusCode,
    this.user,
  });

  factory NinVerificationResponse.fromJson(Map<String, dynamic> json) {
    return NinVerificationResponse(
      message: json['message'],
      error: json['error'],
      statusCode: json['statusCode'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'error': error,
      'statusCode': statusCode,
      'user': user,
    };
  }

  bool get isSuccess => statusCode == 200 || statusCode == 201;
}
