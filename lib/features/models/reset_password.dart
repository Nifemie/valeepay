class ResetPasswordRequest {
  final String? username;
  final String? password;
  final String? confirmPassword;

  const ResetPasswordRequest({
    this.username,
    this.password,
    this.confirmPassword,
  });

  ResetPasswordRequest copyWith({
    String? username,
    String? password,
    String? confirmPassword,
  }) {
    return ResetPasswordRequest(
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      username: json['username'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
