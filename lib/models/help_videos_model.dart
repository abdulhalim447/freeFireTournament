class HelpVideosModel {
  final bool status;
  final VideoLink videoLink;

  HelpVideosModel({required this.status, required this.videoLink});

  factory HelpVideosModel.fromJson(Map<String, dynamic> json) {
    return HelpVideosModel(
      status: json['status'] == 'success',
      videoLink: VideoLink.fromJson(json['video_link']),
    );
  }
}

class VideoLink {
  final int id;
  final String videoOne;
  final String videoTwo;
  final String videoThree;
  final String createdAt;
  final String updatedAt;

  VideoLink({
    required this.id,
    required this.videoOne,
    required this.videoTwo,
    required this.videoThree,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoLink.fromJson(Map<String, dynamic> json) {
    return VideoLink(
      id: json['id'],
      videoOne: json['video_one'],
      videoTwo: json['video_two'],
      videoThree: json['video_three'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
