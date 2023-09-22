// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
      name: json['name'] as String,
      time: json['time'] as String,
      m_id: json['m_id'] as String,
      remark: json['remark'] as String,
      friend:
          (json['friend'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$InviteToJson(Invite instance) => <String, dynamic>{
      'name': instance.name,
      'time': instance.time,
      'm_id': instance.m_id,
      'remark': instance.remark,
      'friend': instance.friend,
    };
