import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:logger/logger.dart';

abstract class InviteAPI {
  // 新增邀約
  Future<Format> createInvite(Invite invite);
}

class InviteRepo extends API implements InviteAPI {
  var logger = Logger();
  @override
  Future<Format> createInvite(Invite invite) async {
    try {
      final response =
          await client.post(Uri.parse('$domain/invite/${invite.m_id}'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(invite.toJson()));

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
