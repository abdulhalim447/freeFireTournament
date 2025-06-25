import 'package:flutter/material.dart';
import 'package:tournament_app/models/bank_info_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/utils/urls.dart';

class BankInfoProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  BankInfoModel? _bankInfoModel;

  // Getters
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  BankInfoModel? get bankInfoModel => _bankInfoModel;

  // Get bank by name (bKash, Nagad, Rocket)
  BankInfo? getBankByName(String name) {
    if (_bankInfoModel == null) return null;

    try {
      return _bankInfoModel!.data.firstWhere(
        (bank) => bank.bankName.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get account number by bank name
  String getAccountNumber(String bankName) {
    final bank = getBankByName(bankName);
    return bank?.accountNumber ?? '';
  }

  // Fetch bank information from API
  Future<void> fetchBankInfo() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(URLs.mobileBankingUrl);

      if (response.isSuccess) {
        _bankInfoModel = BankInfoModel.fromJson(response.responsData);
      } else {
        _hasError = true;
        _errorMessage =
            response.errorMessage ?? 'Failed to load bank information';
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
