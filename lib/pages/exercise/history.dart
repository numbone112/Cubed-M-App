import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/exercise/detail.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';

import '../../module/page.dart';

class HistoryDetailPage extends StatefulWidget {
  final String userName;
  // final History history;

  const HistoryDetailPage({super.key, required this.userName});
  static const routeName = '/history/detail';

  @override
  State<StatefulWidget> createState() => HistoryDetailstate();
}

class HistoryDetailstate extends State<HistoryDetailPage> {
  List<HistoryDeep> historyDeepList = [];
  HistoryRepo historyRepo = HistoryRepo();

  Widget deepBox(HistoryDeep historyDeep, bool isM) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
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
                  Box.textRadiusBorder(historyDeep.score.toString())
                ],
              )),
          Box.boxHasRadius(
            margin: EdgeInsets.only(left: 50),
            color: MyTheme.buttonColor,
            height: 120,
            width: 120,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, HistoryDetailPerson.routeName,
                    arguments: historyDeep);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isM ? "召集人" : "成員",
                    style: myText(height: 3, color: Colors.white),
                  ),
                  Text(
                    historyDeep.name,
                    style: myText(height: 3, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> deepBoxs(String m_id) {
    List<Widget> result = [];

    for (HistoryDeep historyDeep in historyDeepList) {
      if (historyDeep.user_id == m_id) {
        result.insert(0, deepBox(historyDeep, true));
      }else{
result.add(deepBox(historyDeep, false));
      }
      
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final history = ModalRoute.of(context)!.settings.arguments as History;
    if (historyDeepList.isEmpty) {
      historyRepo.hisotry(history.i_id).then((value) async {
        print(value.D);

        setState(() {
          historyDeepList = parseHistoryDeepList(jsonEncode(value.D));
          // history = historyState;
        });
      });
    }

    return (CustomPage(
      body: ListView(
          children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Box.inviteInfo(Invite.fromJson(history.toJson()), false),
                    Column(
                      children: [
                        const Text("平均"),
                        Box.textRadiusBorder(history.avgScore.toString(),
                            font: Colors.white, filling: MyTheme.lightColor)
                      ],
                    )
                  ],
                ),
              ] +
              deepBoxs(history.m_id)),
      title: '運動明細',
      headColor: MyTheme.lightColor,
      headTextColor: Colors.white,
      prevColor: Colors.white,
      buildContext: context,
    ));
  }
}
