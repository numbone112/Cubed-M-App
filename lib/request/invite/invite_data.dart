

import 'package:json_annotation/json_annotation.dart';

part 'invite_data.g.dart';

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