class CategoryResponse {
  final List<CategoryItem> category;

  CategoryResponse({required this.category});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      category:
          (json['category'] as List?)
              ?.map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CategoryItem {
  final int id;
  final String name;
  final String image;

  CategoryItem({required this.id, required this.name, required this.image});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}
