import 'package:flutter/material.dart';
import 'package:tournament_app/models/user_balance_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/utils/urls.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProfileModel? _profileData;
  UserProfileModel? get profileData => _profileData;

  Future<bool> getUserProfile() async {
    _isLoading = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      URLs.profileUrl,
      requiresAuth: true,
    );

    _isLoading = false;

    if (response.isSuccess) {
      _profileData = UserProfileModel.fromJson(response.responsData);
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _profileData = null;
    notifyListeners();
  }
}
