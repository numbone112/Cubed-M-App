import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const String _keyString = "efu-app-login-data";
  static const _userStorage = FlutterSecureStorage();

  static Future saveLoginData(String username, String password) async {
    Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };
    await _userStorage.write(key: _keyString, value: jsonEncode(loginData));
  }

  static Future<Map<String, dynamic>> getLoginData() async {
    String? loginDataEncoded = await _userStorage.read(key: _keyString);
    return loginDataEncoded != null
        ? jsonDecode(loginDataEncoded) as Map<String, dynamic>
        : {};
  }

  static void deleteLoginData() async{
    _userStorage.delete(key: _keyString);
  }
}
