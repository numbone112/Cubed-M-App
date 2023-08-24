

import 'package:json_annotation/json_annotation.dart';

part 'get_user_data.g.dart';

@JsonSerializable(explicitToJson: true)
class GetUser {
  GetUser(
      {
      required this.password,
        required this.name,
        required this.sex,
        required this.phone,
        required this.birthday,
        required this.role,
        required this.friend,
        required this.hide_friend,
        required this.weight,
        required this.height,
        required this.disease,
        required this.target,
        required this.target_sets,
        required this.target_level,
        required this.id,
      });

   String password;
    String name;
    String sex;
    String phone;
    DateTime birthday;
    int role;
    List<String> friend;
    List<String> hide_friend;
    List<String> weight;
    int height;
    List<String> disease;
    String target;
    List<String> target_sets;
    List<String> target_level;
    String id;
 
  factory GetUser.fromJson(Map<String, dynamic> json) =>
      _$GetUserFromJson(json);
  Map<String, dynamic> toJson() => _$GetUserToJson(this);
}