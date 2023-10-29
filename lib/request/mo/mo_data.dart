import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'mo_data.g.dart';

@JsonSerializable(explicitToJson: true)
class Mo {
  String id;
  String name;

  // String sex;
  // String phone;
  // DateTime birthday;
  // int role;
  // List<int> weight;
  // int height;
  // List<String> disease;
  // List<int> targetSets;
  // List<String> targetLevel;
  Mo(
      {required this.id,
       this.name="",
      // required this.birthday,
      // required this.disease,
      // required this.height,
      // required this.phone,
      // required this.role,
      // required this.sex,
      // required this.targetLevel,
      // required this.targetSets,
      // required this.weight
      });

  factory Mo.fromJson(Map<String, dynamic> json) => _$MoFromJson(json);
  Map<String, dynamic> toJson() => _$MoToJson(this);
}

List<Mo> parseMo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Mo>((json) => Mo.fromJson(json)).toList();
}

List<MoSearch> parseMoSearchList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MoSearch>((json) => MoSearch.fromJson(json)).toList();
}

@JsonSerializable(explicitToJson: true)
class MoSearch {
  MoSearch({this.name = "", this.id = ""});
  String name;
  String id;
  factory MoSearch.fromJson(Map<String, dynamic> json) =>
      _$MoSearchFromJson(json);
  Map<String, dynamic> toJson() => _$MoSearchToJson(this);
}
