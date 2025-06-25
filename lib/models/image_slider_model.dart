class ImageSliderResponse {
  final List<SliderItem> imgSlider;

  ImageSliderResponse({required this.imgSlider});

  factory ImageSliderResponse.fromJson(Map<String, dynamic> json) {
    return ImageSliderResponse(
      imgSlider:
          (json['imgSlider'] as List?)
              ?.map((e) => SliderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SliderItem {
  final int id;
  final String title;
  final String image;
  final String? link;
  final String? createdAt;
  final String? updatedAt;

  SliderItem({
    required this.id,
    required this.title,
    required this.image,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      link: json['link'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
