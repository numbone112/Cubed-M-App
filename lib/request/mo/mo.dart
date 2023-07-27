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

        if (response == 200) {
          logger.v("200");
          return Format.fromJson(response.body);
        } else {
          return Format.fromJson(response.body);
        }
      } catch (e) {
        logger.v("this is mo.dart error");
        logger.v(e.toString());
        return Format.fromFields("error", false, "");
      }
    }
  }
}
