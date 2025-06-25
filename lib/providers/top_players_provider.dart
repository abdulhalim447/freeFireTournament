import 'package:flutter/material.dart';
import 'package:tournament_app/models/top_player_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/utils/urls.dart';

class TopPlayersProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<TopPlayer> _topPlayers = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<TopPlayer> get topPlayers => _topPlayers;

  Future<bool> getTopPlayers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    NetworkResponse response = await NetworkCaller.getRequest(
      URLs.topPlayerListUrl,
    );

    _isLoading = false;

    if (response.isSuccess) {
      try {
        _topPlayers =
            (response.responsData as List)
                .map((item) => TopPlayer.fromJson(item))
                .toList();
        notifyListeners();
        return true;
      } catch (e) {
        _errorMessage = 'Failed to parse response data';
        notifyListeners();
        return false;
      }
    } else {
      _errorMessage = 'Failed to fetch top players';
      notifyListeners();
      return false;
    }
  }
}
