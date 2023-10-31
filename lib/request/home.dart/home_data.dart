// ignore_for_file: non_constant_identifier_names

import 'package:e_fu/request/invite/invite_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_data.g.dart';
@JsonSerializable(explicitToJson: true)
class HomeData {
  HomeData({
    required this.execute,required this.done_plan});
  List<Invite> execute;
  List<int> done_plan;

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);
  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}