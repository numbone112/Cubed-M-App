import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/exercise/invite_data.dart';

import 'package:flutter/material.dart';

class ExerciseHome extends StatefulWidget {
  const ExerciseHome({super.key});

  @override
  State<StatefulWidget> createState() => ExerciseHomeState();
}

class ExerciseHomeState extends State<ExerciseHome>
    with SingleTickerProviderStateMixin {
  // 宣告 TabController
  late TabController tabController;

  @override
  void initState() {
    // 建立 TabController，vsync 接受的型態是 TickerProvider
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var array = [
      Invite(
          name: "name",
          time: DateTime.now(),
          people: "people",
          remark: "remark")
    ];
    var history = [
      History(name: "name", time: DateTime.now(), people: "people", remark: "remark", avgScore: 4.5, isGroup: true, items: [3,2,1], score: 5.0,peopleCount: 3)
    ];
    return (Scaffold(
      backgroundColor: MyTheme.backgroudColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
            child: Column(
          children: [
            TabBar(controller: tabController, tabs: [
              Tab(
                  child: BoxUI.boxHasRadius(
                      child: BoxUI.titleText("邀約", 0,
                          color: Colors.black, alignment: Alignment.center),
                      color: Colors.white)
                 
                  ),
              Tab(
                child: BoxUI.boxHasRadius(
                    child: BoxUI.titleText("歷史運動", 0,
                        color: Colors.black, alignment: Alignment.center),
                    color: Colors.white),
              )
            ]),
            SizedBox(
              
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              child: TabBarView(
                controller: tabController,
                children: [
                  BoxUI.boxHasRadius(
                    
                      child: ListView.builder(
                          itemCount: array.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (BoxUI.inviteBox(array[index]));
                          }),
                      color: HexColor("F4F5F7")),
                    BoxUI.boxHasRadius(
                    
                      child: ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (BoxUI.history(history[index]));
                          }),
                      color: HexColor("F4F5F7")),
                ],
              ),
            ),
          ],
        )),
      ),
    ));
  }
}
