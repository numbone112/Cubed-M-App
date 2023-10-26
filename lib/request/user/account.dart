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
  Future<Format> getUser(String id);

  // Future<Format> updateProfile(ProfileData profileData);
  // Future<Format> getFuDatil(String pId);
}

class UserRepo extends API implements UserAPI {
  @override
  Future<Format> login(String user, String psw) async {
    return await lunch(client.post(Uri.parse('$domain/login'),
        headers: header,
        body: jsonEncode(User(id: user, password: psw).toJson())));
  }

  @override
  getUser(String id) async {
    return await lunch(
        client.get(Uri.parse('$domain/therapist/$id'), headers: header));
  }
}
