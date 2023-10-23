


import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class HistoryDetail {
  HistoryDetail(
      {
      required this.name,
      required this.time,
      required this.people,
      required this.remark,
      required this.avgScore,
      required this.isGroup,
      required this.items,
      required this.score,
      required this.peopleCount

      });

  String name;
  DateTime time;
  String people;
  String remark;
  bool isGroup;
  double score;
  double avgScore;
  int peopleCount;
  List<int> items;
 
  // factory Invite.fromJson(Map<String, dynamic> json) =>
  //     _$InviteFromJson(json);
  // Map<String, dynamic> toJson() => _$InviteToJson(this);
}

// @JsonSerializable(explicitToJson: true)
// class Individual {
// Individual();
// String itmes;
// double avgScore;
// String name;
// }

// @JsonSerializable(explicitToJson: true)
// class IndividualDetail {
// IndividualDetail();
// String itmes;
// double avgScore;
// String name;
// }