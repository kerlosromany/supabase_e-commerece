class BagModel {
  final int id;
  final String createdAt;
  final String productName;
  final int productPrice;
  final int productWidth;
  final int productHeight;
  final String productCat;
  final String productImageUrl;
  final bool productAvailable;

  BagModel({
    required this.id,
    required this.createdAt,
    required this.productName,
    required this.productPrice,
    required this.productWidth,
    required this.productHeight,
    required this.productCat,
    required this.productImageUrl,
    required this.productAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productWidth': productWidth,
      'productHeight': productHeight,
      'productCat': productCat,
      'productImageUrl': productImageUrl,
      'productAvailable': productAvailable,
    };
  }

  factory BagModel.fromJson(Map<String, dynamic> json) {
    return BagModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']).toString(),
      productName: json['productName'],
      productPrice: json['productPrice'],
      productWidth: json['productWidth'],
      productHeight: json['productHeight'],
      productCat: json['productCat'],
      productImageUrl: json['productImageUrl'],
      productAvailable: json['productAvailable'],
    );
  }
}
