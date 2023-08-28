

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'invite_data.g.dart';

List<Invite> parseInviteList(String responseBody) {
  
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Invite>((json) => Invite.fromJson(json)).toList();
}


@JsonSerializable(explicitToJson: true)
class Invite {
  Invite(
      {
        required this.name,
      required this.time,
      required this.m_id,
      required this.remark,
      required this.friend
      });

  String name;
  DateTime time;
  String m_id;
  String remark;
  List<String> friend;
 
  factory Invite.fromJson(Map<String, dynamic> json) =>
      _$InviteFromJson(json);
  Map<String, dynamic> toJson() => _$InviteToJson(this);
}