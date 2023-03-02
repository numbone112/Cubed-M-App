// ignore_for_file: avoid_print

import 'dart:convert';

import '../api.dart';
import 'account_data.dart';

import '../data.dart';
abstract class AccountAPI {
  //註冊會員
  // Future<String> createUser();

  /// 登入
  Future<Format> login(String user, String psw);

  /// 編輯會員
  // Future<String> updateUser(int id, User user);
}

class AccountRepo extends API implements AccountAPI {
  @override
  Future<Format> login(String user, String psw) async {
    try {
      final response = await client.post(Uri.parse('$domain/user/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(User(account: user, password: psw).toJson()));
          print(response.body);
      if (response.statusCode == 200) {
        print("200了");
        
        // Format f=;
        // User.fromJson(omg);
        // var oomg = omg['data']['data'][0];

        // var ooomg = User.fromJson(json.encode(oomg));
        return Format.fromJson(response.body);
       
      } else {
        return Format.fromJson(response.body);
      }
    } catch (e) {
      print("error");
      print(e.toString());
      return Format.fromFields("error", false,"");
      
    }
   
  }
}
