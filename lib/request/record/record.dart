// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'record_data.dart';


abstract class RecordAPI {
  

  /// 登入
  Future<Format> record(Arrange_date arrangeDate);

  
}

class RecordRepo extends API implements RecordAPI {
  @override
  Future<Format> record(Arrange_date arrangeDate) async {
    try {
      final response = await client.post(Uri.parse('$domain/record'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(arrangeDate.toJson()));
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
