
class User {
  int? id;
  String? userName;
  String? email;

  User({this.id, this.userName, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['user_name'] = userName;
    data['email'] = email;
    return data;
  }
}
