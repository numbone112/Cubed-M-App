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

ExeCount _$ExeCountFromJson(Map<String, dynamic> json) => ExeCount(
      count: json['count'] as int,
      month: json['month'] as int,
    );

Map<String, dynamic> _$ExeCountToJson(ExeCount instance) => <String, dynamic>{
      'month': instance.month,
      'count': instance.count,
    };

HistoryCount _$HistoryCountFromJson(Map<String, dynamic> json) => HistoryCount(
      count: json['count'] as int,
      score: (json['score'] as num).toDouble(),
      id: json['id'] as String,
      avg: (json['avg'] as num).toDouble(),
    );

Map<String, dynamic> _$HistoryCountToJson(HistoryCount instance) =>
    <String, dynamic>{
      'score': instance.score,
      'avg': instance.avg,
      'count': instance.count,
      'id': instance.id,
    };

AnalysisChart _$AnalysisChartFromJson(Map<String, dynamic> json) =>
    AnalysisChart(
      runChart: (json['runChart'] as List<dynamic>?)
              ?.map((e) => HistoryCount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sportChart: (json['sportChart'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$AnalysisChartToJson(AnalysisChart instance) =>
    <String, dynamic>{
      'runChart': instance.runChart.map((e) => e.toJson()).toList(),
      'sportChart': instance.sportChart,
    };
