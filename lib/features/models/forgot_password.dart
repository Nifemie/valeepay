class ForgotPasswordRequest {
  final String? username;

  const ForgotPasswordRequest({
    this.username,
  });

  ForgotPasswordRequest copyWith({
    String? username,
  }) {
    return ForgotPasswordRequest(
      username: username ?? this.username,
    );
  }

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequest(
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }
}
