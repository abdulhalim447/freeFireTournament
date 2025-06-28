import 'package:tournament_app/models/login_user_model.dart';

class SignUpResponseModel {
  String? status;
  String? message;
  User? user;
  String? accessToken;
  String? tokenType;

  SignUpResponseModel({
    this.status,
    this.message,
    this.user,
    this.accessToken,
    this.tokenType,
  });

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    return data;
  }

  // Helper getter to check if signup was successful
  bool get isSuccess => status == 'success';
}
