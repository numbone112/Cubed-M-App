import 'dart:convert';

import 'package:e_fu/request/mo/get_hind_mo_list_model.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/mo/get_mo_list_model.dart';
import 'package:e_fu/request/mo/mo_data.dart';
import 'package:e_fu/request/api.dart';

abstract class MoAPI {
  // 查詢mo伴列表
  Future<GetMoListModel> getMoList(String id);
  // 查詢隱藏mo伴列表
  Future<GetHindMoListModel> getHindMoList(String id);
  // 隱藏mo伴
  Future<Format> hindMo(String id, mId);
  // 取消隱藏mo伴
  Future<Format> showMo(String id, mId);

  Future<Format> search(String keyword);
}

class MoRepo extends API implements MoAPI {
  @override
  getMoList(String id) async {
    {
      try {
        final response = await client.get(
          Uri.parse('$domain/mo/$id'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        Map responseBody = json.decode(utf8.decode(response.bodyBytes));
        logger.v(responseBody);
        if (response.statusCode == 200) {
          logger.v(responseBody["D"]);
          return GetMoListModel.fromJson(responseBody);
        } else {
          logger.v("not 200");
          return GetMoListModel.fromJson(responseBody);
        }
      } catch (e) {
        Map error = {"D": [], "message": "error", "success": false};
        logger.v(e);
        return GetMoListModel.fromJson(error);
      }
    }
  }

  @override
  getHindMoList(String id) async {
    {
      try {
        final response = await client.get(
          Uri.parse('$domain/mo/$id/hide'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        Map responseBody = json.decode(utf8.decode(response.bodyBytes));
        logger.v(responseBody);
        if (response.statusCode == 200) {
          logger.v(responseBody);
          return GetHindMoListModel.fromJson(responseBody);
        } else {
          logger.v("not 200");
          return GetHindMoListModel.fromJson(responseBody);
        }
      } catch (e) {
        Map error = {"D": {}, "message": "error", "success": false};
        logger.v(e);
        return GetHindMoListModel.fromJson(error);
      }
    }
  }

  @override
  hindMo(String id, mId) async {
    {
      try {
        final response = await client.post(Uri.parse('$domain/mo/$id/dohide'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(Mo(id: mId).toJson()));

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

  @override
  showMo(String id, mId) async {
    {
      try {
        final response = await client.post(Uri.parse('$domain/mo/$id/doshow'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(Mo(id: mId).toJson()));

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

  @override
  Future<Format> search(String keyword) async {
    return await lunch(client.get(Uri.parse('$domain/mo/search/$keyword')));
  }
}
