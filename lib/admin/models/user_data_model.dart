class UserDataModel {
  String? userName;
  String? userAddress;
  String? userPhoneNumber;

  UserDataModel({
    required this.userAddress,
    required this.userName,
    required this.userPhoneNumber,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      userAddress: json["address"],
      userName: json['name'],
      userPhoneNumber: json['phoneNumber'],
    );
  }
}
