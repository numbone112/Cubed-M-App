import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

import '../../module/cusbehiver.dart';

class Invite {
  Invite(
      {required this.host,
      required this.remark,
      required this.name,
      required this.dateTime,
      required this.accept});
  String host;
  String remark;
  String name;
  DateTime dateTime;
  String accept;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String userName = "王小明";
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _letters;
  late ScrollController _numbers;
  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _letters = _controllers.addAndGet();
    _numbers = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _letters.dispose();
    _numbers.dispose();
    super.dispose();
  }

  Widget inviteBox(Invite invite) {
    return BoxUI.boxHasRadius(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "由 ${invite.host} 發起",
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            invite.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(invite.dateTime.toIso8601String().substring(0, 10)),
          Text(invite.dateTime.toIso8601String().substring(11, 16)),
          Text(
            "備註：${invite.remark}",
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: (Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const Padding(padding: ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hello $userName",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text("今天一起來運動吧!"),
              ),

              BoxUI.titleText("運動等級", 15, fontSize: MySize.titleSize),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          BoxUI.boxHasRadius(
                            height: 150,
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ListView(
                                controller: _letters,
                                children: [
                                  Text(
                                    "左手二頭肌",
                                    style: myText(height: 3),
                                  ),
                                  Text(
                                    "右手二頭肌",
                                    style: myText(height: 3),
                                  ),
                                  Text(
                                    "下肢肌力",
                                    style: myText(height: 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                            child: BoxUI.boxHasRadius(
                              color: Colors.black,
                              height: 150,
                              width: 80,
                              child: ListView(
                                controller: _numbers,
                                children: [
                                  Text(
                                    "好",
                                    style:
                                        myText(color: Colors.white, height: 3),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "不好",
                                    style:
                                        myText(color: Colors.white, height: 3),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "普通",
                                    style:
                                        myText(color: Colors.white, height: 3),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    BoxUI.boxHasRadius(
                      width: 100,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BoxUI.titleText(
                            "運動訓練",
                            fontSize: MySize.subtitleSize,
                            0,
                            alignment: AlignmentDirectional.center,
                          ),
                          BoxUI.boxHasRadius(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.black,
                              child: GestureDetector(
                                child: Text(
                                  '開始',
                                  style: myText(color: Colors.white),
                                ),
                              )),
                          BoxUI.boxHasRadius(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            color: MyTheme.buttonColor,
                            child: GestureDetector(
                              child: Text(
                                '分析',
                                style: myText(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  BoxUI.titleText("運動邀約", 15, fontSize: MySize.titleSize),
                  const Padding(padding: EdgeInsets.all(10)),
                  BoxUI.boxHasRadius(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      color: MyTheme.hintColor,
                      child: GestureDetector(
                        child: BoxUI.titleText("新增", 0, color: Colors.white),
                      ))
                ],
              ),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    inviteBox(Invite(
                        host: "羅真",
                        remark: "活動中心集合",
                        name: "運動小隊",
                        dateTime: DateTime.now(),
                        accept: "接受")),
                    inviteBox(Invite(
                        host: "羅真",
                        remark: "活動中心集合",
                        name: "運動小隊",
                        dateTime: DateTime.now(),
                        accept: "接受"))
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
