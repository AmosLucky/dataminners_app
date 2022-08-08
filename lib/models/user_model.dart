class UserModel {
  String id, username, suspended, phoneNumber, email, balance;
  String accessToken;
  String password = "";
  String isVerified;
  UserModel(
      {required this.id,
      required this.username,
      required this.isVerified,
      required this.suspended,
      required this.phoneNumber,
      required this.email,
      required this.balance,
      required this.accessToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        isVerified: json['isVerified'],
        id: json['id'],
        username: json['username'],
        balance: json['balance'],
        suspended: json['suspended'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        accessToken: json['accessToken']);
  }
}
