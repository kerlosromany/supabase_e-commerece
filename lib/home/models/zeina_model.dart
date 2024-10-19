class ZeinaModel {
  final int id;
  final String createdAt;
  final String productName;
  final int productPrice;
  final String productImageUrl;
  final bool productAvailable;

  ZeinaModel({
    required this.id,
    required this.createdAt,
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.productAvailable,
  });



  factory ZeinaModel.fromJson(Map<String, dynamic> json) {
    return ZeinaModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']).toString(),
      productName: json['productName'],
      productPrice: json['productPrice'],
      productImageUrl: json['productImageUrl'],
      productAvailable: json['productAvailable'],
    );
  }
}
