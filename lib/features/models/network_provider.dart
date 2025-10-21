class NetworkProvider {
  final String id;
  final String planName;
  final String network;
  final String countryISOCode;
  final int operatorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NetworkProvider({
    required this.id,
    required this.planName,
    required this.network,
    required this.countryISOCode,
    required this.operatorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NetworkProvider.fromJson(Map<String, dynamic> json) =>
      NetworkProvider(
        id: json['id']?.toString() ?? '',
        planName: json['planName'] ?? '',
        network: json['network'] ?? '',
        countryISOCode: json['countryISOCode'] ?? '',
        operatorId: json['operatorId'] ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'planName': planName,
        'network': network,
        'countryISOCode': countryISOCode,
        'operatorId': operatorId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class NetworkProvidersResponse {
  final List<NetworkProvider> providers;
  final String message;
  final int statusCode;

  NetworkProvidersResponse({
    required this.providers,
    required this.message,
    required this.statusCode,
  });

  factory NetworkProvidersResponse.fromJson(Map<String, dynamic> json) {
    List<NetworkProvider> providersList = [];

    if (json['data'] != null && json['data'] is List) {
      providersList = (json['data'] as List)
          .map((provider) => NetworkProvider.fromJson(provider))
          .toList();
    }

    return NetworkProvidersResponse(
      providers: providersList,
      message: json['message'] ?? 'Success',
      statusCode: json['statusCode'] ?? 200,
    );
  }
}
