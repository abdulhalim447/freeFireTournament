import 'package:tournament_app/models/login_user_model.dart';

class SignUpResponseModel {
  bool? success;
  String? message;
  User? user;
  String? accessToken;
  String? tokenType;

  SignUpResponseModel({
    this.success,
    this.message,
    this.user,
    this.accessToken,
    this.tokenType,
  });

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    return data;
  }

  // Helper getter to check if signup was successful
  bool get isSuccess => success == true;
}
