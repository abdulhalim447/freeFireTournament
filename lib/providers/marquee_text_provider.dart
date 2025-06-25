import 'package:flutter/foundation.dart';
import 'package:tournament_app/models/marquee_text_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/utils/urls.dart';

class MarqueeTextProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TextSlider> _textSliders = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TextSlider> get textSliders => _textSliders;

  // For convenience in the UI
  String get marqueeText {
    if (_textSliders.isNotEmpty) {
      return _textSliders.map((slider) => slider.title).join(' | ');
    }
    return 'Welcome to the Tournament App!';
  }

  // Fetch marquee text data
  Future<void> fetchMarqueeText() async {
    debugPrint('=== MarqueeTextProvider: Starting fetchMarqueeText ===');
    _setLoading(true);
    _clearError();

    try {
      final response = await NetworkCaller.getRequest(URLs.marqueeTextUrl);

      debugPrint('=== MarqueeTextProvider: Response received ===');
      debugPrint('Status code: ${response.statusCode}');

      if (response.isSuccess) {
        final marqueeTextResponse = MarqueeTextResponse.fromJson(
          response.responsData,
        );
        _textSliders = marqueeTextResponse.textSlider;

        debugPrint('=== Text sliders fetched: ${_textSliders.length} ===');
        for (var item in _textSliders) {
          debugPrint('Text Slider: ${item.id} - ${item.title}');
        }
      } else {
        _setError('Failed to load marquee text: ${response.errorMessage}');
        debugPrint(
          '=== Error loading marquee text: ${response.errorMessage} ===',
        );
      }
    } catch (e) {
      _setError('Error loading marquee text: ${e.toString()}');
      debugPrint('=== Exception during fetchMarqueeText: ${e.toString()} ===');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchMarqueeText();
  }

  // Private helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
