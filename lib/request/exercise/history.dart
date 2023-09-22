import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
// import 'package:e_fu/request/exercise/history_data.dart';

import 'package:logger/logger.dart';

abstract class HistoryAPI {
  // 新增邀約
  
  Future<Format> historyList(String userName);
  Future<Format> hisotry(int iId);
}

class HistoryRepo extends API implements HistoryAPI {
  var logger = Logger();
  @override
  

  @override
  Future<Format> historyList(String userName) async {
    try {
      //記得去history_data.g.dart把firend改回來
      final response = await client
          .get(Uri.parse('$domain/history/list/$userName'), headers: {
        'Content-Type': 'application/json',
      });

      Map responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.v(responseBody);
        return Format.fromJson(responseBody);
      } else {
        logger.v("not 200");
        return Format.fromJson(responseBody);
      }
    } catch (e) {
      logger.v(e);
      return Format.fromFields("error", false, "");
    }
  }
  
  @override
  Future<Format> hisotry(int iId) async {
     try {
      //記得去history_data.g.dart把firend改回來
      final response = await client
          .get(Uri.parse('$domain/history/$iId'), headers: {
        'Content-Type': 'application/json',
      });

      Map responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.v(responseBody);
        return Format.fromJson(responseBody);
      } else {
        logger.v("not 200");
        return Format.fromJson(responseBody);
      }
    } catch (e) {
      logger.v(e);
      return Format.fromFields("error", false, "");
    }
  }
}
