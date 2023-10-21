import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'mo_data.g.dart';
class Mo {
  String id;
  Mo({required this.id});

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

List<MoSearch> parseMoSearchList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MoSearch>((json) => MoSearch.fromJson(json)).toList();
}

@JsonSerializable(explicitToJson: true)
class MoSearch {
  MoSearch({this.name="",this.id=""});
  String name;
  String id;
 factory MoSearch.fromJson(Map<String, dynamic> json) => _$MoSearchFromJson(json);
  Map<String, dynamic> toJson() => _$MoSearchToJson(this);
}