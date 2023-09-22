// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
      name: json['name'] as String,
      user_id: json['user_id'] as String,
      str_date: DateTime.parse(json['str_date'] as String),
      end_date: DateTime.parse(json['end_date'] as String),
      execute:
          (json['execute'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'name': instance.name,
      'str_date': instance.str_date.toIso8601String(),
      'end_date': instance.end_date.toIso8601String(),
      'user_id': instance.user_id,
      'execute': instance.execute,
    };
