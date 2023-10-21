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
      (json['sets_no'] as num).toDouble(),
      (json['item_id'] as num).toDouble(),
      json['a_id'] as int,
    )..timestream = DateTime.parse(json['timestream'] as String);

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
      'timestream': instance.timestream.toIso8601String(),
    };

ArrangeDate _$ArrangeDateFromJson(Map<String, dynamic> json) => ArrangeDate(
      json['arrangeId'] as String,
      (json['raw'] as List<dynamic>)
          .map((e) => Record.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['done'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), (e as List<dynamic>).map((e) => e as int).toList()),
      ),
    );

Map<String, dynamic> _$ArrangeDateToJson(ArrangeDate instance) =>
    <String, dynamic>{
      'arrangeId': instance.arrangeId,
      'done': instance.done.map((k, e) => MapEntry(k.toString(), e)),
      'raw': instance.raw.map((e) => e.toJson()).toList(),
    };
