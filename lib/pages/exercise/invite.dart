import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key, required this.userName});
  static const routeName = '/invite/';
  final String userName;
  @override
  State<StatefulWidget> createState() => InviteState();
}

class InviteState extends State<InvitePage> {
  Invite invite = Invite();
  InviteRepo inviteRepo = InviteRepo();
  List<InviteDetail> detailList = [];
  Logger logger = Logger();

  List<Widget> showOnInvite() {
    List<Widget> result = [];
    for (var f in detailList) {
      if (f.userName != invite.m_name) {
        result.add(
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Box.inviteMember(
              type: f.userName.contains(detailList.first.userName) ? '成員' : '',
              name: f.userName,
              accept: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: MyTheme.color,
                    borderRadius: BorderRadius.circular(30)),
                child: textWidget(
                    text:
                        f.accept == 1 ? "已接受" : (f.accept == 2 ? "拒絕" : "待回覆"),
                    color: Colors.white,
                    textAlign: TextAlign.center),
              ),
            ),
          ),
        );
      }
    }
    return result;
  }

  sendReply(int accept) {
    inviteRepo.replyInvite(accept, widget.userName, invite.i_id).then((value) {
      setState(() {
        invite.accept = accept;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    invite = ModalRoute.of(context)!.settings.arguments as Invite;
    if (detailList.isEmpty) {
      inviteRepo.inviteDetail(invite.i_id).then((value) {
        setState(() {
          detailList = parseInviteDetailList(jsonEncode(value.D));
        });
      });
    }
    return CustomPage(
      body: Column(
        children: [
          Box.inviteInfo(invite, false),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Box.inviteMember(type: '召集人', name: invite.m_name)),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            height: MediaQuery.of(context).size.height * 0.56,
            child: ListView(children: showOnInvite()),
          ),
          invite.accept != 3
              ? Container()
              : Box.yesnoBox(
                  () => sendReply(1),
                  yestTitle: '接受',
                  () => sendReply(2),
                  noTitle: '拒絕')
        ],
      ),
      title: "邀約",
      buildContext: context,
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
    );
  }
}
