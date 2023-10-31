// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      (json['ax'] as num).toDouble(),
      (json['ay'] as num).toDouble(),
      (json['az'] as num).toDouble(),
      (json['gx'] as num).toDouble(),
      (json['gy'] as num).toDouble(),
      (json['gz'] as num).toDouble(),
      (json['pitch'] as num).toDouble(),
      (json['times'] as num).toDouble(),
      json['sets_no'] as int,
      json['item_id'] as int,
      json['i_id'] as int,
    );

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'ax': instance.ax,
      'ay': instance.ay,
      'az': instance.az,
      'gx': instance.gx,
      'gy': instance.gy,
      'gz': instance.gz,
      'pitch': instance.pitch,
      'times': instance.times,
      'sets_no': instance.sets_no,
      'item_id': instance.item_id,
      'i_id': instance.i_id,
    };

RecordSender _$RecordSenderFromJson(Map<String, dynamic> json) => RecordSender(
      record: (json['record'] as List<dynamic>)
          .map((e) => Record.fromJson(e as Map<String, dynamic>))
          .toList(),
      detail: (json['detail'] as List<dynamic>)
          .map((e) => RecordSenderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordSenderToJson(RecordSender instance) =>
    <String, dynamic>{
      'record': instance.record.map((e) => e.toJson()).toList(),
      'detail': instance.detail.map((e) => e.toJson()).toList(),
    };

RecordSenderItem _$RecordSenderItemFromJson(Map<String, dynamic> json) =>
    RecordSenderItem(
      done: (json['done'] as List<dynamic>)
          .map((e) => DoneItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      each_score: (json['each_score'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      user_id: json['user_id'] as String,
      i_id: json['i_id'] as int,
      total_score: (json['total_score'] as num).toDouble(),
    );

Map<String, dynamic> _$RecordSenderItemToJson(RecordSenderItem instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'done': instance.done.map((e) => e.toJson()).toList(),
      'each_score': instance.each_score,
      'total_score': instance.total_score,
      'i_id': instance.i_id,
    };
