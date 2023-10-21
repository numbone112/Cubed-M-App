import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invite_data.g.dart';

List<Invite> parseInviteList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Invite>((json) => Invite.fromJson(json)).toList();
}

@JsonSerializable(explicitToJson: true)
class Invite {
  Invite(
    
      {this.i_id=-1,
        this.id = -1,
      this.accept = 1,
      this.name = "愉快的運動",
this.time="",
      //  this.time ,
      this.m_id = "",
      this.remark = "",
      this.m_name = "太陽餅",
      this.friend = const []}){
        time=datetime.toIso8601String();
      }
  int i_id;
  String name;
  
  final DateTime datetime=DateTime.now();
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
