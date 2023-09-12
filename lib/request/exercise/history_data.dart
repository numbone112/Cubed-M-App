import 'package:json_annotation/json_annotation.dart';

part 'history_data.g.dart';

@JsonSerializable(explicitToJson: true)
class History {
  History(
      {
      required this.name,
      required this.time,
      required this.people,
      required this.remark,
      required this.avgScore,
      required this.isGroup,
      required this.items,
      required this.score,
      required this.peopleCount,
      required this.m_id
      

      });

  String name;
  DateTime time;
  String m_id;
  String people;
  String remark;
  bool isGroup;
  double score;
  double avgScore;
  int peopleCount;
  List<int> items;
 
  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}