import 'dart:convert';

class ResultMatchesModel {
  final List<ResultMatch> data;

  ResultMatchesModel({required this.data});

  factory ResultMatchesModel.fromJson(List<dynamic> json) {
    return ResultMatchesModel(
      data: json.map((match) => ResultMatch.fromJson(match)).toList(),
    );
  }
}

class ResultMatch {
  final int id;
  final String matchTitle;
  final String matchStartTime;
  final String matchStartDate;
  final int totalPrize;
  final int entryFee;
  final List<String> entryType;
  final String version;
  final String matchMap;
  final int? perKill;
  final String? details;
  final String? roomDetails;
  final int status;
  final int subCategoryId;
  final dynamic matchRules;
  final List<MatchPoint> matchPoints;
  final List<PrizeSet> prizeSets;
  final int isJoined;

  ResultMatch({
    required this.id,
    required this.matchTitle,
    required this.matchStartTime,
    required this.matchStartDate,
    required this.totalPrize,
    required this.entryFee,
    required this.entryType,
    required this.version,
    required this.matchMap,
    this.perKill,
    this.details,
    this.roomDetails,
    required this.status,
    required this.subCategoryId,
    this.matchRules,
    required this.matchPoints,
    required this.prizeSets,
    required this.isJoined,
  });

  factory ResultMatch.fromJson(Map<String, dynamic> json) {
    // Handle entry type that could be either a string or a list
    List<String> parseEntryType(dynamic entryTypeData) {
      if (entryTypeData == null) return [];
      if (entryTypeData is String) return [entryTypeData];
      if (entryTypeData is List) {
        return entryTypeData.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Parse match points
    List<MatchPoint> parseMatchPoints(dynamic matchPointsData) {
      if (matchPointsData == null || !(matchPointsData is List)) return [];
      return (matchPointsData as List)
          .map((point) => MatchPoint.fromJson(point))
          .toList();
    }

    // Parse prize sets
    List<PrizeSet> parsePrizeSets(dynamic prizeSetsData) {
      if (prizeSetsData == null || !(prizeSetsData is List)) return [];
      return (prizeSetsData as List)
          .map((prize) => PrizeSet.fromJson(prize))
          .toList();
    }

    // Calculate per kill from match points if available
    int? calculatePerKill(List<MatchPoint> matchPoints) {
      final perKillPoint = matchPoints.firstWhere(
        (point) => point.title.toLowerCase().contains('kill'),
        orElse: () => MatchPoint(id: 0, point: 0, title: ''),
      );
      return perKillPoint.id != 0 ? perKillPoint.point : null;
    }

    final matchPointsList = parseMatchPoints(json['matchPoints']);

    return ResultMatch(
      id: json['id'] ?? 0,
      matchTitle: json['match_title'] ?? '',
      matchStartTime: json['match_start_time'] ?? '',
      matchStartDate: json['match_start_date'] ?? '',
      totalPrize: json['total_prize'] ?? 0,
      entryFee: json['entry_fee'] ?? 0,
      entryType: parseEntryType(json['entry_type']),
      version: json['version'] ?? '',
      matchMap: json['match_map'] ?? '',
      perKill: calculatePerKill(matchPointsList),
      details: json['detailes'],
      roomDetails: json['room_details'],
      status: json['status'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
      matchRules: json['matchRules'],
      matchPoints: matchPointsList,
      prizeSets: parsePrizeSets(json['prizeSets']),
      isJoined: json['is_joined'] ?? 0,
    );
  }

  // Helper method to get match start datetime
  DateTime getMatchDateTime() {
    try {
      final dateParts = matchStartDate.split('-');
      final timeParts = matchStartTime.split(':');

      if (dateParts.length == 3 && timeParts.length >= 2) {
        return DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
          timeParts.length > 2 ? int.parse(timeParts[2].split('.').first) : 0,
        );
      }
    } catch (e) {
      print('Error parsing date time: $e');
    }

    // Return current date as fallback
    return DateTime.now();
  }
}

class MatchPoint {
  final int id;
  final int point;
  final String title;

  MatchPoint({required this.id, required this.point, required this.title});

  factory MatchPoint.fromJson(Map<String, dynamic> json) {
    return MatchPoint(
      id: json['id'] ?? 0,
      point: json['point'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}

class PrizeSet {
  final int id;
  final String title;
  final int amount;

  PrizeSet({required this.id, required this.title, required this.amount});

  factory PrizeSet.fromJson(Map<String, dynamic> json) {
    return PrizeSet(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }
}
