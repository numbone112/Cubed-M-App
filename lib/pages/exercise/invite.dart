import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/event/event.dart';
import 'package:e_fu/pages/exercise/event_record.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key, required this.userID});
  static const routeName = '/invite/';
  final String userID;
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
              type: result.isEmpty ? '成員' : '',
              name: f.userName,
              accept: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: f.accept == 1
                        ? MyTheme.green
                        : (f.accept == 2 ? MyTheme.pink : MyTheme.color),
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

  getInvite() {
    inviteRepo.searchInvite(invite.m_id, "None", id: invite.i_id).then((value) {
      logger.v(value.D.runtimeType);
      setState(() {
        invite = parseInviteList(jsonEncode(value.D)).first;
      });
    });
  }

  getInvites() {
    inviteRepo.inviteDetail(invite.i_id).then((value) {
      logger.v(value.D);
      setState(() {
        detailList = parseInviteDetailList(jsonEncode(value.D));
      });
    });
  }

  sendReply(int accept) {
    inviteRepo.replyInvite(accept, widget.userID, invite.i_id).then((value) {
      setState(() {
        invite.accept = accept;
        detailList = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (invite.id == -1) {
      invite = ModalRoute.of(context)!.settings.arguments as Invite;
    } else {
      getInvite();
    }

    if (detailList.isEmpty) {
      getInvites();
    }
    return CustomPage(
      body: invite.i_id == -1
          ? Container()
          : Column(
              children: [
                Box.inviteInfo(
                  invite,
                  invite.m_id == widget.userID,
                  context,
                  detailList: detailList,
                  afterUpdate: () => getInvites(),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Box.inviteMember(
                    type: '召集人',
                    name: detailList.isEmpty
                        ? ""
                        : detailList
                            .where(
                                (element) => element.user_id == widget.userID)
                            .toList()
                            .first
                            .userName,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: MediaQuery.of(context).size.height * 0.51,
                  child: detailList.isEmpty
                      ? Container()
                      : ListView(children: showOnInvite()),
                ),
                invite.accept != 3
                    ? (invite.m_id == widget.userID
                        ? GestureDetector(
                            onTap: () {
                              List<EventRecord> forEvent = [];
                              for (var element in detailList) {
                                logger.v(element.userName);
                                if (element.accept == 1) {
                                  forEvent.add(
                                    EventRecord(
                                      eventRecordDetail: EventRecordDetail(
                                        item: element.targetSets,
                                      ),
                                      eventRecordInfo: EventRecordInfo(
                                        id: invite.i_id,
                                        m_id: element.m_id,
                                        user_id: element.user_id,
                                        user_name: element.userName,
                                        name: invite.name,
                                        time: invite.time,
                                        remark: invite.remark,
                                      ),
                                    ),
                                  );
                                  // EventRecordInfo(name: invite.name,time: invite.time,remark: invite.remark)));
                                }
                              }
                              Navigator.pushReplacementNamed(
                                context,
                                Event.routeName,
                                arguments: forEvent,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Box.textRadiusBorder('準備運動',
                                  textType: TextType.sub,
                                  border: MyTheme.buttonColor,
                                  width: 170,
                                  height: 45),
                            ),
                          )
                        : Container())
                    : SizedBox(
                        width: Space.screenW8(context),
                        child: Box.yesnoBox(
                          () => sendReply(1),
                          () => sendReply(2),
                          noTitle: "拒絕",
                        ),
                      )
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
