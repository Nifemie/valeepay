class BvnInitializeResponse {
  final String message;
  final int statusCode;
  final BvnInitializeData data;

  BvnInitializeResponse({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory BvnInitializeResponse.fromJson(Map<String, dynamic> json) =>
      BvnInitializeResponse(
        message: json['message'] ?? '',
        statusCode: json['statusCode'] ?? 0,
        data: BvnInitializeData.fromJson(json['data'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'statusCode': statusCode,
        'data': data.toJson(),
      };
}

class BvnInitializeData {
  final String verificationId;
  final String bvn;

  BvnInitializeData({
    required this.verificationId,
    required this.bvn,
  });

  factory BvnInitializeData.fromJson(Map<String, dynamic> json) =>
      BvnInitializeData(
        verificationId: json['verificationId'] ?? '',
        bvn: json['bvn'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'verificationId': verificationId,
        'bvn': bvn,
      };
}
