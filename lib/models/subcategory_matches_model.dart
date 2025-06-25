import 'dart:convert';

class SubcategoryMatchesModel {
  final String message;
  final List<SubcategoryMatch> data;

  SubcategoryMatchesModel({required this.message, required this.data});

  factory SubcategoryMatchesModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryMatchesModel(
      message: json['message'] ?? 'Matches retrieved',
      data:
          (json['data'] as List)
              .map((match) => SubcategoryMatch.fromJson(match))
              .toList(),
    );
  }
}

class SubcategoryMatch {
  final int id;
  final String matchTitle;
  final String registration;
  final String matchStartTime;
  final String matchStartDate;
  final String registrationStart;
  final String? registrationEnd;
  final int totalPrize;
  final int entryFee;
  final List<String> entryType;
  final int totalSlots;
  final int joined;
  final int isJoined;
  final String version;
  final String details;
  final String matchMap;
  final String? roomDetails;
  final int status;
  final int subCategoryId;
  final dynamic matchRules;
  final List<dynamic> matchPoints;
  final List<dynamic> prizeSets;

  SubcategoryMatch({
    required this.id,
    required this.matchTitle,
    required this.registration,
    required this.matchStartTime,
    required this.matchStartDate,
    required this.registrationStart,
    this.registrationEnd,
    required this.totalPrize,
    required this.entryFee,
    required this.entryType,
    required this.totalSlots,
    required this.joined,
    required this.isJoined,
    required this.version,
    required this.details,
    required this.matchMap,
    this.roomDetails,
    required this.status,
    required this.subCategoryId,
    this.matchRules,
    required this.matchPoints,
    required this.prizeSets,
  });

  factory SubcategoryMatch.fromJson(Map<String, dynamic> json) {
    // Handle entry type that could be either a string or a list
    List<String> parseEntryType(dynamic entryTypeData) {
      if (entryTypeData == null) return [];
      if (entryTypeData is String) return [entryTypeData];
      if (entryTypeData is List) {
        return entryTypeData.map((e) => e.toString()).toList();
      }
      return [];
    }

    return SubcategoryMatch(
      id: json['id'] ?? 0,
      matchTitle: json['match_title'] ?? '',
      registration: json['registration'] ?? 'closed',
      matchStartTime: json['match_start_time'] ?? '',
      matchStartDate: json['match_start_date'] ?? '',
      registrationStart: json['registration_start'] ?? '',
      registrationEnd: json['registration_end'],
      totalPrize: json['total_prize'] ?? 0,
      entryFee: json['entry_fee'] ?? 0,
      entryType: parseEntryType(json['entry_type']),
      totalSlots: json['total_slod'] ?? 0,
      joined: json['joined'] ?? 0,
      isJoined: json['is_joined'] ?? 0,
      version: json['version'] ?? '',
      details: json['detailes'] ?? '',
      matchMap: json['match_map'] ?? '',
      roomDetails: json['room_details'],
      status: json['status'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
      matchRules: json['matchRules'],
      matchPoints: List<dynamic>.from(json['matchPoints'] ?? []),
      prizeSets: List<dynamic>.from(json['prizeSets'] ?? []),
    );
  }

  // Helper method to calculate the match start date time
  DateTime getMatchDateTime() {
    try {
      final dateParts = matchStartDate.split('-');
      final timeParts = matchStartTime.split(':');

      if (dateParts.length == 3 && timeParts.length == 3) {
        return DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
          int.parse(timeParts[2].split('.').first),
        );
      }
    } catch (e) {
      print('Error parsing date time: $e');
    }

    // Return current date as fallback
    return DateTime.now();
  }

  // Helper method to get remaining time in seconds
  int getRemainingTimeInSeconds() {
    final matchDateTime = getMatchDateTime();
    final now = DateTime.now();
    final diff = matchDateTime.difference(now);
    return diff.inSeconds > 0 ? diff.inSeconds : 0;
  }
}
