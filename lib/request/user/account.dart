// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'account_data.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/request/data.dart';
abstract class AccountAPI {
  //註冊會員
  // Future<String> createUser();

  /// 登入
  Future<Format> login(String user, String psw);

  /// 編輯會員
  // Future<String> updateUser(int id, User user);
}

class AccountRepo extends API implements AccountAPI {
    var logger = Logger();

  @override
  Future<Format> login(String user, String psw) async {
    try {
      final response = await client.post(Uri.parse('$domain/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(User(id: user, password: psw).toJson()));
          logger.v(response.body);
      if (response.statusCode == 200) {
        logger.v("200了");
        
        // Format f=;
        // User.fromJson(omg);
        // var oomg = omg['data']['data'][0];

        // var ooomg = User.fromJson(json.encode(oomg));
        return Format.fromJson(response.body);
       
      } else {
        return Format.fromJson(response.body);
      }
    } catch (e) {
      logger.v("error");
      logger.v(e.toString());
      return Format.fromFields("error", false,"");
      
    }
   
  }
}
