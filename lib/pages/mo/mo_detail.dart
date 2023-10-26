import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/profile/profile.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/mo/mo.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoDetail extends StatefulWidget {
  static const routeName = '/mo/detail';
  final int first = 1;
  final GetUser friend;
  const MoDetail({super.key, required this.userName, required this.friend});
  final String userName;

  @override
  State<MoDetail> createState() => MoDetailState();
}

class MoDetailState extends State<MoDetail> {
  HistoryRepo historyRepo = HistoryRepo();

  List<History> hisotrylist = [];
  MoRepo moRepo = MoRepo();


  @override
  void initState() {
    super.initState();
    moRepo.detail(widget.userName, widget.friend.id).then((value) {
      setState(() {
        hisotrylist = parseHistoryList(jsonEncode(value.D));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "Mo 伴",
      headColor: MyTheme.lightColor,
      buildContext: context,
      body: ListView(children: [
        const Padding(padding: EdgeInsets.all(10)),
        Box.boxHasRadius(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(text: widget.friend.name, type: TextType.fun),
                  textWidget(
                      text:
                          "${widget.friend.sex} ${AgeCalculator.age(widget.friend.birthday).years}",
                      type: TextType.fun)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(text: "運動評分",type: TextType.fun),
                  Box.textRadiusBorder(widget.friend.score.toString(),width: 70)
                ],
              )
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Box.boxHasRadius(
              width: MediaQuery.of(context).size.width*0.4,
                height: 200,
                // margin: const EdgeInsets.only(left: 30),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    textWidget(text: "與好友一起運動"),
                    textWidget(
                        text: "共 ${hisotrylist.length} 次", type: TextType.fun),
                    textWidget(text: "最後一次運動2023/04/05"),
                  ],
                )),
            Box.boxHasRadius(
              width: MediaQuery.of(context).size.width*0.4,
              height: 200,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  const Text("分析圖"),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 150,
                    height: 150,
                    child: Chart.avgChart(widget.friend.sport_info.map((e) => e.score).toList())
                  )
                ],
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
          child: Text(
            "與您的運動紀錄",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Box.boxHasRadius(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Box.boxHasRadius(
              color: MyTheme.backgroudColor,
              child: ListView.builder(
                  itemCount: hisotrylist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (Box.history(
                        hisotrylist[index], context, widget.userName));
                  }),
            ),
          ),
        )
      ]),
    );
  }
}
