class SignUpModel {
  String name;
  String email;
  String username;
  String phone;
  String password;
  String passwordConfirmation;
  String referralCodeUsed;

  SignUpModel({
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.referralCodeUsed = 'REF12365',
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      name: json['name'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      password: json['password'],
      passwordConfirmation: json['password_confirmation'],
      referralCodeUsed: json['referral_code_used'] ?? 'REF12365',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'username': username,
    'phone': phone,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'referral_code_used': referralCodeUsed,
  };
}
