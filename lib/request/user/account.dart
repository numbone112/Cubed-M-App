// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:e_fu/request/user/get_user_model.dart';
import 'login_data.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/request/data.dart';

abstract class UserAPI {
  //註冊會員
  // Future<String> createUser();

  /// 登入
  Future<Format> login(String user, String psw);

  /// 編輯會員
  // Future<String> updateUser(int id, User user);

  //查詢使用者
  Future<Format> getUser(String id);

  // Future<Format> updateProfile(ProfileData profileData);
  // Future<Format> getFuDatil(String pId);
}

class UserRepo extends API implements UserAPI {
  var logger = Logger();

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

  @override
  getUser(String id) async {
    Map result;
    try {
      dynamic response = await client.get(
        Uri.parse('$domain/therapist/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      result = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.v(result);
        return Format.fromJson(result);
      } else {
        logger.v("not 200");
        return Format.fromJson(result);
      }
    } catch (e) {
      result = {"D": {}, "message": "error", "success": false};
      logger.v(e);
      return Format.fromJson(result);
    } finally {
      // logger.v(result);
    }
    
    // return Form.fromJson(result);
  }
}
