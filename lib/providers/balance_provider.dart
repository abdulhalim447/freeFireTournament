import 'package:flutter/material.dart';
import 'package:tournament_app/models/user_balance_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/utils/urls.dart';

class BalanceProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _balance = '0.00';
  String get balance => _balance;

  Future<bool> fetchBalance() async {
    _isLoading = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      URLs.balanceUrl,
      requiresAuth: true,
    );

    _isLoading = false;

    if (response.isSuccess) {
      final balanceData = BalanceModel.fromJson(response.responsData);
      _balance = balanceData.balance;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void updateBalance(String newBalance) {
    _balance = newBalance;
    notifyListeners();
  }

  void reset() {
    _balance = '0.00';
    notifyListeners();
  }
}
