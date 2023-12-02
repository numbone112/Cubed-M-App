// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_data.g.dart';

List<History> parseHistoryList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<History>((json) => History.fromJson(json)).toList();
}

List<HistoryDeep> parseHistoryDeepList(String responseBody) {
  List<HistoryDeep> result = [];
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  result =
      parsed.map<HistoryDeep>((json) => HistoryDeep.fromJson(json)).toList();
  result.sort(((a, b) => a.total_score.compareTo(b.total_score)));

result=result.reversed.toList();
  

  return result;
}

@JsonSerializable(explicitToJson: true)
class History {
  History(
      {required this.name,
      required this.time,
      required this.remark,
      this.score = 1,
      required this.m_id,
      this.avgScore = 1,
      required this.done,
      required this.friend,
      required this.i_id,
      required this.m_name});

  int i_id;
  List<DoneItem> done;
  double score;
  String name;
  String time;
  String m_id;
  List<String> friend;
  String remark;
  double avgScore;
  String m_name;
  String pretyTime() => time.toString().substring(0, 10).replaceAll("T", " ");

  bool isGroup() => friend.length > 1;

  int peopleCount() => friend.length;

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HistoryDeep {
  HistoryDeep(
      {required this.user_id,
      required this.name,
      required this.done,
      required this.total_score,
      required this.each_score,
      this.age = 0,
      this.i_id=-1,
      required this.sex,
      required this.birthday}) {
    age = AgeCalculator.age(birthday).years;
  }
  String user_id;
  String name;
  int i_id;
  List<DoneItem> done;
  double total_score;
  List<double> each_score;
  int age;
  String sex;
  DateTime birthday;

  String pretySex() => sex == "male" ? "男" : "女";

  String sexAndAge() {
    return "${pretySex()} $age";
  }

  factory HistoryDeep.fromJson(Map<String, dynamic> json) =>
      _$HistoryDeepFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryDeepToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DoneItem {
  DoneItem({required this.level, required this.times, required this.type_id});
  int type_id;
  int times;
  int level;

  factory DoneItem.fromJson(Map<String, dynamic> json) =>
      _$DoneItemFromJson(json);
  Map<String, dynamic> toJson() => _$DoneItemToJson(this);
}
