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

EAppointmentDetailBase _$EAppointmentDetailBaseFromJson(
        Map<String, dynamic> json) =>
    EAppointmentDetailBase(
      id: json['id'] as int,
      done: (json['done'] as List<dynamic>).map((e) => e as Object).toList(),
      tf_time: DateTime.parse(json['tf_time'] as String),
      item: (json['item'] as List<dynamic>).map((e) => e as int).toList(),
      remark: json['remark'] as String,
    );

Map<String, dynamic> _$EAppointmentDetailBaseToJson(
        EAppointmentDetailBase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item': instance.item,
      'done': instance.done,
      'remark': instance.remark,
      'tf_time': instance.tf_time.toIso8601String(),
    };

EventRecordInfo _$EventRecordInfoFromJson(Map<String, dynamic> json) =>
    EventRecordInfo(
      id: json['id'] as int? ?? -1,
      done: (json['done'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((e) => e as int).toList())
              .toList() ??
          const [],
      name: json['name'] as String? ?? "",
      remark: json['remark'] as String? ?? "",
    );

Map<String, dynamic> _$EventRecordInfoToJson(EventRecordInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
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

PatientInside _$PatientInsideFromJson(Map<String, dynamic> json) =>
    PatientInside(
      height: (json['height'] as num).toDouble(),
      disease:
          (json['disease'] as List<dynamic>).map((e) => e as String).toList(),
      sets: (json['sets'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PatientInsideToJson(PatientInside instance) =>
    <String, dynamic>{
      'height': instance.height,
      'disease': instance.disease,
      'sets': instance.sets,
    };

PatientData _$PatientDataFromJson(Map<String, dynamic> json) => PatientData(
      password: json['password'],
      birthday: json['birthday'],
      id: json['id'],
      phone: json['phone'],
      sex: json['sex'],
      name: json['name'],
      patient: PatientInside.fromJson(json['patient'] as Map<String, dynamic>),
      appointment: (json['appointment'] as List<dynamic>)
          .map(
              (e) => EAppointmentDetailBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PatientDataToJson(PatientData instance) =>
    <String, dynamic>{
      'password': instance.password,
      'birthday': instance.birthday.toIso8601String(),
      'id': instance.id,
      'phone': instance.phone,
      'sex': instance.sex,
      'name': instance.name,
      'patient': instance.patient.toJson(),
      'appointment': instance.appointment.map((e) => e.toJson()).toList(),
    };
