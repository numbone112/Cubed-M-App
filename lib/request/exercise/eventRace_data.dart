
import 'dart:convert';


import 'package:json_annotation/json_annotation.dart';

part 'eventRace_data.g.dart';

@JsonSerializable(explicitToJson: true)
class EventRace {
  EventRace(
      {required this.name,
      required this.times,
      required this.m_id,
      required this.user_id});
  String name;
  String user_id;
  String m_id;
  int times;

  bool isHost() => m_id == user_id;
  factory EventRace.fromJson(Map<String, dynamic> json) =>
      _$EventRaceFromJson(json);
  Map<String, dynamic> toJson() => _$EventRaceToJson(this);
}
