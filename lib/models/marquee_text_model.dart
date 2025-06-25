class MarqueeTextResponse {
  final List<TextSlider> textSlider;

  MarqueeTextResponse({required this.textSlider});

  factory MarqueeTextResponse.fromJson(Map<String, dynamic> json) {
    return MarqueeTextResponse(
      textSlider:
          (json['textSlider'] as List?)
              ?.map((e) => TextSlider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TextSlider {
  final int id;
  final String title;
  final String? createdAt;
  final String? updatedAt;

  TextSlider({
    required this.id,
    required this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory TextSlider.fromJson(Map<String, dynamic> json) {
    return TextSlider(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
