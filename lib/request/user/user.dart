// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'login_data.dart';

import 'package:e_fu/request/data.dart';

abstract class UserAPI {
  //註冊會員
  // Future<String> createUser();

  /// 登入
  Future<Format> login(String user, String psw);

  /// 編輯會員
  // Future<String> updateUser(int id, User user);

  //查詢使用者
  //Future<Format> getUser(String eId);

  // Future<Format> updateProfile(ProfileData profileData);
  // Future<Format> getFuDatil(String pId);
  //Future<Format> setTarget(Target target);
}

class UserRepo extends API implements UserAPI {
  @override
  Future<Format> login(String user, String psw) async {
    try {
      final response = await client.post(Uri.parse('$domain/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(User(id: user, password: psw).toJson()));

      Map responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.v(response.body);
        return Format.fromJson(responseBody);
      } else {
        logger.v("not 200");
        return Format.fromJson(responseBody);
      }
    } catch (e) {
      logger.v("error");
      logger.v(e.toString());
      return Format.fromFields("error", false, "");
    }
  }

  // @override
  // getUser(String eId) async {
  //   return await lunch(client.get(
  //       Uri.parse('$domain/therapist/$eId'),
  //       headers: header,
  //     ));
    // try {
    //   dynamic response = await client.get(
    //     Uri.parse('$domain/therapist/$eId'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //     },
    //   );

    //   Map responseBody = json.decode(utf8.decode(response.bodyBytes));
    //   if (response.statusCode == 200) {
    //     logger.v(responseBody);
    //     return GetUserModel.fromJson(responseBody);
    //   } else {
    //     logger.v("not 200");
    //     return GetUserModel.fromJson(responseBody);
    //   }
    // } catch (e) {
    //   Map error = {"D": {}, "message": "error", "success": false};
    //   logger.v(e);
    //   return GetUserModel.fromJson(error);
    // }
  }

  // @override
  // Future<Format> setTarget(Target target) async {
  //   return await lunch(
  //       client.patch(Uri.parse('$domain/user/target'), headers: header, body: target));
  // }
