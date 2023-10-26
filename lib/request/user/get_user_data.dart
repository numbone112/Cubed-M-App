// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'get_user_data.g.dart';

List<GetUser> parseGetUserList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<GetUser>((json) => GetUser.fromJson(json)).toList();
}

@JsonSerializable(explicitToJson: true)
class GetUser {
  GetUser({
     this.password="",
    required this.name,
    required this.sex,
    required this.phone,
    required this.birthday,
    required this.role,
    required this.friend,
    required this.hide_friend,
    required this.weight,
    required this.height,
    required this.disease,
    required this.score,
    required this.id,
    required this.sport_info
  });

  String password;
  String name;
  String sex;
  String phone;
  DateTime birthday;
  int role;
  List<String> friend;
  List<String> hide_friend;
  List<int> weight;
  int height;
  List<String> disease;
  double score;
  String id;
  List<SportInfo> sport_info;

  factory GetUser.fromJson(Map<String, dynamic> json) =>
      _$GetUserFromJson(json);
  Map<String, dynamic> toJson() => _$GetUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SportInfo {
  SportInfo(
      {required this.type_id,
      required this.score,
      required this.target_level,
      required this.target_sets});
  int type_id;
  int target_sets;
  int target_level;
  double score;

  factory SportInfo.fromJson(Map<String, dynamic> json) =>
      _$SportInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SportInfoToJson(this);
}
