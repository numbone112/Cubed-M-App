// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'invite_data.g.dart';

List<Invite> parseInviteList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Invite>((json) => Invite.fromJson(json)).toList();
}

List<InviteDetail> parseInviteDetailList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<InviteDetail>((json) => InviteDetail.fromJson(json))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class Invite {
  Invite(
      {this.i_id = -1,
      this.id = -1,
      this.accept = 1,
      this.name = "愉快的運動",
      this.time = "",
      this.m_id = "",
      this.remark = "",
      this.m_name = "",
      this.friend = const []}) {
    if (time == "") {
      time = datetime.toIso8601String();
    }
  }
  int i_id;
  String name;

  final DateTime datetime = DateTime.now();
  String time;
  String m_id;
  int id;
  String m_name;
  int accept;
  String remark;
  List<String> friend;
  DateTime transTime() {
    return DateTime.now();
  }

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);
  Map<String, dynamic> toJson() => _$InviteToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InviteDetail {
  InviteDetail(
      {required this.accept,
      this.targetSets = const [5, 5, 5],
      required this.userName});
  String userName;
  List<int> targetSets;
  int accept;
  factory InviteDetail.fromJson(Map<String, dynamic> json) =>
      _$InviteDetailFromJson(json);
  Map<String, dynamic> toJson() => _$InviteDetailToJson(this);
}
