class User {
  int? id;
  String? name;
  String? email;
  String? username;
  String? balance;
  String? phone;
  String? avatar;
  int? isActive;
  String? referralCode;
  String? referralCodeUsed;

  User({
    this.id,
    this.name,
    this.email,
    this.username,
    this.balance,
    this.phone,
    this.avatar,
    this.isActive,
    this.referralCode,
    this.referralCodeUsed,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    balance = json['balance'];
    phone = json['phone'];
    avatar = json['avatar'];
    isActive = json['is_active'];
    referralCode = json['referral_code'];
    referralCodeUsed = json['referral_code_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['balance'] = balance;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['is_active'] = isActive;
    data['referral_code'] = referralCode;
    data['referral_code_used'] = referralCodeUsed;
    return data;
  }

  // Getter for backward compatibility
  String? get userName => name;
}
