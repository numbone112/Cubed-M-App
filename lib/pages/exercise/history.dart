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
      margin: const EdgeInsets.only(top: 10),
      child: Box.boxHasRadius(
        height: MediaQuery.of(context).size.height * 0.15,
        color: Colors.white,
        child: Row(
          children: [
            Box.boxHasRadius(
              color: isM ? MyTheme.color : MyTheme.lightColor,
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.15,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, HistoryDetailPerson.routeName,
                      arguments: historyDeep);
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWidget(
                        text: isM ? "召集人" : "成員",
                        color: Colors.white,
                      ),
                      textWidget(
                        text: historyDeep.name,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: textWidget(
                        text: '左手*3',
                        textAlign: TextAlign.center,
                        type: TextType.content),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: textWidget(
                        text: '右手*5',
                        textAlign: TextAlign.center,
                        type: TextType.content),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: textWidget(
                        text: '椅子坐立*1',
                        textAlign: TextAlign.center,
                        type: TextType.content),
                  ),
                ],
              ),
            ),
            Box.textRadiusBorder(historyDeep.score.toString(),
                width: 60, textType: TextType.sub)
          ],
        ),
      ),
    );
  }

  List<Widget> deepBoxs(String mId) {
    List<Widget> result = [];

    for (HistoryDeep historyDeep in historyDeepList) {
      if (historyDeep.user_id == mId) {
        result.insert(0, deepBox(historyDeep, true));
      } else {
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
        setState(() {
          historyDeepList = parseHistoryDeepList(jsonEncode(value.D));
        });
      });
    }

    return (CustomPage(
      body: ListView(
          children: <Widget>[
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Box.inviteInfo(Invite.fromJson(history.toJson()), false),
                    Column(
                      children: [
                        textWidget(
                          text: '平均',
                          type: TextType.sub,
                        ),
                        Box.textRadiusBorder(history.avgScore.toString(),
                            width: 60,
                            color: Colors.white,
                            textType: TextType.sub)
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
