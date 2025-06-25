class TopPlayer {
  final String teamName;
  final int userId;
  final String userName;
  final String totalPlacePoint;
  final String totalKillPoint;
  final String totalScore;
  final int matchesPlayed;

  TopPlayer({
    required this.teamName,
    required this.userId,
    required this.userName,
    required this.totalPlacePoint,
    required this.totalKillPoint,
    required this.totalScore,
    required this.matchesPlayed,
  });

  factory TopPlayer.fromJson(Map<String, dynamic> json) {
    return TopPlayer(
      teamName: json['team_name'] ?? '',
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      totalPlacePoint: json['total_place_point'] ?? '0',
      totalKillPoint: json['total_kill_point'] ?? '0',
      totalScore: json['total_score'] ?? '0',
      matchesPlayed: json['matches_played'] ?? 0,
    );
  }
}
