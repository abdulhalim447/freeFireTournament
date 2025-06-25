import 'package:flutter/material.dart';
import '../models/subcategory_result_model.dart';
import '../network/network_caller.dart';
import '../network/network_response.dart';
import '../utils/urls.dart';

class ResultProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<SubCategory> _subCategories = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<SubCategory> get subCategories => _subCategories;

  Future<bool> getResultTopTitles() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      URLs.resultTopTitleUrl,
    );

    _isLoading = false;

    if (response.isSuccess) {
      final SubCategoryResultModel resultModel =
          SubCategoryResultModel.fromJson(response.responsData);
      _subCategories = resultModel.subCategories;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.errorMessage ?? 'Something went wrong';
      notifyListeners();
      return false;
    }
  }
}
