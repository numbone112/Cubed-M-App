import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
abstract class EAPI {
  

  /// 查詢復健者
  Future<Format> getFus(String eId);
  //查詢復健安排
  Future<Format> getAps(String eId);
  //查詢復健安排詳細資料
  Future<Format> getApDetail(String eId,DateTime startDate,String time);

  
}

class ERepo extends API implements EAPI {
  @override
  Future<Format> getFus(String eId) async {
     {
    try {
      final response = await client.get(Uri.parse('$domain/e/p/$eId'),
          headers: {
            'Content-Type': 'application/json',
          },);
         
      if (response == 200) {
        print("200了");
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

  @override
  Future<Format> getAps(String eId) async{
     try {
      final response = await client.get(Uri.parse('$domain/e/a/$eId'),
          headers: {
            'Content-Type': 'application/json',
          },);
         
      if (response == 200) {
        return Format.fromJson(response.body);
       
      } else {
        return Format.fromJson(response.body);
      }
    } catch (e) {
      return Format.fromFields("error", false,"");
    }
  }
  
  @override
  Future<Format> getApDetail(String eId, DateTime startDate, String time) async{
    try {
      final response = await client.get(Uri.parse('$domain/e/a/d?e_id=${eId}&start_date=${startDate.toIso8601String().substring(0,10)}&time=${time}'),
          headers: {
            'Content-Type': 'application/json',
          },);
         
      if (response == 200) {
        return Format.fromJson(response.body);
       
      } else {
        return Format.fromJson(response.body);
      }
    } catch (e) {
      return Format.fromFields("error", false,"");
    }
  }}