import 'package:flutter/foundation.dart';
import 'package:tournament_app/models/image_slider_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/utils/urls.dart';

class ImageSliderProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<SliderItem> _sliderItems = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<SliderItem> get sliderItems => _sliderItems;

  // For convenience in the UI
  List<String> get sliderImages {
    return _sliderItems.map((slider) => slider.image).toList();
  }

  // Fetch image slider data
  Future<void> fetchImageSliders() async {
    debugPrint('=== ImageSliderProvider: Starting fetchImageSliders ===');
    _setLoading(true);
    _clearError();

    try {
      final response = await NetworkCaller.getRequest(URLs.imagesliderUrl);

      debugPrint('=== ImageSliderProvider: Response received ===');
      debugPrint('Status code: ${response.statusCode}');

      if (response.isSuccess) {
        final imageSliderResponse = ImageSliderResponse.fromJson(
          response.responsData,
        );
        _sliderItems = imageSliderResponse.imgSlider;

        debugPrint('=== Slider items fetched: ${_sliderItems.length} ===');
        for (var item in _sliderItems) {
          debugPrint('Slider: ${item.title} - ${item.image}');
        }
      } else {
        _setError('Failed to load image sliders: ${response.errorMessage}');
        debugPrint(
          '=== Error loading image sliders: ${response.errorMessage} ===',
        );
      }
    } catch (e) {
      _setError('Error loading slider images: ${e.toString()}');
      debugPrint('=== Exception during fetchImageSliders: ${e.toString()} ===');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchImageSliders();
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
