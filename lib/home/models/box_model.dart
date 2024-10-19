class BoxModel {
  final int id;
  final String createdAt;
  final String productName;
  final int productPrice;
  final int productWidth;
  final int productHeight;
  final int productHigh;
  final int productPieces;
  final String productCat;
  final String productImageUrl;
  final bool productAvailable;

  BoxModel({
    required this.id,
    required this.createdAt,
    required this.productName,
    required this.productPrice,
    required this.productWidth,
    required this.productHeight,
    required this.productHigh,
    required this.productPieces,
    required this.productCat,
    required this.productImageUrl,
    required this.productAvailable,
  });


  factory BoxModel.fromJson(Map<String, dynamic> json) {
    return BoxModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']).toString(),
      productName: json['productName'],
      productPrice: json['productPrice'],
      productWidth: json['productWidth'],
      productHeight: json['productHeight'],
      productHigh: json['productHigh'],
      productPieces: json['productPieces'],
      productCat: json['productCat'],
      productImageUrl: json['productImageUrl'],
      productAvailable: json['productAvailable'],
    );
  }
}
