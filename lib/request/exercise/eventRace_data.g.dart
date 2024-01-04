// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventRace_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventRace _$EventRaceFromJson(Map<String, dynamic> json) => EventRace(
      name: json['name'] as String,
      times: json['times'] as int,
      m_id: json['m_id'] as String,
      user_id: json['user_id'] as String,
    );

Map<String, dynamic> _$EventRaceToJson(EventRace instance) => <String, dynamic>{
      'name': instance.name,
      'user_id': instance.user_id,
      'm_id': instance.m_id,
      'times': instance.times,
    };
