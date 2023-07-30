import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/e/e_data.dart';

abstract class MoAPI {
  /// 查詢mo伴
  Future<Format> getMo(String id);
}

class MoRepo extends API implements MoAPI {
  var logger = Logger();

  @override
  Future<Format> getMo(String id) async {
    {
      try {
        final response = await client.get(
          Uri.parse('$domain/mo/$id'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        Map responseBody = json.decode(utf8.decode(response.bodyBytes));
        if (response.statusCode == 200) {
          logger.v(response.body);
          return Format.fromJson(responseBody);
        } else {
          logger.v("not 200");
          return Format.fromJson(responseBody);
        }
      } catch (e) {
        logger.v("this is mo.dart error");
        logger.v(e.toString());
        return Format.fromFields("error", false, "");
      }
    }
  }
}
