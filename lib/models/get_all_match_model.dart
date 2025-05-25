import 'package:tournament_app/models/mathces.dart';

class GetAllMatches {
  String? status;
  String? message;
  int? count;
  List<Matches>? matches;

  GetAllMatches({this.status, this.message, this.count, this.matches});

  GetAllMatches.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        matches!.add(new Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.matches != null) {
      data['matches'] = this.matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


