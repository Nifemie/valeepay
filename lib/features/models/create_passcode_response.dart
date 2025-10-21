class CreatePasscodeResponse {
  final String message;
  final int statusCode;

  CreatePasscodeResponse({
    required this.message,
    required this.statusCode,
  });

  factory CreatePasscodeResponse.fromJson(Map<String, dynamic> json) {
    return CreatePasscodeResponse(
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
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
