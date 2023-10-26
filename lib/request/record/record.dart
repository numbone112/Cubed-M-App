// ignore_for_file: avoid_print

import 'dart:convert';


import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'record_data.dart';

abstract class RecordAPI {
  /// 傳送資料
  Future<Format> record(RecordSender recordSender);
}

class RecordRepo extends API implements RecordAPI {
  
  @override
  Future<Format> record(RecordSender recordSender) async {
    return await lunch(
      client.post(Uri.parse("$domain/record"),
          body: jsonEncode(recordSender.toJson())),
    );
  }
}
