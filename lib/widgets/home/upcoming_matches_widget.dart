import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/models/home_data_response.dart';
import 'package:tournament_app/providers/home_provider.dart';
import 'package:tournament_app/screens/subcategory_matches_screen.dart';

class UpcomingMatchesWidget extends StatelessWidget {
  const UpcomingMatchesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final categoryMatches = homeProvider.categoryMatches;
        final isLoading = homeProvider.isCategoryMatchesLoading;
        final error = homeProvider.categoryMatchesError;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              const SizedBox(height: 16),

              // Display categories or loading/error state
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(color: Color(0xFF54A9EB)),
                  ),
                )
              else if (error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF312E56),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        'Error loading matches: $error',
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                )
              else if (categoryMatches.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF312E56),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        'No match categories available',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),
                )
              else
                // Display all categories
                Column(
                  children:
                      categoryMatches.map((category) {
                        return _buildCategorySection(context, category);
                      }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(BuildContext context, CategoryMatch category) {
    if (category.subCategories.isEmpty) {
      return const SizedBox.shrink(); // Don't show categories with no subcategories
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sub-categories grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85, // Adjusted to match the screenshot
            ),
            itemCount: category.subCategories.length,
            itemBuilder: (context, index) {
              final subCategory = category.subCategories[index];
              return _buildSubCategoryCard(context, subCategory);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryCard(BuildContext context, SubCategory subCategory) {
    String totalMatches =
        subCategory.totalMatches?.toString() ??
        (subCategory.matches.isNotEmpty
            ? subCategory.matches.length.toString()
            : '0');

    return GestureDetector(
      onTap: () {
        // Navigate to subcategory matches screen with the subcategory ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SubcategoryMatchesScreen(
                  subcategoryId: subCategory.id,
                  title: subCategory.name,
                  image: subCategory.image,
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF312E56),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top - full width
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child:
                  subCategory.image.isNotEmpty
                      ? Image.network(
                        subCategory.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 120,
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                Icons.sports_esports,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        width: double.infinity,
                        height: 120,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.sports_esports,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      ),
            ),

            // Name and match count at the bottom
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    subCategory.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Match count
                  Text(
                    '$totalMatches matches found',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
