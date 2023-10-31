import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/mo/mo.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:flutter/material.dart';

class MoDetail extends StatefulWidget {
  static const routeName = '/mo/detail';
  final int first = 1;
  final GetUser friend;
  const MoDetail({super.key, required this.userID, required this.friend});
  final String userID;

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
    moRepo.detail(widget.userID, widget.friend.id).then((value) {
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
      prevColor: Colors.white,
      headTextColor: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textWidget(text: widget.friend.name, type: TextType.fun),
                  const Padding(padding: EdgeInsets.all(10)),
                  textWidget(
                      text:
                          "${widget.friend.sex != "female" ? "男" : "女"} ${AgeCalculator.age(widget.friend.birthday).years}",
                      type: TextType.content)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(text: "運動評分", type: TextType.sub),
                  Box.textRadiusBorder(widget.friend.score.toString(),
                      width: 70)
                ],
              )
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Box.boxHasRadius(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 200,
                // margin: const EdgeInsets.only(left: 30),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    textWidget(text: "與好友一起運動"),
                    textWidget(
                        text: "共 ${hisotrylist.length} 次", type: TextType.fun),
                    Column(
                      children: [
                        textWidget(
                            text: "最後一次運動",
                            textAlign: TextAlign.center,
      
                            type: TextType.hint,
                            color: MyTheme.hintColor),
                            textWidget(
                        text: "2023/04/05",
                        textAlign: TextAlign.center,
      
                        type: TextType.hint,
                        color: MyTheme.hintColor),
                      ],
                    ),
                        
                  ],
                )),
            Box.boxHasRadius(
              margin: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.45,
              height: 200,
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(text: "分析圖", type: TextType.sub),
                  const Padding(padding: EdgeInsets.all(10)),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 100,
                      height: 100,
                      child: Chart.avgChart(widget.friend.sport_info
                          .map((e) => e.score)
                          .toList()))
                ],
              ),
            )
          ],
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(00, 20, 0, 10),
            child: textWidget(text: "與您的運動紀錄", type: TextType.sub)),
        SizedBox(
          // height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: hisotrylist.length,
              itemBuilder: (BuildContext context, int index) {
                return (Box.history(
                    hisotrylist[index], context, widget.userID));
              }),
        ),
      ]),
    );
  }
}
