// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
      i_id: json['i_id'] as int? ?? -1,
      id: json['id'] as int? ?? -1,
      accept: json['accept'] as int? ?? 1,
      name: json['name'] as String? ?? "愉快的運動",
      time: json['time'] as String? ?? "",
      m_id: json['m_id'] as String? ?? "",
      remark: json['remark'] as String? ?? "",
      m_name: json['m_name'] as String? ?? "",
      friend: (json['friend'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InviteToJson(Invite instance) => <String, dynamic>{
      'i_id': instance.i_id,
      'name': instance.name,
      'time': instance.time,
      'm_id': instance.m_id,
      'id': instance.id,
      'm_name': instance.m_name,
      'accept': instance.accept,
      'remark': instance.remark,
      'friend': instance.friend,
    };

InviteDetail _$InviteDetailFromJson(Map<String, dynamic> json) => InviteDetail(
      accept: json['accept'] as int,
      targetSets: (json['targetSets'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [5, 5, 5],
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$InviteDetailToJson(InviteDetail instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'targetSets': instance.targetSets,
      'accept': instance.accept,
    };
