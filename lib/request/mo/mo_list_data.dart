// To parse this JSON data, do
//
//     final moListData = moListDataFromJson(jsonString);

import 'dart:convert';

MoListData moListDataFromJson(String str) => MoListData.fromJson(json.decode(str));

String moListDataToJson(MoListData data) => json.encode(data.toJson());

class MoListData {
    List<D> d;
    String message;
    bool success;

    MoListData({
        required this.d,
        required this.message,
        required this.success,
    });

    factory MoListData.fromJson(Map<String, dynamic> json) => MoListData(
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
    int role;
    String id;
    String? sex;
    String? phone;
    DateTime? birthday;
    List<String>? weight;
    int? height;
    List<String>? disease;
    String? target;
    List<String>? targetSets;
    List<String>? targetLevel;

    D({
        required this.name,
        required this.role,
        required this.id,
        this.sex,
        this.phone,
        this.birthday,
        this.weight,
        this.height,
        this.disease,
        this.target,
        this.targetSets,
        this.targetLevel,
    });

    factory D.fromJson(Map<String, dynamic> json) => D(
        name: json["name"],
        role: json["role"],
        id: json["id"],
        sex: json["sex"],
        phone: json["phone"],
        birthday: json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        weight: json["weight"] == null ? [] : List<String>.from(json["weight"]!.map((x) => x)),
        height: json["height"],
        disease: json["disease"] == null ? [] : List<String>.from(json["disease"]!.map((x) => x)),
        target: json["target"],
        targetSets: json["target_sets"] == null ? [] : List<String>.from(json["target_sets"]!.map((x) => x)),
        targetLevel: json["target_level"] == null ? [] : List<String>.from(json["target_level"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
        "id": id,
        "sex": sex,
        "phone": phone,
        "birthday": birthday?.toIso8601String(),
        "weight": weight == null ? [] : List<dynamic>.from(weight!.map((x) => x)),
        "height": height,
        "disease": disease == null ? [] : List<dynamic>.from(disease!.map((x) => x)),
        "target": target,
        "target_sets": targetSets == null ? [] : List<dynamic>.from(targetSets!.map((x) => x)),
        "target_level": targetLevel == null ? [] : List<dynamic>.from(targetLevel!.map((x) => x)),
    };
}
