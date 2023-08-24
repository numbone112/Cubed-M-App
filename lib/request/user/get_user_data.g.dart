// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUser _$GetUserFromJson(Map<String, dynamic> json) => GetUser(
      password: json['password'] as String,
      name: json['name'] as String,
      sex: json['sex'] as String,
      phone: json['phone'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
      role: json['role'] as int,
      friend:
          (json['friend'] as List<dynamic>).map((e) => e as String).toList(),
      hide_friend: (json['hide_friend'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      weight:
          (json['weight'] as List<dynamic>).map((e) => e as String).toList(),
      height: json['height'] as int,
      disease:
          (json['disease'] as List<dynamic>).map((e) => e as String).toList(),
      target: json['target'] as String,
      target_sets: (json['target_sets'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      target_level: (json['target_level'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$GetUserToJson(GetUser instance) => <String, dynamic>{
      'password': instance.password,
      'name': instance.name,
      'sex': instance.sex,
      'phone': instance.phone,
      'birthday': instance.birthday.toIso8601String(),
      'role': instance.role,
      'friend': instance.friend,
      'hide_friend': instance.hide_friend,
      'weight': instance.weight,
      'height': instance.height,
      'disease': instance.disease,
      'target': instance.target,
      'target_sets': instance.target_sets,
      'target_level': instance.target_level,
      'id': instance.id,
    };
