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

class BalanceModel {
  final String balance;

  BalanceModel({required this.balance});

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(balance: json['balance'] ?? '0.00');
  }
}

class UserProfileModel {
  final bool status;
  final UserData user;

  UserProfileModel({required this.status, required this.user});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      status: json['status'] == 'success',
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String username;
  final String balance;
  final String phone;
  final String? avatar;
  final int isActive;
  final String referralCode;
  final String? referralCodeUsed;
  final int totalPlayed;
  final int totalWon;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.balance,
    required this.phone,
    this.avatar,
    required this.isActive,
    required this.referralCode,
    this.referralCodeUsed,
    required this.totalPlayed,
    required this.totalWon,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      balance: json['balance'],
      phone: json['phone'],
      avatar: json['avatar'],
      isActive: json['is_active'],
      referralCode: json['referral_code'],
      referralCodeUsed: json['referral_code_used'],
      totalPlayed: json['total_played'],
      totalWon: json['total_won'],
    );
  }
}
