import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/plan/plan_data.dart';


abstract class PlanAPI {
  // 新增邀約
  Future<Format> createPlan(Plan invite);
  Future<Format> getPlan(String userId);
  // Future<Format> inviteList(String userName, int mode);
}

class PlanRepo extends API implements PlanAPI {
  @override
  Future<Format> createPlan(Plan plan) async {
    return await lunch(client.post(Uri.parse('$domain/plan/${plan.user_id}'),
        headers: header, body: jsonEncode(plan.toJson())));
  }

  @override
  Future<Format> getPlan(String userId) async {
    return await lunch(
        client.get(Uri.parse('$domain/plan/$userId'), headers: header));
  }
}
