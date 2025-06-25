import 'package:flutter/material.dart';
import 'package:tournament_app/models/today_matches_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/utils/urls.dart';

class TodayMatchesProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  List<TodayMatch> _matches = [];

  bool get isLoading => _isLoading;
  String get error => _error;
  List<TodayMatch> get matches => _matches;

  Future<bool> getTodayMatches() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      NetworkResponse response = await NetworkCaller.getRequest(
        URLs.todayMatchUrl,
        requiresAuth: true,
      );

      _isLoading = false;

      if (response.isSuccess) {
        final matchesData = TodayMatchesModel.fromJson(response.responsData);
        _matches = matchesData.todayMatches;
        _error = '';
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
}
