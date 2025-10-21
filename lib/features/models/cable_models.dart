// Models for Cable TV endpoints
class CablePlanInfo {
  final String id;
  final String planName;
  final String countryISOCode;
  final String billerCode;

  CablePlanInfo({
    required this.id,
    required this.planName,
    required this.countryISOCode,
    required this.billerCode,
  });

  factory CablePlanInfo.fromJson(Map<String, dynamic> json) => CablePlanInfo(
        id: json['id']?.toString() ?? '',
        planName: json['planName'] ?? '',
        countryISOCode: json['countryISOCode'] ?? '',
        billerCode: json['billerCode'] ?? '',
      );
}

class CablePlanResponse {
  final List<CablePlanInfo> data;
  final String message;
  final int statusCode;

  CablePlanResponse({
    required this.data,
    required this.message,
    required this.statusCode,
  });

  factory CablePlanResponse.fromJson(Map<String, dynamic> json) {
    final list = <CablePlanInfo>[];
    if (json['data'] != null && json['data'] is List) {
      list.addAll((json['data'] as List)
          .map((e) => CablePlanInfo.fromJson(e as Map<String, dynamic>)));
    }
    return CablePlanResponse(
      data: list,
      message: json['message'] ?? 'Success',
      statusCode: json['statusCode'] ?? 200,
    );
  }
}

class CableVariationInfo {
  final int id;
  final String billerCode;
  final String name;
  final double fee;
  final String itemCode;
  final String labelName;
  final double amount;
  final bool isResolvable;
  final double? payAmount;

  CableVariationInfo({
    required this.id,
    required this.billerCode,
    required this.name,
    required this.fee,
    required this.itemCode,
    required this.labelName,
    required this.amount,
    required this.isResolvable,
    this.payAmount,
  });

  factory CableVariationInfo.fromJson(Map<String, dynamic> json) =>
      CableVariationInfo(
        id: json['id'] ?? 0,
        billerCode: json['biller_code'] ?? json['billerCode'] ?? '',
        name: json['name'] ?? '',
        fee: (json['fee'] ?? 0).toDouble(),
        itemCode: json['item_code'] ?? json['itemCode'] ?? '',
        labelName: json['label_name'] ?? json['labelName'] ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
        isResolvable: json['is_resolvable'] ?? json['isResolvable'] ?? false,
        payAmount: json['payAmount'] != null
            ? (json['payAmount'] as num).toDouble()
            : null,
      );
}

class CableVariationResponse {
  final List<CableVariationInfo> data;
  final String message;
  final int statusCode;

  CableVariationResponse({
    required this.data,
    required this.message,
    required this.statusCode,
  });

  factory CableVariationResponse.fromJson(Map<String, dynamic> json) {
    final list = <CableVariationInfo>[];
    if (json['data'] != null && json['data'] is List) {
      list.addAll((json['data'] as List)
          .map((e) => CableVariationInfo.fromJson(e as Map<String, dynamic>)));
    }
    return CableVariationResponse(
      data: list,
      message: json['message'] ?? 'Success',
      statusCode: json['statusCode'] ?? 200,
    );
  }
}

class VerifyCableRequest {
  final String itemCode;
  final String billerCode;
  final String billerNumber;

  VerifyCableRequest({
    required this.itemCode,
    required this.billerCode,
    required this.billerNumber,
  });

  Map<String, dynamic> toJson() => {
        'itemCode': itemCode,
        'billerCode': billerCode,
        'billerNumber': billerNumber,
      };
}

class CablePayRequest {
  final String itemCode;
  final String billerCode;
  final String currency;
  final String billerNumber;
  final double amount;

  CablePayRequest({
    required this.itemCode,
    required this.billerCode,
    required this.currency,
    required this.billerNumber,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'itemCode': itemCode,
        'billerCode': billerCode,
        'currency': currency,
        'billerNumber': billerNumber,
        'amount': amount,
      };
}

class CablePaymentResponse {
  final String message;
  final int statusCode;

  CablePaymentResponse({required this.message, required this.statusCode});

  factory CablePaymentResponse.fromJson(Map<String, dynamic> json) =>
      CablePaymentResponse(
        message: json['message'] ?? 'Success',
        statusCode: json['statusCode'] ?? 200,
      );
}
