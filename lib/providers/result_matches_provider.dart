import 'package:flutter/material.dart';
import '../models/result_match_model.dart';
import '../network/network_caller.dart';
import '../network/network_response.dart';
import '../utils/urls.dart';

class ResultMatchesProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<int, List<ResultMatch>> _subcategoryMatches = {};

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Get matches for a specific subcategory
  List<ResultMatch> getMatchesForSubcategory(int subcategoryId) {
    return _subcategoryMatches[subcategoryId] ?? [];
  }

  // Check if we have matches for this subcategory
  bool hasMatchesForSubcategory(int subcategoryId) {
    return _subcategoryMatches.containsKey(subcategoryId);
  }

  Future<bool> fetchResultMatches(int subcategoryId) async {
    // If we already have matches for this subcategory, return them
    if (_subcategoryMatches.containsKey(subcategoryId)) {
      return true;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Construct URL with subcategory ID as parameter
      final url = '${URLs.resultTopTitleUrl}/matches/$subcategoryId';

      final NetworkResponse response = await NetworkCaller.getRequest(url);

      _isLoading = false;

      if (response.isSuccess) {
        final ResultMatchesModel model = ResultMatchesModel.fromJson(
          response.responsData,
        );
        _subcategoryMatches[subcategoryId] = model.data;
        notifyListeners();
        return true;
      } else {
        _errorMessage =
            response.errorMessage ?? 'Failed to fetch result matches';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearAll() {
    _subcategoryMatches.clear();
    _errorMessage = '';
    notifyListeners();
  }
}
