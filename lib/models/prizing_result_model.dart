class PrizingResult {
  final int? id;
  final int? position;
  final int? matchId;
  final String? userName;
  final String? teamName;
  final int? totalKill;
  final int? prizeAmount;
  final String? createdAt;
  final String? updatedAt;

  PrizingResult({
    this.id,
    this.position,
    this.matchId,
    this.userName,
    this.teamName,
    this.totalKill,
    this.prizeAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory PrizingResult.fromJson(Map<String, dynamic> json) {
    return PrizingResult(
      id: json['id'],
      position: json['position'],
      matchId: json['match_id'],
      userName: json['user_name'],
      teamName: json['team_name'],
      totalKill: json['total_kill'],
      prizeAmount: json['prize_amount'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'match_id': matchId,
      'user_name': userName,
      'team_name': teamName,
      'total_kill': totalKill,
      'prize_amount': prizeAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
