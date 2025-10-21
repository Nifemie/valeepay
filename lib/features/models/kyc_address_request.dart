class KycAddressRequest {
  final String? state;
  final String? lga;
  final String? houseAddress;
  final String? landmark;
  final String? bvn;

  const KycAddressRequest({
    this.state,
    this.lga,
    this.houseAddress,
    this.landmark,
    this.bvn,
  });

  KycAddressRequest copyWith({
    String? state,
    String? lga,
    String? houseAddress,
    String? landmark,
    String? bvn,
  }) {
    return KycAddressRequest(
      state: state ?? this.state,
      lga: lga ?? this.lga,
      houseAddress: houseAddress ?? this.houseAddress,
      landmark: landmark ?? this.landmark,
      bvn: bvn ?? this.bvn,
    );
  }

  factory KycAddressRequest.fromJson(Map<String, dynamic> json) {
    return KycAddressRequest(
      state: json['state'],
      lga: json['lga'],
      houseAddress: json['houseAddress'],
      landmark: json['landmark'],
      bvn: json['bvn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'lga': lga,
      'houseAddress': houseAddress,
      'landmark': landmark,
      'bvn': bvn,
    };
  }
}
