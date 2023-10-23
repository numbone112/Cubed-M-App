import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/e/e_data.dart';

abstract class EAPI {
  /// 查詢復健者
  Future<Format> getFus(String eId);
  //查詢復健安排
  Future<Format> getAps(String eId);
  //查詢復健安排詳細資料
  Future<Format> getApDetail(String eId, DateTime startDate, String time);
  Future<Format> updateProfile(ProfileData profileData);
  Future<Format> getFuDatil(String pId);
}

class ERepo extends API implements EAPI {
  @override
  getFus(String eId) async {
    {
      try {
        final response = await client.get(
          Uri.parse('$domain/therapist/p/$eId'),
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
        logger.v("this is e.dart error");
        logger.v(e.toString());
        return Format.fromFields("error", false, "");
      }
    }
  }

  @override
  getAps(String eId) async {
    try {
      final response = await client.get(
        Uri.parse('$domain/therapist/a/$eId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      Map responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.v(response.body);
        return Format.fromJson(responseBody);
      } else {
        return Format.fromJson(responseBody);
      }
    } catch (e) {
      return Format.fromFields("error", false, "");
    }
  }

  @override
  getApDetail(String eId, DateTime startDate, String time) async {
    try {
      final response = await client.get(
        Uri.parse(
            '$domain/therapist/a/d?t_id=$eId&start_date=${startDate.toIso8601String().substring(0, 10)}&time=$time'),
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
      return Format.fromFields("error", false, "");
    }
  }

  @override
  Future<Format> updateProfile(ProfileData profileData) async {
    try {
      final response =
          await client.post(Uri.parse('$domain/therapist/${profileData.id}'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(profileData));

      Map responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.v(response.body);
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
  Future<Format> getFuDatil(String pId) async {
    try {
      final response = await client
          .get(Uri.parse('$domain/people/user_id/$pId'), headers: {
        'Content-Type': 'application/json',
      });

      Map responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.v(response.body);
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
