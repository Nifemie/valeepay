class KycAddressRequest {
  final String? state;
  final String? lga;
  final String? area;
  final String? houseAddress;
  final String? landmark;
  final String? houseDescription;
  final String? bvn;
  final String? proofOfAddressImage;

  const KycAddressRequest({
    this.state,
    this.lga,
    this.area,
    this.houseAddress,
    this.landmark,
    this.houseDescription,
    this.bvn,
    this.proofOfAddressImage,
  });

  KycAddressRequest copyWith({
    String? state,
    String? lga,
    String? area,
    String? houseAddress,
    String? landmark,
    String? houseDescription,
    String? bvn,
    String? proofOfAddressImage,
  }) {
    return KycAddressRequest(
      state: state ?? this.state,
      lga: lga ?? this.lga,
      area: area ?? this.area,
      houseAddress: houseAddress ?? this.houseAddress,
      landmark: landmark ?? this.landmark,
      houseDescription: houseDescription ?? this.houseDescription,
      bvn: bvn ?? this.bvn,
      proofOfAddressImage: proofOfAddressImage ?? this.proofOfAddressImage,
    );
  }

  factory KycAddressRequest.fromJson(Map<String, dynamic> json) {
    return KycAddressRequest(
      state: json['state'],
      lga: json['lga'],
      area: json['area'],
      houseAddress: json['houseAddress'],
      landmark: json['landmark'],
      houseDescription: json['houseDescription'],
      bvn: json['bvn'],
      proofOfAddressImage: json['proofOfAddressImage'],
    );
  }

  Map<String, dynamic> toJson() {
    // Format for API: city (area), state, address (combined address fields)
    final addressParts = <String>[];
    
    if (houseAddress?.isNotEmpty ?? false) {
      addressParts.add(houseAddress!);
    }
    if (landmark?.isNotEmpty ?? false) {
      addressParts.add(landmark!);
    }
    if (houseDescription?.isNotEmpty ?? false) {
      addressParts.add(houseDescription!);
    }
    
    final fullAddress = addressParts.join(', ');

    return {
      'city': area ?? '',
      'state': state ?? '',
      'address': fullAddress.isNotEmpty ? fullAddress : houseAddress ?? '',
    };
  }

  // Keep the full data for internal use
  Map<String, dynamic> toFullJson() {
    return {
      'state': state,
      'lga': lga,
      'area': area,
      'houseAddress': houseAddress,
      'landmark': landmark,
      'houseDescription': houseDescription,
      'bvn': bvn,
      'proofOfAddressImage': proofOfAddressImage,
    };
  }
}
