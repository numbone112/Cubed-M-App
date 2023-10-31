// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      execute: (json['execute'] as List<dynamic>)
          .map((e) => Invite.fromJson(e as Map<String, dynamic>))
          .toList(),
      done_plan:
          (json['done_plan'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'execute': instance.execute.map((e) => e.toJson()).toList(),
      'done_plan': instance.done_plan,
    };
