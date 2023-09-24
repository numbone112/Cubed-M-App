import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';

import 'package:flutter/material.dart';

class ExerciseHome extends StatefulWidget {
  final String userName;
  const ExerciseHome({super.key, required this.userName});

  @override
  State<StatefulWidget> createState() => ExerciseHomeState();
}

class ExerciseHomeState extends State<ExerciseHome>
    with SingleTickerProviderStateMixin {
  // 宣告 TabController
  late TabController tabController;
  InviteRepo inviteRepo = InviteRepo();
  HistoryRepo historyRepo = HistoryRepo();

  List<Invite> invite_list = [];
  List<History> hisotry_list = [];

  int mode = 1;

  @override
  void initState() {
    // 建立 TabController，vsync 接受的型態是 TickerProvider
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    inviteRepo.inviteList(widget.userName, mode).then((value) {
      List<Invite> inviteList = parseInviteList(jsonEncode(value.D));
      setState(() {
        invite_list = inviteList;
      });
    });
    historyRepo.historyList(widget.userName).then((value) {
      List<History> historyList = parseHistoryList(jsonEncode(value.D));
      setState(() {
        hisotry_list = historyList;
      });
    });
  }

  void filter(int m) {
    setState(() {
      mode = m;
    });
    inviteRepo.inviteList(widget.userName, mode).then((value) {
      List<Invite> inviteList = parseInviteList(jsonEncode(value.D));
      setState(() {
        invite_list = inviteList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (CustomPage(
        body: Column(
      children: [
        TabBar(
          indicatorColor: MyTheme.buttonColor,
          labelStyle: TextStyle(color: MyTheme.buttonColor),
          unselectedLabelStyle: const TextStyle(color: Colors.black12),
          labelColor: MyTheme.buttonColor,
          controller: tabController,
          tabs: [
            Tab(
              child: Box.titleText("邀約", alignment: Alignment.center),
            ),
            Tab(
              child: Box.titleText("歷史運動", alignment: Alignment.center),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.8,
          child: TabBarView(
            controller: tabController,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => filter(1),
                        child: Box.textRadiusBorder("已接受",
                            filling: mode == 1 ? null : MyTheme.lightColor),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => filter(2),
                        child: Box.textRadiusBorder("未接受",
                            filling: mode == 2 ? null : MyTheme.lightColor),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => filter(3),
                        child: Box.textRadiusBorder("未回覆",
                            filling: mode == 3 ? null : MyTheme.lightColor),
                      ),
                    ],
                  ),
                  Box.boxHasRadius(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ListView.builder(
                            itemCount: invite_list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return (Box.inviteBox(
                                  invite_list[index], context));
                            }),
                      ),
                      color: MyTheme.backgroudColor),
                ],
              ),
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text("篩選"),
                  ],
                ),
                Box.boxHasRadius(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Box.boxHasRadius(
                      color: MyTheme.backgroudColor,
                      child: ListView.builder(
                          itemCount: hisotry_list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (Box.history(
                                hisotry_list[index], context, widget.userName));
                          }),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ],
    )));
  }
}
