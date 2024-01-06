// import 'dart:js_interop';

import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../module/page.dart';

class HistoryDetailPerson extends StatefulWidget {
  final String userID;
  // final History history;

  const HistoryDetailPerson({super.key, required this.userID});
  static const routeName = '/history/detail/person';

  @override
  State<StatefulWidget> createState() => HistoryDetailPersonstate();
}

class HistoryDetailPersonstate extends State<HistoryDetailPerson> {
  int select = 0;
  List<DoneItem> dones = [];
  HistoryRepo historyRepo = HistoryRepo();
  static final List<String> leveltable = ["不好", "稍差", "普通", "尚好", "很好"];
  static final List<String> type = ["左手", "右手", '椅子坐立'];
  List<String> compare = ["", "", ""];
  Commend? commend;

  changeSelect(int s, List<DoneItem> origin) {
    setState(() {
      dones = origin.where((element) => element.type_id == s).toList();
      select = s;
    });
  }

  getCommend(HistoryDeep historyDeep) async {
    await historyRepo
        .commend(historyDeep.user_id, historyDeep.i_id)
        .then((value) {
      List<String> commendTemp = [];
      Commend reply = Commend.fromJson(jsonDecode(jsonEncode(value.D)));

      for (int i = 0; i < type.length; i++) {
        String level = leveltable[historyDeep.each_score[i].floor() - 1];
        commendTemp.add("$level,${reply.commend[i]}");
      }
      
      setState(() {
        compare = commendTemp;
        commend=reply;
      });
    });
  }

  List<Widget> label(List<DoneItem> d) {
    List<Widget> result = [];
    for (var i = 0; i < type.length; i++) {
      result.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => changeSelect(i, d),
          child: Box.textRadiusBorder(type[i],
              margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              color: select == i ? Colors.white : MyTheme.color,
              filling: select == i ? MyTheme.color : Colors.white,
              border: MyTheme.color,
              width: 80),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HistoryDeep;
    if (dones.isEmpty) {
      changeSelect(0, args.done);
      getCommend(args);
    }
    
    return (CustomPage(
      body: ListView(children: [
        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textWidget(
                    text: commend?.name??"",
                    type: TextType.fun,
                    color: MyTheme.buttonColor,
                  ),
                  textWidget(
                    text: commend==null?"":"${commend!.sex=="male" ? "男" : "女"} ${AgeCalculator.age(commend!.birthday).years}",
                    type: TextType.content,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                textWidget(
                  text: '評分',
                  type: TextType.sub,
                ),
                Box.textRadiusBorder(args.total_score.toStringAsFixed(1),
                    width: 60, color: Colors.white, textType: TextType.content)
              ],
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 50,
              height: 100,
              child: Chart.avgChart(args.each_score.isEmpty
                  ? [3, 4, 5]
                  : args.each_score
                      .map(
                        (e) => e,
                      )
                      .toList()),
            ),
            Column(
              children: [
                Row(
                  children: [
                    textWidget(
                      text: '與過往相比',
                      type: TextType.sub,
                    ),
                    GestureDetector(
                      onTap: () => showCommendInfo(context),
                      child: Icon(
                        CupertinoIcons.question_circle,
                        size: 20,
                        color: MyTheme.color,
                      ),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Box.boxHasRadius(
                    padding: Space.allTen,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                          text: '左手：${compare[0]}',
                          type: TextType.content,
                        ),
                        textWidget(
                          text: '右手：${compare[1]}',
                          type: TextType.content,
                        ),
                        textWidget(
                          text: '椅子坐立：${compare[2]}',
                          type: TextType.content,
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
        //各運動項目
        Row(
          children: label(args.done),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: textWidget(
                    text: '流水號',
                    type: TextType.content,
                    textAlign: TextAlign.center),
              ),
              Expanded(
                flex: 1,
                child: textWidget(
                    text: '次數',
                    type: TextType.content,
                    textAlign: TextAlign.center),
              ),
              Expanded(
                flex: 1,
                child: textWidget(
                    text: '等級',
                    type: TextType.content,
                    textAlign: TextAlign.center),
              )
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 300,
          child: ListView.builder(
            itemCount: dones.length,
            itemBuilder: (context, index) {
              return Box.boxHasRadius(
                height: 50,
                margin: const EdgeInsets.only(top: 15),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: textWidget(
                          text: (index + 1).toString(),
                          type: TextType.content,
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 1,
                      child: textWidget(
                          text: dones[index].times.toString(),
                          type: TextType.content,
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 1,
                      child: textWidget(
                          text: leveltable[dones[index].level-1],
                          type: TextType.content,
                          textAlign: TextAlign.center),
                    )
                  ],
                ),
              );
            },
            // children: [

            // ],
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
