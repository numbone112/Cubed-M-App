

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
       this.friend
      });

  String name;
  String time;
  String m_id;
  String remark;
  List<String>? friend;
  DateTime transTime(){
    return DateTime.now();
  }
 
  factory Invite.fromJson(Map<String, dynamic> json) =>
      _$InviteFromJson(json);
  Map<String, dynamic> toJson() => _$InviteToJson(this);
}