class JoinedMatchesModel {
  final String status;
  final List<JoinedMatch> matches;

  JoinedMatchesModel({required this.status, required this.matches});

  factory JoinedMatchesModel.fromJson(Map<String, dynamic> json) {
    return JoinedMatchesModel(
      status: json['status'] ?? '',
      matches:
          (json['matches'] as List?)
              ?.map((match) => JoinedMatch.fromJson(match))
              .toList() ??
          [],
    );
  }
}

class JoinedMatch {
  final int id;
  final int matchId;
  final int userId;
  final String matchTitle;
  final String player1Id;
  final String? player2Id;
  final String entryFee;
  final String categories;
  final String createdAt;

  JoinedMatch({
    required this.id,
    required this.matchId,
    required this.userId,
    required this.matchTitle,
    required this.player1Id,
    required this.player2Id,
    required this.entryFee,
    required this.categories,
    required this.createdAt,
  });

  factory JoinedMatch.fromJson(Map<String, dynamic> json) {
    return JoinedMatch(
      id: json['id'] ?? 0,
      matchId: json['match_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      matchTitle: json['match_title'] ?? '',
      player1Id: json['player1_id'] ?? '',
      player2Id: json['player2_id'],
      entryFee: json['entry_fee'] ?? '',
      categories: json['categories'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
