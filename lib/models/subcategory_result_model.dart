class SubCategoryResultModel {
  final String message;
  final List<SubCategory> subCategories;

  SubCategoryResultModel({required this.message, required this.subCategories});

  factory SubCategoryResultModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryResultModel(
      message: json['message'] ?? '',
      subCategories:
          (json['subCategories'] as List?)
              ?.map((e) => SubCategory.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SubCategory {
  final int id;
  final String name;
  final String image;
  final int categoryId;
  final int totalMatches;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
    required this.totalMatches,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['category_id'] ?? 0,
      totalMatches: json['total_matches'] ?? 0,
    );
  }
}
