import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';


class Invite{
  Invite({required this.host,required this.remark,required this.name,required this.dateTime,required this.accept});
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
      height: 200,
      child:  Column(
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
          Text(invite.dateTime.toIso8601String().substring(0,10)),
          Text(invite.dateTime.toIso8601String().substring(11,16)),
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
    return SizedBox(
      // width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.8,
      child: (Column(
        children: [
          const Padding(padding: EdgeInsets.all(20)),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hello $userName",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text("今天一起來運動吧!"),
          ),
          
          BoxUI.titleText("運動等級", 15),
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
                        child: ListView(
                          controller: _letters,
                          children: const [
                            Text("左手二頭肌"),
                            Text("右手二頭肌"),
                            Text("下肢肌力"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                        child: BoxUI.boxHasRadius(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          color: Colors.black,
                          height: 150,
                          width: 80,
                          child: ListView(
                            controller: _numbers,
                            children: [
                              Text(
                                "好",
                                style: whiteText(),
                              ),
                              Text(
                                "不好",
                                style: whiteText(),
                              ),
                              Text(
                                "普通",
                                style: whiteText(),
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
                      BoxUI.titleText("運動訓練", 0,
                          alignment: AlignmentDirectional.center),
                      BoxUI.boxHasRadius(
                          padding: const EdgeInsets.all(5),
                          color: Colors.black,
                          child: GestureDetector(
                            child: Text(
                              '開始',
                              style: whiteText(),
                            ),
                          )),
                      BoxUI.boxHasRadius(
                        padding: const EdgeInsets.all(5),
                        color: MyTheme.buttonColor,
                        child: GestureDetector(
                          child: Text(
                            '分析',
                            style: whiteText(),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          BoxUI.titleText("運動邀約", 15),
          inviteBox(Invite(host: "羅真", remark: "活動中心集合", name: "運動小隊", dateTime: DateTime.now(), accept: "接受"))
        ],
      )),
    );
  }
}
