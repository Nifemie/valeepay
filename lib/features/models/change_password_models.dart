class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
}

class ChangePasswordResponse {
  final String message;
  final int statusCode;

  ChangePasswordResponse({
    required this.message,
    required this.statusCode,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponse(
        message: json['message'] ?? 'Password updated successfully',
        statusCode: json['statusCode'] ?? 200,
      );
}
