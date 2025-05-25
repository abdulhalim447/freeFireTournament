class UserBalanceModel {
  final double balance;

  UserBalanceModel({required this.balance});

  factory UserBalanceModel.fromJson(Map<String, dynamic> json) {
    return UserBalanceModel(balance: double.parse(json['balance'].toString()));
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance};
  }
}
