class Matches {
  String? id;
  String? categories;
  String? matchTitle;
  String? registration;
  String? matchStartTime;
  String? matchStartDate;
  int? totalPrize;
  int? perKill;
  int? entryFee;
  String? entryType;
  int? fullSlot;
  String? version;
  String? detailes;
  String? createdDate;
  String? map;
  int? joined;
  int? joinedCount;
  List<dynamic>? joinedUserIds;
  String? roomDetails;
  String? totalPrizeDetails;

  Matches({
    this.id,
    this.categories,
    this.matchTitle,
    this.registration,
    this.matchStartTime,
    this.matchStartDate,
    this.totalPrize,
    this.perKill,
    this.entryFee,
    this.entryType,
    this.fullSlot,
    this.version,
    this.detailes,
    this.createdDate,
    this.map,
    this.joined,
    this.joinedCount,
    this.joinedUserIds,
    this.roomDetails,
    this.totalPrizeDetails,
  });

  Matches.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    categories = json['categories'];
    matchTitle = json['match_title'];
    registration = json['registration'];
    matchStartTime = json['match_start_time'];
    matchStartDate = json['match_start_date'];
    totalPrize = json['total_prize'];
    perKill = json['per_kill'];
    entryFee = json['entry_fee'];
    entryType = json['entry_type'];
    fullSlot = json['full_slot'];
    version = json['version'];
    detailes = json['detailes'];
    createdDate = json['created_date'];
    map = json['map'];
    joined = json['joined'];
    joinedCount = json['joined_count'];
    if (json['joined_user_ids'] != null) {
      joinedUserIds = json['joined_user_ids'];
    }
    roomDetails = json['room_details'];
    totalPrizeDetails = json['total_prize_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['categories'] = categories;
    data['match_title'] = matchTitle;
    data['registration'] = registration;
    data['match_start_time'] = matchStartTime;
    data['match_start_date'] = matchStartDate;
    data['total_prize'] = totalPrize;
    data['per_kill'] = perKill;
    data['entry_fee'] = entryFee;
    data['entry_type'] = entryType;
    data['full_slot'] = fullSlot;
    data['version'] = version;
    data['detailes'] = detailes;
    data['created_date'] = createdDate;
    data['map'] = map;
    data['joined'] = joined;
    data['joined_count'] = joinedCount;
    data['joined_user_ids'] = joinedUserIds;
    data['room_details'] = roomDetails;
    data['total_prize_details'] = totalPrizeDetails;
    return data;
  }
}
