class BvnValidateResponse {
  final String message;
  final int statusCode;

  BvnValidateResponse({
    required this.message,
    required this.statusCode,
  });

  factory BvnValidateResponse.fromJson(Map<String, dynamic> json) =>
      BvnValidateResponse(
        message: json['message'] ?? 'BVN verification successful',
        statusCode: json['statusCode'] ?? 200,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'statusCode': statusCode,
      };
}
