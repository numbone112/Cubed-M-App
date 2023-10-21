// To parse this JSON data, do
//
//     final getMoListModel = getMoListModelFromJson(jsonString);

import 'dart:convert';

GetMoListModel getMoListModelFromJson(String str) => GetMoListModel.fromJson(json.decode(str));

String getMoListModelToJson(GetMoListModel data) => json.encode(data.toJson());

class GetMoListModel {
    List<D> d;
    String message;
    bool success;

    GetMoListModel({
        required this.d,
        required this.message,
        required this.success,
    });

    factory GetMoListModel.fromJson(Map<dynamic, dynamic> json) => GetMoListModel(
        d: List<D>.from(json["D"].map((x) => D.fromJson(x))),
        message: json["message"]??" ",
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
    String sex;
    String phone;
    DateTime birthday;
    int role;
    List<int> weight;
    int height;
    List<String> disease;
    // String target;
    List<int> targetSets;
    List<String> targetLevel;
    String id;

    D({
        required this.name,
        required this.sex,
        required this.phone,
        required this.birthday,
        required this.role,
        required this.weight,
        required this.height,
        required this.disease,
        // required this.target,
        required this.targetSets,
        required this.targetLevel,
        required this.id,
    });

    factory D.fromJson(Map<String, dynamic> json) => D(
        name: json["name"]??"no name",
        sex: json["sex"]??"no sex",
        phone: json["phone"]??"no phone",
        birthday: DateTime.parse(json["birthday"]),
        role: json["role"]??"no role",
        weight: List<int>.from(json["weight"].map((x) => x)),
        height: json["height"]??0,
        disease: List<String>.from(json["disease"].map((x) => x)),
        // target: json["target"]??,
        targetSets: List<int>.from(json["target_sets"].map((x) => x)),
        targetLevel: List<String>.from(json["target_level"].map((x) => x)),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "sex": sex,
        "phone": phone,
        "birthday": birthday.toIso8601String(),
        "role": role,
        "weight": List<dynamic>.from(weight.map((x) => x)),
        "height": height,
        "disease": List<dynamic>.from(disease.map((x) => x)),
        // "target": target,
        "target_sets": List<dynamic>.from(targetSets.map((x) => x)),
        "target_level": List<dynamic>.from(targetLevel.map((x) => x)),
        "id": id,
    };
}
