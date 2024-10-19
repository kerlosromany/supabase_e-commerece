class OrderModel {
  int? orderId;
  String? createAt;
  String? userId;
  int? totalPrice;
  String? area;

  OrderModel({
    required this.orderId,
    required this.createAt,
    required this.userId,
    required this.totalPrice,
    required this.area,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['id'],
      createAt: DateTime.parse(json['created_at']).toString(),
      userId: json["user_id"],
      area: json["area"],
      totalPrice: json["total_price"],
    );
  }
}
