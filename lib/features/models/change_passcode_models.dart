class ChangePasscodeRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasscodeRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
}

class ChangePasscodeResponse {
  final String message;
  final int statusCode;

  ChangePasscodeResponse({
    required this.message,
    required this.statusCode,
  });

  factory ChangePasscodeResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasscodeResponse(
        message: json['message'] ?? 'Password updated successfully',
        statusCode: json['statusCode'] ?? 200,
      );
}
