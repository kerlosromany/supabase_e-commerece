class WatchModel {
  final int id;
  final String createdAt;
  final String productName;
  final int productPrice;
  final String productImageUrl;
  final bool productAvailable;

  WatchModel({
    required this.id,
    required this.createdAt,
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.productAvailable,
  });



  factory WatchModel.fromJson(Map<String, dynamic> json) {
    return WatchModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']).toString(),
      productName: json['productName'],
      productPrice: json['productPrice'],
      productImageUrl: json['productImageUrl'],
      productAvailable: json['productAvailable'],
    );
  }
}
