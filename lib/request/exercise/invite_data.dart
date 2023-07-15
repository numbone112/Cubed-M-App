// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Invite {
  Invite(
      {
        required this.name,
      required this.time,
      required this.people,
      required this.remark,
      });

  String name;
  DateTime time;
  String people;
  String remark;
 
  // factory Invite.fromJson(Map<String, dynamic> json) =>
  //     _$InviteFromJson(json);
  // Map<String, dynamic> toJson() => _$InviteToJson(this);
}