
import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));

String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
    D d;
    String message;
    bool success;

    GetUserModel({
        required this.d,
        required this.message,
        required this.success,
    });

    factory GetUserModel.fromJson(Map<dynamic, dynamic> json) => GetUserModel(
        d: D.fromJson(json["D"]),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "D": d.toJson(),
        "message": message,
        "success": success,
    };
}

class D {
    String password;
    String name;
    String sex;
    int phone;
    DateTime birthday;
    int role;
    List<String> friend;
    List<String> hideFriend;
    List<String> weight;
    int height;
    List<String> disease;
    String target;
    List<String> targetSets;
    List<String> targetLevel;
    String id;

    D({
        required this.password,
        required this.name,
        required this.sex,
        required this.phone,
        required this.birthday,
        required this.role,
        required this.friend,
        required this.hideFriend,
        required this.weight,
        required this.height,
        required this.disease,
        required this.target,
        required this.targetSets,
        required this.targetLevel,
        required this.id,
    });

    factory D.fromJson(Map<String, dynamic> json) => D(
        password: json["password"],
        name: json["name"],
        sex: json["sex"],
        phone: json["phone"],
        birthday: DateTime.parse(json["birthday"]),
        role: json["role"],
        friend: List<String>.from(json["friend"].map((x) => x)),
        hideFriend: List<String>.from(json["hide_friend"].map((x) => x)),
        weight: List<String>.from(json["weight"].map((x) => x)),
        height: json["height"],
        disease: List<String>.from(json["disease"].map((x) => x)),
        target: json["target"],
        targetSets: List<String>.from(json["target_sets"].map((x) => x)),
        targetLevel: List<String>.from(json["target_level"].map((x) => x)),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "password": password,
        "name": name,
        "sex": sex,
        "phone": phone,
        "birthday": birthday.toIso8601String(),
        "role": role,
        "friend": List<dynamic>.from(friend.map((x) => x)),
        "hide_friend": List<dynamic>.from(hideFriend.map((x) => x)),
        "weight": List<dynamic>.from(weight.map((x) => x)),
        "height": height,
        "disease": List<dynamic>.from(disease.map((x) => x)),
        "target": target,
        "target_sets": List<dynamic>.from(targetSets.map((x) => x)),
        "target_level": List<dynamic>.from(targetLevel.map((x) => x)),
        "id": id,
    };
}
