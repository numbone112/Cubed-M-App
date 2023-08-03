// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'record_data.dart';

abstract class RecordAPI {
  /// 傳送資料
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
}
