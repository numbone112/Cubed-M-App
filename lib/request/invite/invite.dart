import 'dart:convert';

import 'package:e_fu/request/api.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:logger/logger.dart';

abstract class InviteAPI {
  // 新增邀約
  Future<Format> createInvite(Invite invite);
  Future<Format> inviteList(String userName, int mode);
  Future<Format> replyInvite(bool accept, String user_id, String invite_id);
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
  Future<Format> replyInvite(
      bool accept, String user_id, String invite_id) async {
    //version 2
    //記得去invite_data.g.dart把firend改回來

    return await lunch(client.post(
        Uri.parse('$domain/invite/$user_id/$invite_id'),
        body: {"accept": accept}));
  }
}
