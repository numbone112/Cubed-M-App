import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';

abstract class HistoryAPI {
  // 新增邀約

  Future<Format> homeData(String userID);
  
}


class HomeRepo extends API implements HistoryAPI {
  @override
  Future<Format> homeData(String userID) async{
    return await lunch(client.get(Uri.parse("$domain/home/$userID")));
  }

}
