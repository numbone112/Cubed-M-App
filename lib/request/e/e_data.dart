import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'e_data.g.dart';

List<EPeople> parseEpeople(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<EPeople>((json) => EPeople.fromJson(json)).toList();
}

List<EAppointment> parseEApointment(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<EAppointment>((json) => EAppointment.fromJson(json)).toList();
}

List<EAppointmentDetail> parseEApointmentDetail(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<EAppointmentDetail>((json) => EAppointmentDetail.fromJson(json)).toList();
}

ProfileData parseProfile(dynamic responseBody){
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
  EAppointment({required this.id, required this.count,required this.tf_id});
  TimeRange id;
  TimeRange tf_id;
  int count;
  factory EAppointment.fromJson(Map<String, dynamic> json) =>
      _$EAppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$EAppointmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EAppointmentDetail{
  EAppointmentDetail({required this.id,required this.done,required this.p_id,required this.item,required this.name,required this.remark});
  int id;
  String p_id;
  List<int> item;
  List<Object> done;
  String remark;
  String name;
  factory EAppointmentDetail.fromJson(Map<String, dynamic> json) =>
      _$EAppointmentDetailFromJson(json);
  Map<String, dynamic> toJson() => _$EAppointmentDetailToJson(this);
}


@JsonSerializable(explicitToJson: true)
class ProfileData {
  ProfileData({required this.password, required this.birthday,required this.id, required this.phone,required this.sex,required this.name});
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


