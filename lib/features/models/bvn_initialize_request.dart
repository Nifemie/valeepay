class BvnInitializeRequest {
  final String bvn;

  BvnInitializeRequest({required this.bvn});

  Map<String, dynamic> toJson() => {
        'bvn': bvn,
      };
}
