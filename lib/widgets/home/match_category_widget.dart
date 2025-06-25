import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/providers/category_provider.dart';
import 'package:tournament_app/screens/subcategory_matches_screen.dart';

class MatchCategoryWidget extends StatefulWidget {
  const MatchCategoryWidget({Key? key}) : super(key: key);

  @override
  State<MatchCategoryWidget> createState() => _MatchCategoryWidgetState();
}

class _MatchCategoryWidgetState extends State<MatchCategoryWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('=== MatchCategoryWidget: Loading categories ===');
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return _buildLoadingState();
        }

        if (categoryProvider.error != null) {
          return _buildErrorState(categoryProvider);
        }

        if (categoryProvider.categories.isEmpty) {
          return _buildEmptyState();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              const Text(
                'Match Category',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Category Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      categoryProvider.categories.asMap().entries.map((entry) {
                        int index = entry.key;
                        var category = entry.value;
                        bool isSelected =
                            index == categoryProvider.selectedCategoryIndex;

                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildCategoryButton(
                            context,
                            category.name,
                            category.image,
                            isSelected,
                            () => categoryProvider.selectCategory(index),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Match Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: SizedBox(
              height: 60,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF54A9EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(CategoryProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Match Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load categories',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  TextButton(
                    onPressed: () => provider.fetchCategories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Match Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const SizedBox(
            height: 60,
            child: Center(
              child: Text(
                'No categories available',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String name,
    String imageUrl,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final Color activeColor = const Color(0xFF5F31E2);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return GestureDetector(
      onTap: () {
        onTap();

        // Get the selected category after tap
        final selectedCategory = categoryProvider.selectedCategory;
        if (selectedCategory != null) {
          // Navigate to subcategory matches screen with the category ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SubcategoryMatchesScreen(
                    subcategoryId: selectedCategory.id,
                    title: selectedCategory.name,
                    image: selectedCategory.image ?? '',
                  ),
            ),
          );
        }
      },
      child: Column(
        children: [
          // Circular Button
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? activeColor : activeColor.withOpacity(0.3),
              border:
                  isSelected
                      ? Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      )
                      : null,
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: activeColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child:
                  imageUrl.isNotEmpty
                      ? ClipOval(
                        child: Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _getCategoryIcon(name, isSelected),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      )
                      : _getCategoryIcon(name, isSelected),
            ),
          ),

          const SizedBox(height: 8),

          // Category Name
          Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String categoryName, bool isSelected) {
    IconData iconData;
    double iconSize = 24;

    switch (categoryName.toUpperCase()) {
      case 'PUBG':
        iconData = Icons.sports_esports;
        break;
      case 'FREE FIRE':
        iconData = Icons.local_fire_department;
        break;
      case 'LUDO':
        iconData = Icons.casino;
        break;
      case 'CLASH':
        iconData = Icons.flash_on;
        break;
      default:
        iconData = Icons.games;
    }

    return Icon(
      iconData,
      size: iconSize,
      color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
    );
  }
}
