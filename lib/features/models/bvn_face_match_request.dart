import 'dart:convert';
import 'package:http/http.dart' as http;

class BvnFaceMatchRequest {
  final String idNumber; // BVN or identification number
  final String? photoBase64; // Base64 string of the selfie image

  BvnFaceMatchRequest({
    required this.idNumber,
    this.photoBase64,
  });

  /// For JSON-based APIs
  Map<String, dynamic> toJson() {
    return {
      'idNumber': idNumber,
      if (photoBase64 != null) 'photobase64': photoBase64,
    };
  }

  String toJsonString() => json.encode(toJson());

  Future<http.MultipartRequest> toMultipartRequest(String url) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['idNumber'] = idNumber;

    if (photoBase64 != null) {
      request.fields['photobase64'] = photoBase64!;
    }

    return request;
  }
}
