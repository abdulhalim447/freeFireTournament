import 'package:flutter/material.dart';
import 'package:tournament_app/models/help_videos_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/utils/urls.dart';

class HelpVideosProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HelpVideosModel? _helpVideosData;
  HelpVideosModel? get helpVideosData => _helpVideosData;

  // Individual video links for easy access
  String get addMoneyVideo => _helpVideosData?.videoLink.videoOne ?? '';
  String get roomIdVideo => _helpVideosData?.videoLink.videoTwo ?? '';
  String get joinMatchVideo => _helpVideosData?.videoLink.videoThree ?? '';

  Future<bool> fetchHelpVideos() async {
    _isLoading = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      URLs.helpVideoUrl,
    );

    _isLoading = false;

    debugPrint('Help Videos API Response: ${response.responsData}');

    if (response.isSuccess) {
      try {
        _helpVideosData = HelpVideosModel.fromJson(response.responsData);
        debugPrint('Video One: ${_helpVideosData?.videoLink.videoOne}');
        debugPrint('Video Two: ${_helpVideosData?.videoLink.videoTwo}');
        debugPrint('Video Three: ${_helpVideosData?.videoLink.videoThree}');
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Error parsing help videos: $e');
        notifyListeners();
        return false;
      }
    } else {
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _helpVideosData = null;
    notifyListeners();
  }
}
