import 'dart:convert';

class TodayMatchesModel {
  final List<TodayMatch> todayMatches;

  TodayMatchesModel({required this.todayMatches});

  factory TodayMatchesModel.fromJson(Map<String, dynamic> json) {
    return TodayMatchesModel(
      todayMatches:
          (json['todayMatches'] as List)
              .map((match) => TodayMatch.fromJson(match))
              .toList(),
    );
  }
}

class TodayMatch {
  final int id;
  final String matchTitle;
  final String matchStartTime;
  final String matchStartDate;
  final int totalPrize;
  final int entryFee;
  final List<String> entryType;
  final String version;

  TodayMatch({
    required this.id,
    required this.matchTitle,
    required this.matchStartTime,
    required this.matchStartDate,
    required this.totalPrize,
    required this.entryFee,
    required this.entryType,
    required this.version,
  });

  factory TodayMatch.fromJson(Map<String, dynamic> json) {
    return TodayMatch(
      id: json['id'] ?? 0,
      matchTitle: json['match_title'] ?? '',
      matchStartTime: json['match_start_time'] ?? '',
      matchStartDate: json['match_start_date'] ?? '',
      totalPrize: json['total_prize'] ?? 0,
      entryFee: json['entry_fee'] ?? 0,
      entryType: List<String>.from(json['entry_type'] ?? []),
      version: json['version'] ?? '',
    );
  }
}
