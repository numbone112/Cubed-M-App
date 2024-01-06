// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      name: json['name'] as String,
      time: json['time'] as String,
      remark: json['remark'] as String,
      score: (json['score'] as num?)?.toDouble() ?? 1,
      m_id: json['m_id'] as String,
      avgScore: (json['avgScore'] as num?)?.toDouble() ?? 1,
      done: (json['done'] as List<dynamic>?)
              ?.map((e) => DoneItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'time': instance.time,
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
      total_score: (json['total_score'] as num).toDouble(),
      each_score: json["each_score"].toString().length>3?
      (json['each_score'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList():[],
      age: json['age'] as int? ?? 0,
      i_id: json['i_id'] as int? ?? -1,
      sex: json['sex'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
    );

Map<String, dynamic> _$HistoryDeepToJson(HistoryDeep instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'name': instance.name,
      'i_id': instance.i_id,
      'done': instance.done.map((e) => e.toJson()).toList(),
      'total_score': instance.total_score,
      'each_score': instance.each_score,
      'age': instance.age,
      'sex': instance.sex,
      'birthday': instance.birthday.toIso8601String(),
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

Commend _$CommendFromJson(Map<String, dynamic> json) => Commend(
      commend:
          (json['commend'] as List<dynamic>).map((e) => e as String).toList(),
      birthday: DateTime.parse(json['birthday'] as String),
      name: json['name'] as String,
      sex: json['sex'] as String,
    );

Map<String, dynamic> _$CommendToJson(Commend instance) => <String, dynamic>{
      'commend': instance.commend,
      'name': instance.name,
      'sex': instance.sex,
      'birthday': instance.birthday.toIso8601String(),
    };
