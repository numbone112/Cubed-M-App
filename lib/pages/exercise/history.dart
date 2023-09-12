import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/exercise/detail.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';

import '../../module/page.dart';

class HistoryDetailPage extends StatefulWidget {
  final String userName;
  // final History history;

  const HistoryDetailPage(
      {super.key, required this.userName});
  static const routeName = '/history/detail';

  @override
  State<StatefulWidget> createState() => HistoryDetailstate();
}

class HistoryDetailstate extends State<HistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    final history =ModalRoute.of(context)!.settings.arguments as History;
    Map<String,dynamic> toInvite=history.toJson();
    print(history.toJson());
    return (CustomPage(
      body: ListView(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Box.inviteInfo(Invite.fromJson(toInvite)),
           
            Column(
              children: [
                const Text("平均"),
                Box.textRadiusBorder(history.avgScore.toString(),
                    font: Colors.white, filling: MyTheme.lightColor)
              ],
            )
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 300,
          child: Stack(
            children: [
              Box.boxHasRadius(
                  padding: EdgeInsets.only(left: 80),
                  margin: EdgeInsets.only(left: 100),
                  color: Colors.white,
                  height: 120,
                  width: 250,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ListView(
                          children: [
                            Text(
                              "左手*3",
                              style: myText(height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "右手*5",
                              style: myText(height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "椅子坐立*1",
                              style: myText(height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Box.textRadiusBorder("4.1")
                    ],
                  )),
              Box.boxHasRadius(
                margin: EdgeInsets.only(left: 50),
                color: MyTheme.buttonColor,
                height: 120,
                width: 120,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HistoryDetailPerson(
                                    userName: widget.userName)));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "召集人",
                        style: myText(height: 3, color: Colors.white),
                      ),
                      Text(
                        "王昭昭",
                        style: myText(height: 3, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
      title: '運動明細',
      headColor: MyTheme.lightColor,
      headTextColor: Colors.white,
      prevColor: Colors.white,
      buildContext: context,
    ));
  }
}
