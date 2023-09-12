// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      people: json['people'] as String,
      remark: json['remark'] as String,
      avgScore: (json['avgScore'] as num).toDouble(),
      isGroup: json['isGroup'] as bool,
      items: (json['items'] as List<dynamic>).map((e) => e as int).toList(),
      score: (json['score'] as num).toDouble(),
      peopleCount: json['peopleCount'] as int,
      m_id:json['m_id']as String
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'name': instance.name,
      'time': instance.time.toIso8601String(),
      'people': instance.people,
      'remark': instance.remark,
      'isGroup': instance.isGroup,
      'score': instance.score,
      'avgScore': instance.avgScore,
      'peopleCount': instance.peopleCount,
      'items': instance.items,
      'm_id':instance.m_id,
      'friend':[]//記得刪掉
    };
