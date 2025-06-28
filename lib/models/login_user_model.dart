class User {
  int? id;
  String? name;
  String? email;
  String? username;
  String? balance;
  String? phone;
  String? avatar;
  bool? isActive;
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

    // Handle both boolean and integer values for is_active
    if (json['is_active'] is bool) {
      isActive = json['is_active'];
    } else if (json['is_active'] is int) {
      isActive = json['is_active'] == 1;
    } else {
      isActive = false;
    }

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
