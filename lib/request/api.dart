import 'dart:convert';

import 'package:e_fu/request/data.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class API {
  final client = Client();
  final String domain = "https://e-fu-back.onrender.com";
  final header={
          'Content-Type': 'application/json',
        };
  Logger logger=Logger();
  // final String domain = "https://c962-211-21-101-144.ngrok-free.app";
  Future<Format> lunch(Future<Response> function) async {
    Map responseBody = {"D": {}, "message": "error", "success": false};
    
    await function.then((response) {
      responseBody = json.decode(utf8.decode(response.bodyBytes));
    }).catchError((err) {
      logger.v(err);
    });
    logger.v(responseBody);


    return Format.fromJson(responseBody);
  }
}
