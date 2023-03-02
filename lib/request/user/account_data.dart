// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import "../data.dart";

class User extends Data {
  // User FromJson(String str) => User.fromJson(json.decode(str));

  User({
    required this.account,
    required this.password,
  });

  String account;
  String password;
  dynamic permissions;

  // factory User._fromJson(Map<String, dynamic> json) => User(
  //       account: json["account"],
  //       password: json["password"],
  //       name: json["name"],
  //       pfpicId: json["pfpic_id"],
  //       usertypeId: json["usertype_id"],
  //       areaId: json["area_id"],
  //     );

 

  @override
  String datatoJson(Data data) {
    return json.encode(data.toJson());
    // TODO: implement dataformJson
    throw UnimplementedError();
  }
  @override
  static User fromJson(String str) {
    var d=json.decode(str);
    return User(
        account: d["account"],
        password: d["password"],
      );
    
  }
  
  @override
  Map<String, dynamic> toJson() =>
    {
      'account': account,
      'password': password,
    };
  
}
