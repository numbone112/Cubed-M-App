// To parse this JSON data, do
//
//     final getHindMoListModel = getHindMoListModelFromJson(jsonString);

import 'dart:convert';

GetHindMoListModel getHindMoListModelFromJson(String str) => GetHindMoListModel.fromJson(json.decode(str));

String getHindMoListModelToJson(GetHindMoListModel data) => json.encode(data.toJson());

class GetHindMoListModel {
    List<D> d;
    String message;
    bool success;

    GetHindMoListModel({
        required this.d,
        required this.message,
        required this.success,
    });

    factory GetHindMoListModel.fromJson(Map<dynamic, dynamic> json) => GetHindMoListModel(
        d: List<D>.from(json["D"].map((x) => D.fromJson(x))),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "D": List<dynamic>.from(d.map((x) => x.toJson())),
        "message": message,
        "success": success,
    };
}

class D {
    String name;
    String id;

    D({
        required this.name,
        required this.id,
    });

    factory D.fromJson(Map<String, dynamic> json) => D(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
