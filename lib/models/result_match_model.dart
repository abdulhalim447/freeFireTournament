import 'dart:convert';

class ResultMatchesModel {
  final String message;
  final List<ResultMatch> data;

  ResultMatchesModel({required this.message, required this.data});

  factory ResultMatchesModel.fromJson(Map<String, dynamic> json) {
    return ResultMatchesModel(
      message: json['message'] ?? 'Results retrieved',
      data:
          (json['data'] as List)
              .map((match) => ResultMatch.fromJson(match))
              .toList(),
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
  final int perKill;
  final String? image;
  final int subCategoryId;

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
    required this.perKill,
    this.image,
    required this.subCategoryId,
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
      perKill: json['per_kill'] ?? 0,
      image: json['image'],
      subCategoryId: json['sub_category_id'] ?? 0,
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
