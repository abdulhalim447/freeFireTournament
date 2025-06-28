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
      // Construct URL with subcategory ID as query parameter
      final url = '${URLs.gameResultUrl}?sub_category_id=$subcategoryId';

      debugPrint('Fetching result matches from: $url');
      final NetworkResponse response = await NetworkCaller.getRequest(url);

      _isLoading = false;

      if (response.isSuccess) {
        debugPrint('Result matches API response successful');
        // The API returns a direct array, not wrapped in a data field
        final resultData = response.responsData as List<dynamic>;
        final ResultMatchesModel model = ResultMatchesModel.fromJson(
          resultData,
        );
        _subcategoryMatches[subcategoryId] = model.data;

        debugPrint(
          'Parsed ${model.data.length} result matches for subcategory $subcategoryId',
        );
        notifyListeners();
        return true;
      } else {
        debugPrint('Result matches API failed: ${response.errorMessage}');
        _errorMessage =
            response.errorMessage ?? 'Failed to fetch result matches';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Exception in fetchResultMatches: $e');
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
