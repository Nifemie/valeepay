class UsernameRequest {
  final String? username;

  const UsernameRequest({
    this.username,
  });

  UsernameRequest copyWith({
    String? username,
  }) {
    return UsernameRequest(
      username: username ?? this.username,
    );
  }

  factory UsernameRequest.fromJson(Map<String, dynamic> json) {
    return UsernameRequest(
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }
}
