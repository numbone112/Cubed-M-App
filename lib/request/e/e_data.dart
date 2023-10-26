// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'e_data.g.dart';

List<EPeople> parseEpeople(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<EPeople>((json) => EPeople.fromJson(json)).toList();
}

List<EAppointment> parseEApointment(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<EAppointment>((json) => EAppointment.fromJson(json))
      .toList();
}

List<EventRecordInfo> parseEApointmentDetail(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<EventRecordInfo>((json) => EventRecordInfo.fromJson(json))
      .toList();
}

ProfileData parseProfile(dynamic responseBody) {
  // final parsed = jsonDecode(responseBody);
  return ProfileData.fromJson(responseBody);
}

@JsonSerializable(explicitToJson: true)
class EPeople {
  EPeople(
      {required this.birthday,
      required this.id,
      required this.disease,
      required this.height,
      required this.name,
      required this.phone,
      required this.sex});

  String id;
  DateTime birthday;
  String name;
  String phone;
  String sex;
  double height;
  List<String> disease;

  factory EPeople.fromJson(Map<String, dynamic> json) =>
      _$EPeopleFromJson(json);
  Map<String, dynamic> toJson() => _$EPeopleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TimeRange {
  TimeRange({required this.start_date, required this.time});
  String time;
  DateTime start_date;
  factory TimeRange.fromJson(Map<String, dynamic> json) =>
      _$TimeRangeFromJson(json);
  Map<String, dynamic> toJson() => _$TimeRangeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EAppointment {
  EAppointment({required this.id, required this.count, required this.tf_id});
  TimeRange id;
  TimeRange tf_id;
  int count;
  factory EAppointment.fromJson(Map<String, dynamic> json) =>
      _$EAppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$EAppointmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EAppointmentDetailBase {
  EAppointmentDetailBase(
      {required this.id,
      required this.done,
      required this.tf_time,
      required this.item,
      required this.remark});
  int id;

  List<int> item;
  List<Object> done;
  String remark;
  DateTime tf_time;
  factory EAppointmentDetailBase.fromJson(Map<String, dynamic> json) =>
      _$EAppointmentDetailBaseFromJson(json);
  Map<String, dynamic> toJson() => _$EAppointmentDetailBaseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EventRecordInfo {
  EventRecordInfo(
      {this.id = -1, this.done = const [], this.name = "", this.remark = ""});
  int id;
  List<List<int>> done;
  String remark;
  String name;
  factory EventRecordInfo.fromJson(Map<String, dynamic> json) =>
      _$EventRecordInfoFromJson(json);
  Map<String, dynamic> toJson() => _$EventRecordInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProfileData {
  ProfileData(
      {required this.password,
      required this.birthday,
      required this.id,
      required this.phone,
      required this.sex,
      required this.name});
  String password;
  DateTime birthday;
  String id;
  String phone;
  String sex;
  String name;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PatientInside {
  PatientInside(
      {required this.height, required this.disease, required this.sets});
  double height;
  List<String> disease;
  List<int> sets;
  factory PatientInside.fromJson(Map<String, dynamic> json) =>
      _$PatientInsideFromJson(json);
  Map<String, dynamic> toJson() => _$PatientInsideToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PatientData extends ProfileData {
  PatientData(
      {required password,
      required birthday,
      required id,
      required phone,
      required sex,
      required name,
      required this.patient,
      required this.appointment})
      : super(
            password: password,
            birthday: birthday,
            id: id,
            phone: phone,
            sex: sex,
            name: name);
  PatientInside patient;
  List<EAppointmentDetailBase> appointment;

  factory PatientData.fromJson(Map<String, dynamic> json) =>
      _$PatientDataFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PatientDataToJson(this);
}
