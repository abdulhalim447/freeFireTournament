import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/models/category_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/utils/urls.dart';

class CategoryProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<CategoryItem> _categories = [];
  int _selectedCategoryIndex = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CategoryItem> get categories => _categories;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  // Get the currently selected category
  CategoryItem? get selectedCategory {
    if (_categories.isEmpty) return null;
    if (_selectedCategoryIndex >= _categories.length) {
      return _categories.first;
    }
    return _categories[_selectedCategoryIndex];
  }

  // Fetch category data
  Future<void> fetchCategories() async {
    debugPrint('=== CategoryProvider: Starting fetchCategories ===');
    _setLoading(true);
    _clearError();

    try {
      final response = await NetworkCaller.getRequest(URLs.topCategory);

      debugPrint('=== CategoryProvider: Response received ===');
      debugPrint('Status code: ${response.statusCode}');

      if (response.isSuccess) {
        final categoryResponse = CategoryResponse.fromJson(
          response.responsData,
        );
        _categories = categoryResponse.category;

        debugPrint('=== Categories fetched: ${_categories.length} ===');
        for (var item in _categories) {
          debugPrint('Category: ${item.id} - ${item.name} - ${item.image}');
        }

        // Reset selected index if it's out of bounds
        if (_selectedCategoryIndex >= _categories.length &&
            _categories.isNotEmpty) {
          _selectedCategoryIndex = 0;
        }
      } else {
        _setError('Failed to load categories: ${response.errorMessage}');
        debugPrint(
          '=== Error loading categories: ${response.errorMessage} ===',
        );
      }
    } catch (e) {
      _setError('Error loading categories: ${e.toString()}');
      debugPrint('=== Exception during fetchCategories: ${e.toString()} ===');
    } finally {
      _setLoading(false);
    }
  }

  // Select a category by index
  void selectCategory(int index) {
    if (index >= 0 && index < _categories.length) {
      _selectedCategoryIndex = index;
      notifyListeners();
    }
  }

  // Select a category by ID
  void selectCategoryById(int categoryId) {
    final index = _categories.indexWhere(
      (category) => category.id == categoryId,
    );
    if (index != -1) {
      _selectedCategoryIndex = index;
      notifyListeners();
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchCategories();
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
