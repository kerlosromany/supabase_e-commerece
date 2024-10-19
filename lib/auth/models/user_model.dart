class UserModel {
  int? id;
  String? name;
  String? email;
  String? createdAt;
  String? address;
  String? phoneNumber;
  String? userId;
  String? area;
  double? lat;
  double? long;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.address,
    this.phoneNumber,
    this.userId,
    this.area,
    this.lat,
    this.long,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'area': area,
      'lat': lat,
      'long': long,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      userId: json['userId'],
      area: json['area'],
      lat: json['lat'],
      long: json['long'],
      createdAt: DateTime.parse(json['created_at']).toString()
    );
  }
}