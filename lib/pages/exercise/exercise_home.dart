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
          name: "運動Easy",
          time: DateTime.now(),
          people: "people",
          remark: "remark")
    ];
    var history = [
      History(
          name: "我們要運動",
          time: DateTime.now(),
          people: "people",
          remark: "remark",
          avgScore: 4.5,
          isGroup: true,
          items: [3, 2, 1],
          score: 5.0,
          peopleCount: 3),
      History(
          name: "我要運動",
          time: DateTime.now(),
          people: "people",
          remark: "remark",
          avgScore: 4.5,
          isGroup: false,
          items: [3, 2, 1],
          score: 5.0,
          peopleCount: 3)
    ];
    return (Scaffold(
      backgroundColor: MyTheme.backgroudColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
                indicatorColor: MyTheme.buttonColor,
                labelStyle: TextStyle(color: MyTheme.buttonColor),
                unselectedLabelStyle: const TextStyle(color: Colors.black12),
                labelColor: MyTheme.buttonColor,
                controller: tabController,
                tabs: [
                  Tab(
                      child: BoxUI.titleText("邀約", 0,
                          alignment: Alignment.center)),
                  Tab(
                    child:
                        BoxUI.titleText("歷史運動", 0, alignment: Alignment.center),
                  )
                ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    children: [
                      Row(children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          alignment: const Alignment(0, 0),
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                            color: MyTheme.buttonColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child: const Text("已接受",
                              style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          alignment: const Alignment(0, 0),
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                            color: MyTheme.buttonColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child: const Text("未接受",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                      BoxUI.boxHasRadius(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ListView.builder(
                                itemCount: array.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return (BoxUI.inviteBox(array[index]));
                                }),
                          ),
                          color: MyTheme.backgroudColor),
                    ],
                  ),
                  Column(children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("篩選"),
                      ],
                    ),
                    BoxUI.boxHasRadius(
                        child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: BoxUI.boxHasRadius(
                          child: ListView.builder(
                              itemCount: history.length,
                              itemBuilder: (BuildContext context, int index) {
                                return (BoxUI.history(history[index]));
                              }),
                          color: MyTheme.backgroudColor),
                    ))
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
