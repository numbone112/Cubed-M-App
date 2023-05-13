// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'record_data.dart';


abstract class RecordAPI {
  

  /// 登入
  Future<Format> record(ArrangeDate arrangeDate);

  
}

class RecordRepo extends API implements RecordAPI {
    var logger = Logger();

  @override
  Future<Format> record(ArrangeDate arrangeDate) async {
    try {
      final response = await client.post(Uri.parse('$domain/record'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(arrangeDate.toJson()));
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
