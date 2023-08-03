// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import '../data.dart';

class User extends Data {
  // User FromJson(String str) => User.fromJson(json.decode(str));

  User({
    required this.id,
    required this.password,
  });

  String id;
  String password;
  dynamic permissions;

  // factory User._fromJson(Map<String, dynamic> json) => User(
  //       id: json["id"],
  //       password: json["password"],
  //       name: json["name"],
  //       pfpicId: json["pfpic_id"],
  //       usertypeId: json["usertype_id"],
  //       areaId: json["area_id"],
  //     );

 

  @override
  String datatoJson(Data data) {
    return json.encode(data.toJson());
  }
  static User fromJson(String str) {
    var d=json.decode(str);
    return User(
        id: d["id"],
        password: d["password"],
      );
    
  }
  
  @override
  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'password': password,
    };
  
}
