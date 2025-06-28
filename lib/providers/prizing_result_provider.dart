import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/prizing_result_model.dart';
import '../network/network_caller.dart';
import '../utils/urls.dart';

class PrizingResultProvider extends ChangeNotifier {
  List<PrizingResult> _prizingResult = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<PrizingResult> get prizingResult => _prizingResult;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPrizingResult(int matchId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        '${URLs.prizingUrl}$matchId',
      );

      if (response.isSuccess) {
        final jsonData = response.responsData;

        if (jsonData['status'] == true) {
          final List<dynamic> resultList = jsonData['data'] ?? [];

          _prizingResult =
              resultList.map((item) => PrizingResult.fromJson(item)).toList();

          // Sort by position (if available) or prize amount (descending)
          _prizingResult.sort((a, b) {
            if (a.position != null && b.position != null) {
              return a.position!.compareTo(b.position!);
            } else if (a.prizeAmount != null && b.prizeAmount != null) {
              return b.prizeAmount!.compareTo(a.prizeAmount!);
            } else {
              return 0;
            }
          });
        } else {
          _errorMessage = jsonData['message'] ?? 'Failed to load results';
          _prizingResult = [];
        }
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to load results';
        _prizingResult = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
      _prizingResult = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _prizingResult = [];
    _errorMessage = '';
    notifyListeners();
  }
}
