
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:e_fu/module/page.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
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
    var array=[Invite(name: "name", time: DateTime.now(), people: "people", remark: "remark")];
    return (Scaffold(
      backgroundColor: MyTheme.backgroudColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
            child: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: [
              Tab(
                child: BoxUI.boxHasRadius(
                    child: ListView.builder(
                      itemCount: array.length,
                      itemBuilder: (BuildContext context, int index){
                      return(BoxUI.inviteBox(array[index]));
                    }),
                    color: Colors.white),
              ),
              Tab(
               child: BoxUI.boxHasRadius(
                    child: BoxUI.titleText("歷史運動", 0, color: Colors.black,alignment: Alignment.center),
                    color: Colors.white),
              )
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.7,
              width: MediaQuery.of(context).size.width*0.7,
              child: TabBarView(
                controller: tabController,
                children: [Text("邀約"), Text("歷史運動")],
              ),
            ),
          ],
        )),
      ),
    ));
  }
}
