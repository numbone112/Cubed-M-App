import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/invite/invite_data.dart';

abstract class InviteAPI {
  // 新增邀約
  Future<Format> createInvite(Invite invite);
  Future<Format> inviteList(String userName, int mode);
  Future<Format> replyInvite(int accept, String userId, int inviteId);
  Future<Format> inviteDetail(int inviteId);
  Future<Format> searchInvite(String userId, String time, {int id});
  Future<Format> updateInvite(Invite invite);
}

class InviteRepo extends API implements InviteAPI {
  @override
  Future<Format> createInvite(Invite invite) async {
    return await lunch(client.post(Uri.parse('$domain/invite/${invite.m_id}'),
        headers: header, body: jsonEncode(invite.toJson())));
  }

  @override
  Future<Format> inviteList(String userName, int mode) async {
    //記得去invite_data.g.dart把firend改回來
    return await lunch(client.get(
        Uri.parse('$domain/invite/list2/$userName/$mode'),
        headers: header));
  }

  @override
  Future<Format> replyInvite(int accept, String userId, int inviteId) async {
    //version 2
    //記得去invite_data.g.dart把firend改回來

    return await lunch(
      client.post(Uri.parse('$domain/invite/$userId/$inviteId'),
          body: jsonEncode({"accept": accept}), headers: header),
    );
  }

  @override
  Future<Format> inviteDetail(int inviteId) async {
    return await lunch(client.get(Uri.parse('$domain/invite/detail/$inviteId'),
        headers: header));
  }

  @override
  Future<Format> searchInvite(String userId, String time, {int? id}) async {
    String query = id != null ? "?id=$id" : "";
    return await lunch(client.get(
      Uri.parse('$domain/invite/search/$userId/$time$query'),
    ));
  }

  @override
  Future<Format> updateInvite(Invite invite) async {
    return await lunch(
      client.put(Uri.parse('$domain/invite/${invite.m_id}/${invite.i_id}'),
          body: jsonEncode(invite.toJson()), headers: header),
    );
  }
}
