import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';

abstract class HistoryAPI {
  // 新增邀約

  Future<Format> historyList(String userName);
  Future<Format> hisotry(int iId);
  Future<Format> commend(String userId, int iId);
}

class HistoryRepo extends API implements HistoryAPI {
  @override
  Future<Format> historyList(String userName, {String iId = ""}) async {
    String url = iId != ""
        ? '$domain/history/list/$userName?i_id=$iId'
        : '$domain/history/list/$userName';

    return await lunch(
      client.get(Uri.parse(url), headers: header),
    );
  }

  @override
  Future<Format> hisotry(int iId) async {
    //記得去history_data.g.dart把firend改回來

    return await lunch(
        client.get(Uri.parse('$domain/history/$iId'), headers: header));
  }

  @override
  Future<Format> commend(String userId, int iId) async {
    String url = '$domain/history/detail/$iId/$userId';

    return await lunch(
      client.get(Uri.parse(url), headers: header),
    );
  }
}
