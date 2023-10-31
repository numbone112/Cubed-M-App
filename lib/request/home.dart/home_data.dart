import 'package:e_fu/request/invite/invite_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_data.g.dart';
@JsonSerializable(explicitToJson: true)
class HomeData {
  HomeData({required this.avg_score,required this.execute,required this.done_plan});
  List<Invite> execute;
  List<double> avg_score;
  List<int> done_plan;

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);
  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}