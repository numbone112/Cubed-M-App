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
    return await lunch(client.get(Uri.parse('$domain/history/list/$userName'),headers: header),);
    
  }
  
  @override
  Future<Format> hisotry(int iId) async {
          //記得去history_data.g.dart把firend改回來

    return await lunch(client
          .get(Uri.parse('$domain/history/$iId'), headers: header));
     
  }
}
