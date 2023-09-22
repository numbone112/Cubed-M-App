// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      remark: json['remark'] as String,
      score: (json['score'] as num).toDouble(),
      m_id: json['m_id'] as String,
      avgScore: (json['avgScore'] as num).toDouble(),
      done: (json['done'] as List<dynamic>)
          .map((e) => DoneItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      friend:
          (json['friend'] as List<dynamic>).map((e) => e as String).toList(),
      i_id: json['i_id'] as int,
      m_name: json['m_name'] as String,
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'i_id': instance.i_id,
      'done': instance.done.map((e) => e.toJson()).toList(),
      'score': instance.score,
      'name': instance.name,
      'time': instance.time.toIso8601String(),
      'm_id': instance.m_id,
      'friend': instance.friend,
      'remark': instance.remark,
      'avgScore': instance.avgScore,
      'm_name': instance.m_name,
    };

HistoryDeep _$HistoryDeepFromJson(Map<String, dynamic> json) => HistoryDeep(
      user_id: json['user_id'] as String,
      name: json['name'] as String,
      done: (json['done'] as List<dynamic>)
          .map((e) => DoneItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$HistoryDeepToJson(HistoryDeep instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'name': instance.name,
      'done': instance.done.map((e) => e.toJson()).toList(),
      'score': instance.score,
    };

DoneItem _$DoneItemFromJson(Map<String, dynamic> json) => DoneItem(
      level: json['level'] as int,
      times: json['times'] as int,
      type_id: json['type_id'] as int,
    );

Map<String, dynamic> _$DoneItemToJson(DoneItem instance) => <String, dynamic>{
      'type_id': instance.type_id,
      'times': instance.times,
      'level': instance.level,
    };
