class ApiResponse {
  final String message;
  final int? statusCode;

  ApiResponse({
    required this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        message: json['message'] ?? 'Success',
        statusCode: json['statusCode'],
      );
}
