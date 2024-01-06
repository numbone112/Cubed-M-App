// ignore_for_file: file_names

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/exercise/detail.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:e_fu/request/record/record.dart';
import 'package:e_fu/request/record/record_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../module/page.dart';

class AfterEventPage extends StatefulWidget {
  final String userID;
  final List<Record> recordList;
  final List<RecordSenderItem> reSenderList;
  final History history;
  const AfterEventPage(
      {super.key,
      required this.userID,
      required this.reSenderList,
      required this.recordList,
      required this.history});

  static const routeName = '/after/history/detail';

  @override
  State<StatefulWidget> createState() => AfterEventstate();
}

class AfterEventstate extends State<AfterEventPage> {
  List<HistoryDeep> historyDeepList = [];
  HistoryRepo historyRepo = HistoryRepo();
  RecordRepo recordRepo = RecordRepo();
  Logger logger = Logger();

  sendData() async {
    logger.v('await recordRepo');
    List<RecordSenderItem> tempRecorsender = [];
    widget.reSenderList.forEach((element) {
      if (!element.total_score.isNaN) {
        tempRecorsender.add(element);
      }
    });
    try {
      await recordRepo
          .record(
        RecordSender(
          record: widget.recordList,
          detail: tempRecorsender,
        ),
      )
          .then((value) async {
        if (value.message == "新增成功") {
          logger.v("成功");
        } else {
          logger.v("失敗:${value}");
        }
      });
    } catch (e) {
      logger.v("omg$e");
    }
  }

  @override
  void initState() {
    sendData();
    super.initState();
  }

  Widget deepBox(HistoryDeep historyDeep, bool isM) {
    historyDeep.i_id = widget.history.i_id;
    return Container(
      margin: Space.onlyTopTen,
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
                  child: Chart.avgChart(historyDeep.each_score ?? [0, 0, 0])),
            ),
            Box.textRadiusBorder(historyDeep.total_score.toStringAsFixed(1),
                width: 60, textType: TextType.content)
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
    if (historyDeepList.isEmpty) {
      List<HistoryDeep> temp = [];
      widget.reSenderList.forEach((e) {
        if (!e.total_score.isNaN) {
          temp.add(HistoryDeep(
              user_id: e.user_id,
              name: e.user_id,
              done: e.done,
              total_score: e.total_score,
              each_score: e.each_score,
              sex: "",
              birthday: DateTime.now()));
        }
      });
      historyDeepList = temp;
    }

    return (CustomPage(
      body: ListView(
          children: <Widget>[
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Box.inviteInfo(Invite.fromJson(widget.history.toJson()),
                        false, context),
                    Column(
                      children: [
                        textWidget(
                          text: '平均',
                          type: TextType.sub,
                        ),
                        Box.textRadiusBorder(widget.history.avgScore.toString(),
                            width: 60,
                            color: Colors.white,
                            textType: TextType.content)
                      ],
                    )
                  ],
                ),
              ] +
              deepBoxs(widget.history.m_id)),
      title: '運動明細',
      headColor: MyTheme.lightColor,
      headTextColor: Colors.white,
      prevColor: Colors.white,
      buildContext: context,
    ));
  }
}
