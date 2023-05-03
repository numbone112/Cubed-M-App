// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EPeople _$EPeopleFromJson(Map<String, dynamic> json) => EPeople(
      birthday: DateTime.parse(json['birthday'] as String),
      id: json['id'] as String,
      disease:
          (json['disease'] as List<dynamic>).map((e) => e as String).toList(),
      height: (json['height'] as num).toDouble(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      sex: json['sex'] as String,
    );

Map<String, dynamic> _$EPeopleToJson(EPeople instance) => <String, dynamic>{
      'id': instance.id,
      'birthday': instance.birthday.toIso8601String(),
      'name': instance.name,
      'phone': instance.phone,
      'sex': instance.sex,
      'height': instance.height,
      'disease': instance.disease,
    };

TimeRange _$TimeRangeFromJson(Map<String, dynamic> json) => TimeRange(
      start_date: DateTime.parse(json['start_date'] as String),
      time: json['time'] as String,
    );

Map<String, dynamic> _$TimeRangeToJson(TimeRange instance) => <String, dynamic>{
      'time': instance.time,
      'start_date': instance.start_date.toIso8601String(),
    };

EAppointment _$EAppointmentFromJson(Map<String, dynamic> json) => EAppointment(
      id: TimeRange.fromJson(json['id'] as Map<String, dynamic>),
      count: json['count'] as int,
      tf_id: TimeRange.fromJson(json['tf_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EAppointmentToJson(EAppointment instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'tf_id': instance.tf_id.toJson(),
      'count': instance.count,
    };

EAppointmentDetail _$EAppointmentDetailFromJson(Map<String, dynamic> json) =>
    EAppointmentDetail(
      id: json['id'] as int,
      done: (json['done'] as List<dynamic>).map((e) => e as Object).toList(),
      p_id: json['p_id'] as String,
      item: (json['item'] as List<dynamic>).map((e) => e as int).toList(),
      name: json['name'] as String,
      remark: json['remark'] as String,
    );

Map<String, dynamic> _$EAppointmentDetailToJson(EAppointmentDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'p_id': instance.p_id,
      'item': instance.item,
      'done': instance.done,
      'remark': instance.remark,
      'name': instance.name,
    };

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      password: json['password'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
      id: json['id'] as String,
      phone: json['phone'] as String,
      sex: json['sex'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'password': instance.password,
      'birthday': instance.birthday.toIso8601String(),
      'id': instance.id,
      'phone': instance.phone,
      'sex': instance.sex,
      'name': instance.name,
    };