import 'package:flutter/material.dart';
import 'package:tournament_app/models/subcategory_matches_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/utils/urls.dart';

class SubcategoryMatchesProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<SubcategoryMatch> _matches = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<SubcategoryMatch> get matches => _matches;

  // Method to fetch subcategory matches
  Future<bool> fetchSubcategoryMatches(int subcategoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String url = '${URLs.matchBySubcategory}$subcategoryId';
      debugPrint('Fetching matches from: $url');

      NetworkResponse response = await NetworkCaller.getRequest(
        url,
        requiresAuth: false,
      );

      _isLoading = false;

      if (response.isSuccess) {
        final matchesData = SubcategoryMatchesModel.fromJson(
          response.responsData,
        );
        _matches = matchesData.data;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Failed to load matches';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Method to clear data when no longer needed
  void clearMatches() {
    _matches = [];
    _error = null;
    notifyListeners();
  }
}
