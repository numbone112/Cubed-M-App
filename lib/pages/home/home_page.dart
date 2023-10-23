import 'package:e_fu/module/exercise_process.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/pages/event/event.dart';
import 'package:e_fu/pages/exercise/event_record.dart';
import 'package:e_fu/pages/exercise/insert.dart';
import 'package:e_fu/pages/profile/profile.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

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
  String userName = "柯明朗";
  // late LinkedScrollControllerGroup _controllers;
  // late ScrollController _letters;
  // late ScrollController _numbers;
  List<ItemWithField> targetCheck = ItemSets.withField();

  List<RawDataSet> rawDataSetList = [
    RawDataSet(title: "復健者", color: Colors.blue, values: [5, 3, 1])
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "Cubed M",
      headTexttype: TextType.page,
      headHeight: MediaQuery.of(context).size.height * 0.12,
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Box.boxHasRadius(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.29,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(0),
                        ),
                        color: MyTheme.color,
                      ),
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                          alignment: Alignment.center,
                          child: textWidget(
                              text: "運動日程",
                              type: TextType.sub,
                              color: Colors.white)),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    Expanded(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: textWidget(
                                      text: "今天 ${index * 2 + 15}:00",
                                      type: TextType.content),
                                ),
                              );
                            }, childCount: 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Box.boxHasRadius(
                width: MediaQuery.of(context).size.width * 0.46,
                height: MediaQuery.of(context).size.height * 0.29,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                          alignment: Alignment.center,
                          child: textWidget(text: "分析圖", type: TextType.sub)),
                    ),
                    Expanded(
                        child: Box.boxHasRadius(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: MediaQuery.of(context).size.width * 0.33,
                      child: RadarChart(
                        RadarChartData(
                            getTitle: (index, angle) {
                              switch (index) {
                                case 0:
                                  return const RadarChartTitle(text: '左手');
                                case 2:
                                  return const RadarChartTitle(text: '右手');
                                case 1:
                                  return const RadarChartTitle(text: '下肢');
                                default:
                                  return const RadarChartTitle(text: '');
                              }
                            },
                            dataSets:
                                rawDataSetList.asMap().entries.map((entry) {
                              final rawDataSet = entry.value;


                              return RadarDataSet(
                                fillColor: MyTheme.lightColor,
                                borderColor: Colors.white,
                                entryRadius: 3,
                                dataEntries: rawDataSet.values
                                    .map((e) => RadarEntry(value: e))
                                    .toList(),
                                borderWidth: 2.3,
                              );
                            }).toList()),
                        swapAnimationDuration:
                            const Duration(milliseconds: 150), // Optional
                        swapAnimationCurve: Curves.linear, // Optional
                      ),
                    ))
                  ],
                ),
              ),
            ],
          ),
          Box.boxHasRadius(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.22,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: textWidget(text: "運動計畫", type: TextType.sub)),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                Row(children: Box.executeWeek(show: true)),
                Row(
                  children: Box.planWeek(
                      Plan(
                          name: "",
                          end_date: DateTime.now(),
                          user_id: '',
                          str_date: DateTime.now(),
                          execute: [
                            true,
                            true,
                            false,
                            false,
                            true,
                            true,
                            false
                          ]),
                      exe: [true, true, false, false, false, true, false]),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setTarget(
                    context,
                    targetCheck,
                    yes: () => Navigator.pushReplacementNamed(
                      context,
                      Event.routeName,
                      arguments: [
                        EventRecord(
                            eventRecordDetail: EventRecordDetail(
                              item: targetCheck
                                  .map((e) =>
                                      int.parse(e.textEditingController.text))
                                  .toList(),
                            ),
                            eventRecordInfo: EventRecordInfo())
                      ],
                    ),
                    no: () => Navigator.pop(context),
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: Box.boxHasRadius(
                  boxShadow: Box.getshadow(MyTheme.color),
                  width: MediaQuery.of(context).size.width * 0.43,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Center(
                    child: textWidget(text: "肌力測試", type: TextType.sub),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    Navigator.pushNamed(context, InsertInvite.routeName),
                child: Box.boxHasRadius(
                  boxShadow: Box.getshadow(MyTheme.color),
                  width: MediaQuery.of(context).size.width * 0.43,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child:
                      Center(child: textWidget(text: "邀約運動", type: TextType.sub)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
