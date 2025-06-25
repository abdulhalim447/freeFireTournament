import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/models/home_data_response.dart' as api;
import 'package:tournament_app/models/home_models.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/utils/urls.dart';

class HomeProvider extends ChangeNotifier {
  // State variables
  bool _isLoading = false;
  String? _error;

  // Data models from API
  api.HomeDataResponse? _homeData;
  int _selectedCategoryIndex = 0;
  List<api.TodayMatch> _todayMatches = [];
  bool _isTodayMatchesLoading = false;
  String? _todayMatchesError;

  // Category matches
  List<api.CategoryMatch> _categoryMatches = [];
  bool _isCategoryMatchesLoading = false;
  String? _categoryMatchesError;

  // Constructor
  HomeProvider();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  api.HomeDataResponse? get homeData => _homeData;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  // Today matches getters
  List<api.TodayMatch> get todayMatches => _todayMatches;
  bool get isTodayMatchesLoading => _isTodayMatchesLoading;
  String? get todayMatchesError => _todayMatchesError;

  // Category matches getters
  List<api.CategoryMatch> get categoryMatches => _categoryMatches;
  bool get isCategoryMatchesLoading => _isCategoryMatchesLoading;
  String? get categoryMatchesError => _categoryMatchesError;

  // Convenience getters for API data
  List<String> get sliderImages {
    // The API is now returning full URLs, so we don't need to add the base URL
    return _homeData?.imgSliders.map((slider) => slider.image).toList() ?? [];
  }

  List<api.TextSlider> get textSliders {
    return _homeData?.textSliders ?? [];
  }

  String get marqueeText {
    // Get text from the first text slider, or default if none
    return _homeData?.textSliders.isNotEmpty == true
        ? _homeData!.textSliders.first.title
        : 'Welcome to the Tournament App!';
  }

  List<api.TodayMatch> get apiTodayMatches {
    return _homeData?.todayMatches ?? [];
  }

  List<api.CategoryMatch> get apiCategoryMatches {
    return _homeData?.categoryMatches ?? [];
  }

  // Legacy getters for widget compatibility
  List<MatchCategory> get matchCategories {
    // Convert API categories to legacy MatchCategory objects
    if (_homeData == null) {
      // Default categories when API data is not available
      return [
        MatchCategory(
          id: 1,
          name: 'PUBG',
          color: const Color(0xFF5F31E2),
          isActive: true,
        ),
        MatchCategory(
          id: 2,
          name: 'FREE FIRE',
          color: const Color(0xFF5F31E2),
          isActive: false,
        ),
        MatchCategory(
          id: 3,
          name: 'LUDO',
          color: const Color(0xFF5F31E2),
          isActive: false,
        ),
        MatchCategory(
          id: 4,
          name: 'CLASH',
          color: const Color(0xFF5F31E2),
          isActive: false,
        ),
      ];
    }

    final categories = <MatchCategory>[];
    for (var i = 0; i < apiCategoryMatches.length; i++) {
      final category = apiCategoryMatches[i];
      categories.add(
        MatchCategory(
          id: category.id,
          name: category.name,
          image: category.image,
          color: const Color(0xFF5F31E2),
          isActive: i == _selectedCategoryIndex,
        ),
      );
    }
    return categories;
  }

  // Get the currently selected category
  api.CategoryMatch? get selectedCategory {
    if (apiCategoryMatches.isEmpty) return null;
    if (_selectedCategoryIndex >= apiCategoryMatches.length)
      return apiCategoryMatches.first;
    return apiCategoryMatches[_selectedCategoryIndex];
  }

  // Load today matches from API
  Future<void> fetchTodayMatches() async {
    debugPrint('=== HomeProvider: Starting fetchTodayMatches ===');
    _isTodayMatchesLoading = true;
    _todayMatchesError = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(URLs.todayMatchUrl);

      if (response.isSuccess) {
        debugPrint('=== Today matches API call successful ===');

        if (response.responsData != null) {
          // Check if response data contains a list
          if (response.responsData is List) {
            final List<dynamic> matchesJson = response.responsData;
            _todayMatches =
                matchesJson
                    .map((json) => api.TodayMatch.fromJson(json))
                    .toList();
          } else if (response.responsData['data'] != null &&
              response.responsData['data'] is List) {
            // Handle nested data structure if needed
            final List<dynamic> matchesJson = response.responsData['data'];
            _todayMatches =
                matchesJson
                    .map((json) => api.TodayMatch.fromJson(json))
                    .toList();
          } else {
            _todayMatches = [];
          }

          debugPrint('=== Parsed ${_todayMatches.length} today matches ===');
        } else {
          _todayMatches = [];
          debugPrint('=== No today matches data in response ===');
        }
      } else {
        _todayMatchesError = response.errorMessage;
        debugPrint('=== Error fetching today matches: $_todayMatchesError ===');
      }
    } catch (e) {
      _todayMatchesError = e.toString();
      debugPrint('=== Exception in fetchTodayMatches: $e ===');
    } finally {
      _isTodayMatchesLoading = false;
      notifyListeners();
    }
  }

  // Fetch category matches from API
  Future<void> fetchCategoryMatches() async {
    debugPrint('=== HomeProvider: Starting fetchCategoryMatches ===');
    _isCategoryMatchesLoading = true;
    _categoryMatchesError = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(URLs.matchCategoryUrl);

      if (response.isSuccess) {
        debugPrint('=== Category matches API call successful ===');

        if (response.responsData != null) {
          // Check if response data contains the categoryMatches
          if (response.responsData is List) {
            final List<dynamic> categoriesJson = response.responsData;
            _categoryMatches =
                categoriesJson
                    .map((json) => api.CategoryMatch.fromJson(json))
                    .toList();
          } else if (response.responsData['categoryMatches'] != null &&
              response.responsData['categoryMatches'] is List) {
            // Handle nested data structure if needed
            final List<dynamic> categoriesJson =
                response.responsData['categoryMatches'];
            _categoryMatches =
                categoriesJson
                    .map((json) => api.CategoryMatch.fromJson(json))
                    .toList();
          } else if (response.responsData['data'] != null &&
              response.responsData['data'] is List) {
            // Another possible structure
            final List<dynamic> categoriesJson = response.responsData['data'];
            _categoryMatches =
                categoriesJson
                    .map((json) => api.CategoryMatch.fromJson(json))
                    .toList();
          } else {
            _categoryMatches = [];
          }

          debugPrint(
            '=== Parsed ${_categoryMatches.length} category matches ===',
          );
          // Debug the structure
          if (_categoryMatches.isNotEmpty) {
            debugPrint('=== First category: ${_categoryMatches[0].name} ===');
            debugPrint(
              '=== Subcategories: ${_categoryMatches[0].subCategories.length} ===',
            );
            if (_categoryMatches[0].subCategories.isNotEmpty) {
              debugPrint(
                '=== First subcategory: ${_categoryMatches[0].subCategories[0].name} ===',
              );
            }
          }
        } else {
          _categoryMatches = [];
          debugPrint('=== No category matches data in response ===');
        }
      } else {
        _categoryMatchesError = response.errorMessage;
        debugPrint(
          '=== Error fetching category matches: $_categoryMatchesError ===',
        );
      }
    } catch (e) {
      _categoryMatchesError = e.toString();
      debugPrint('=== Exception in fetchCategoryMatches: $e ===');
    } finally {
      _isCategoryMatchesLoading = false;
      notifyListeners();
    }
  }

  // Load home data from API - This will be replaced by individual API calls
  Future<void> loadHomeData() async {
    debugPrint('=== HomeProvider: Starting loadHomeData ===');
    _setLoading(true);
    _clearError();

    try {
      // This method is now a placeholder for individual API calls
      // Each component will make its own API call

      // Set a short delay to simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Set empty data to avoid null errors
      _homeData = api.HomeDataResponse(
        imgSliders: [],
        textSliders: [],
        todayMatches: [],
        categoryMatches: [],
      );

      // Fetch today matches
      await fetchTodayMatches();

      // Fetch category matches
      await fetchCategoryMatches();

      _setLoading(false);
    } catch (e) {
      debugPrint('=== HomeProvider: Error loading data ===');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error: ${e.toString()}');
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Select a category by index
  void selectCategory(int index) {
    if (index >= 0 && index < apiCategoryMatches.length) {
      _selectedCategoryIndex = index;
      notifyListeners();
    }
  }

  // Select a category by ID
  void selectCategoryById(int categoryId) {
    final index = matchCategories.indexWhere(
      (category) => category.id == categoryId,
    );
    if (index != -1) {
      _selectedCategoryIndex = index;
      notifyListeners();
    }
  }

  // Add a refresh method
  Future<void> refreshData() async {
    // Optionally, clear existing data before reloading
    // _homeData = null;
    await loadHomeData();
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
