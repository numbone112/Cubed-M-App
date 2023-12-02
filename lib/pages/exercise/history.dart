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
  final String userID;
  const HistoryDetailPage({super.key, required this.userID});
  static const routeName = '/history/detail';

  @override
  State<StatefulWidget> createState() => HistoryDetailstate();
}

class HistoryDetailstate extends State<HistoryDetailPage> {
  List<HistoryDeep> historyDeepList = [];
  HistoryRepo historyRepo = HistoryRepo();

  Widget deepBox(HistoryDeep historyDeep, bool isM, int i_id) {
    historyDeep.i_id = i_id;
    return Container(
      margin: Space.onlyTopTen,
      child: Box.boxHasRadius(
        height: Space.screenH15(context),
        color: Colors.white,
        child: Row(
          children: [
            Box.boxHasRadius(
              color: isM ? MyTheme.color : MyTheme.lightColor,
              width: MediaQuery.of(context).size.width * 0.3,
              height: Space.screenH15(context),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
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
              child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Chart.avgChart(historyDeep.each_score)),
            ),
            Box.textRadiusBorder(historyDeep.total_score.toString(),
                width: 60, textType: TextType.content)
          ],
        ),
      ),
    );
  }

  List<Widget> deepBoxs(String mId, int i_id) =>
      historyDeepList.map((e) => deepBox(e, e.user_id == mId, i_id)).toList();

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

    return CustomPage(
      body: ListView(
        children: <Widget>[
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Box.inviteInfo(
                    Invite.fromJson(history.toJson()),
                    false,
                    context,
                  ),
                  Column(
                    children: [
                      textWidget(
                        text: '平均',
                        type: TextType.content,
                      ),
                      Box.textRadiusBorder(history.avgScore.toString(),
                          width: 60,
                          color: Colors.white,
                          textType: TextType.content)
                    ],
                  )
                ],
              ),
            ] +
            deepBoxs(history.m_id, history.i_id),
      ),
      title: '運動明細',
      headColor: MyTheme.lightColor,
      headTextColor: Colors.white,
      prevColor: Colors.white,
      buildContext: context,
    );
  }
}
