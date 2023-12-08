// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'plan_data.g.dart';

List<Plan> parsePlanList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Plan>((json) => Plan.fromJson(json)).toList();
}

List<ExeCount> parseExeCount(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ExeCount>((json) => ExeCount.fromJson(json)).toList();
}

int getMaxExecount(List<ExeCount> list) {
  int max = 0;
  for (ExeCount element in list) {
    if (element.count > max) max = element.count;
  }
  return max;
}

@JsonSerializable(explicitToJson: true)
class Plan {
  Plan({
    required this.name,
    required this.user_id,
    required this.str_date,
    required this.end_date,
    required this.execute,
  });

  String name;
  DateTime str_date;
  DateTime end_date;
  String user_id;
  List<bool> execute;
  String getRange() =>
     "${str_date.toIso8601String().substring(0, 10)} - ${end_date.toIso8601String().substring(0, 10)}";
  
  bool isNowPlan()=> str_date.isBefore(DateTime.now())&&end_date.isAfter(DateTime.now());

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  Map<String, dynamic> toJson() => _$PlanToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExeCount {
  ExeCount({required this.count, required this.month});
  int month;
  int count;

  factory ExeCount.fromJson(Map<String, dynamic> json) =>
      _$ExeCountFromJson(json);
  Map<String, dynamic> toJson() => _$ExeCountToJson(this);
}
