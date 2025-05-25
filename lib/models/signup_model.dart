class SignUpModel {
  String userName;
  String email;
  String mobileNumber;
  String password;
  String reffer;

  SignUpModel({
    required this.userName,
    required this.email,
    required this.mobileNumber,
    required this.password,
    this.reffer = '',
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      userName: json['user_name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      password: json['password'],
      reffer: json['reffer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_name': userName,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password,
        'reffer': reffer,
      };
}


