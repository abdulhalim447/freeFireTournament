import 'dart:convert';

class HomeDataResponse {
  final List<ImgSlider> imgSliders;
  final List<TextSlider> textSliders;
  final List<TodayMatch> todayMatches;
  final List<CategoryMatch> categoryMatches;
  final AdminInfo? adminInfo;

  HomeDataResponse({
    required this.imgSliders,
    required this.textSliders,
    required this.todayMatches,
    required this.categoryMatches,
    this.adminInfo,
  });

  factory HomeDataResponse.fromJson(Map<String, dynamic> json) {
    // Debug the exact key in the JSON
    print('=== JSON Keys: ${json.keys.toList()} ===');

    // Use the correct key 'imgSlider' instead of 'imgSliders'
    return HomeDataResponse(
      imgSliders:
          (json['imgSlider'] as List?)
              ?.map((e) => ImgSlider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      textSliders:
          (json['textSlider'] as List?)
              ?.map((e) => TextSlider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      todayMatches:
          (json['todayMatches'] as List?)
              ?.map((e) => TodayMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categoryMatches:
          (json['categoryMatches'] as List?)
              ?.map((e) => CategoryMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      adminInfo:
          json['adminInfo'] != null
              ? AdminInfo.fromJson(json['adminInfo'] as Map<String, dynamic>)
              : null,
    );
    // Note: Intentionally ignoring 'upcomingMatch' as per requirements
  }
}

class AdminInfo {
  final int id;
  final String companyName;
  final String mobile;
  final String email;
  final String? fb;
  final String? telegram;
  final String? youtube;
  final String logo;
  final String? createdAt;
  final String? updatedAt;

  AdminInfo({
    required this.id,
    required this.companyName,
    required this.mobile,
    required this.email,
    this.fb,
    this.telegram,
    this.youtube,
    required this.logo,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminInfo.fromJson(Map<String, dynamic> json) {
    return AdminInfo(
      id: json['id'] as int? ?? 0,
      companyName: json['company_name'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fb: json['fb'] as String?,
      telegram: json['telegram'] as String?,
      youtube: json['youtube'] as String?,
      logo: json['logo'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

// Solution for fixing the ImgSlider class in home_data_response.dart

class ImgSlider {
  final int id;
  final String title;
  final String image;
  final String? link;
  final String? createdAt;
  final String? updatedAt;

  ImgSlider({
    required this.id,
    required this.title,
    required this.image,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  factory ImgSlider.fromJson(Map<String, dynamic> json) {
    return ImgSlider(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      link: json['link'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
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

class TodayMatch {
  final int id;
  final String matchTitle;
  final String registration;
  final String matchStartTime;
  final String matchStartDate;
  final String registrationStart;
  final String registrationEnd;
  final int totalPrize;
  final int entryFee;
  final List<String> entryType;
  final int totalSlod;
  final int joined;
  final String version;
  final String details;
  final String matchMap;
  final String? roomDetails;
  final int status;
  final int subCategoryId;
  final String? createdAt;
  final String? updatedAt;

  TodayMatch({
    required this.id,
    required this.matchTitle,
    required this.registration,
    required this.matchStartTime,
    required this.matchStartDate,
    required this.registrationStart,
    required this.registrationEnd,
    required this.totalPrize,
    required this.entryFee,
    required this.entryType,
    required this.totalSlod,
    required this.joined,
    required this.version,
    required this.details,
    required this.matchMap,
    this.roomDetails,
    required this.status,
    required this.subCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory TodayMatch.fromJson(Map<String, dynamic> json) {
    List<String> parseEntryType(dynamic entryTypeJson) {
      if (entryTypeJson is String) {
        try {
          final decoded = jsonDecode(entryTypeJson);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }
      return [];
    }

    return TodayMatch(
      id: json['id'] as int? ?? 0,
      matchTitle: json['match_title'] as String? ?? '',
      registration: json['registration'] as String? ?? '',
      matchStartTime: json['match_start_time'] as String? ?? '',
      matchStartDate: json['match_start_date'] as String? ?? '',
      registrationStart: json['registration_start'] as String? ?? '',
      registrationEnd: json['registration_end'] as String? ?? '',
      totalPrize: json['total_prize'] as int? ?? 0,
      entryFee: json['entry_fee'] as int? ?? 0,
      entryType: parseEntryType(json['entry_type']),
      totalSlod: json['total_slod'] as int? ?? 0,
      joined: json['joined'] as int? ?? 0,
      version: json['version'] as String? ?? '',
      details: json['detailes'] as String? ?? '',
      matchMap: json['match_map'] as String? ?? '',
      roomDetails: json['room_details'] as String?,
      status: json['status'] as int? ?? 0,
      subCategoryId: json['sub_category_id'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class CategoryMatch {
  final int id;
  final String name;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final List<SubCategory> subCategories;

  CategoryMatch({
    required this.id,
    required this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    required this.subCategories,
  });

  factory CategoryMatch.fromJson(Map<String, dynamic> json) {
    return CategoryMatch(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      subCategories:
          (json['sub_categories'] as List?)
              ?.map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SubCategory {
  final int id;
  final String name;
  final int categoryId;
  final String? slug;
  final String image;
  final String? createdAt;
  final String? updatedAt;
  final int? totalMatches;
  final List<Match> matches;

  SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    this.slug,
    required this.image,
    this.createdAt,
    this.updatedAt,
    this.totalMatches,
    required this.matches,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      categoryId: json['category_id'] as int? ?? 0,
      slug: json['slug'] as String?,
      image: json['image'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      totalMatches: json['total_matches'] as int?,
      matches:
          (json['matches'] as List?)
              ?.map((e) => Match.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Match {
  final int id;
  final String matchTitle;
  final String registration;
  final String matchStartTime;
  final String matchStartDate;
  final String registrationStart;
  final String registrationEnd;
  final int totalPrize;
  final int entryFee;
  final List<String> entryType;
  final int totalSlod;
  final int joined;
  final String version;
  final String details;
  final String matchMap;
  final String? roomDetails;
  final int status;
  final int subCategoryId;
  final String? createdAt;
  final String? updatedAt;

  Match({
    required this.id,
    required this.matchTitle,
    required this.registration,
    required this.matchStartTime,
    required this.matchStartDate,
    required this.registrationStart,
    required this.registrationEnd,
    required this.totalPrize,
    required this.entryFee,
    required this.entryType,
    required this.totalSlod,
    required this.joined,
    required this.version,
    required this.details,
    required this.matchMap,
    this.roomDetails,
    required this.status,
    required this.subCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    List<String> parseEntryType(dynamic entryTypeJson) {
      if (entryTypeJson is String) {
        try {
          final decoded = jsonDecode(entryTypeJson);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }
      return [];
    }

    return Match(
      id: json['id'] as int? ?? 0,
      matchTitle: json['match_title'] as String? ?? '',
      registration: json['registration'] as String? ?? '',
      matchStartTime: json['match_start_time'] as String? ?? '',
      matchStartDate: json['match_start_date'] as String? ?? '',
      registrationStart: json['registration_start'] as String? ?? '',
      registrationEnd: json['registration_end'] as String? ?? '',
      totalPrize: json['total_prize'] as int? ?? 0,
      entryFee: json['entry_fee'] as int? ?? 0,
      entryType: parseEntryType(json['entry_type']),
      totalSlod: json['total_slod'] as int? ?? 0,
      joined: json['joined'] as int? ?? 0,
      version: json['version'] as String? ?? '',
      details: json['detailes'] as String? ?? '',
      matchMap: json['match_map'] as String? ?? '',
      roomDetails: json['room_details'] as String?,
      status: json['status'] as int? ?? 0,
      subCategoryId: json['sub_category_id'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
