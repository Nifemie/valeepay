class GenerateQrResponse {
  final String data; // expected to be a data URI (data:image/png;base64,...)
  final String message;
  final int statusCode;

  GenerateQrResponse(
      {required this.data, required this.message, required this.statusCode});

  factory GenerateQrResponse.fromJson(Map<String, dynamic> json) =>
      GenerateQrResponse(
        data: json['data']?.toString() ?? '',
        message: json['message'] ?? 'Success',
        statusCode: json['statusCode'] ?? 200,
      );
}
