import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:logger/logger.dart';

abstract class PlanAPI {
  // 新增邀約
  Future<Format> createPlan(Plan invite);
  Future<Format> getPlan(String user_id);
  // Future<Format> inviteList(String userName, int mode);
}

class PlanRepo extends API implements PlanAPI {
  var logger = Logger();

  @override
  Future<Format> createPlan(Plan plan) async {
    try {
      final response =
          await client.post(Uri.parse('$domain/plan/${plan.user_id}'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(plan.toJson()));

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
  Future<Format> getPlan(String user_id) async {
    try {
      final response = await client.get(
        Uri.parse('$domain/plan/$user_id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

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
