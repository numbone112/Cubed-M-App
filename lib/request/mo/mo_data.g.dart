// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mo_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mo _$MoFromJson(Map<String, dynamic> json) => Mo(
      id: json['id'] as String,
      name: json['name'] as String? ?? "",
    );

Map<String, dynamic> _$MoToJson(Mo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MoSearch _$MoSearchFromJson(Map<String, dynamic> json) => MoSearch(
      name: json['name'] as String? ?? "",
      id: json['id'] as String? ?? "",
    );

Map<String, dynamic> _$MoSearchToJson(MoSearch instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
