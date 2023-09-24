import 'package:e_fu/pages/event/event.dart';
import 'package:e_fu/pages/event/event_home.dart';
import 'package:e_fu/pages/exercise/group_c.dart';
import 'package:e_fu/pages/exercise/insert.dart';
import 'package:e_fu/pages/exercise/single_c.dart';
import 'package:e_fu/pages/profile/profile.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

import '../../module/cusbehiver.dart';

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
    return Box.boxHasRadius(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 100,
      child: Column(
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
          Text(invite.dateTime.toIso8601String().substring(0, 10)),
          Text(invite.dateTime.toIso8601String().substring(11, 16)),
          Text(
            "備註：${invite.remark}",
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  List<RawDataSet> rawDataSetList = [
    RawDataSet(title: "復健者", color: Colors.blue, values: [5, 3, 1])
  ];
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.12,
                child: MyText(text: "Cubed M", type: 1),
              ),
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
                              child: MyText(
                                  text: "運動日程", type: 3, color: Colors.white)),
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
                                      child: MyText(text: "今天 17:00", type: 4),
                                    ),
                                  );
                                }, childCount: 20),
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
                              child: MyText(text: "分析圖", type: 3)),
                        ),
                        Expanded(
                            child: Box.boxHasRadius(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: MediaQuery.of(context).size.width * 0.33,
                          child: RadarChart(
                            RadarChartData(
                                getTitle: (index, angle) {
                                  final usedAngle = angle;
                                  switch (index) {
                                    case 0:
                                      return RadarChartTitle(
                                        text: '左手',
                                        angle: usedAngle,
                                      );
                                    case 2:
                                      return RadarChartTitle(
                                        text: '右手',
                                        angle: usedAngle,
                                      );
                                    case 1:
                                      return RadarChartTitle(
                                          text: '下肢', angle: usedAngle);
                                    default:
                                      return const RadarChartTitle(text: '');
                                  }
                                },
                                dataSets:
                                    rawDataSetList.asMap().entries.map((entry) {
                                  final rawDataSet = entry.value;

                                  final isSelected = true;

                                  return RadarDataSet(
                                    fillColor: isSelected
                                        ? MyTheme.lightColor.withOpacity(0.5)
                                        // rawDataSet.color.withOpacity(0.2)
                                        : rawDataSet.color.withOpacity(0.05),
                                    borderColor: isSelected
                                        ? Colors.white.withOpacity(0.8)
                                        // rawDataSet.color
                                        : rawDataSet.color.withOpacity(0.25),
                                    entryRadius: isSelected ? 3 : 2,
                                    dataEntries: rawDataSet.values
                                        .map((e) => RadarEntry(value: e))
                                        .toList(),
                                    borderWidth: isSelected ? 2.3 : 2,
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
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                              child: MyText(text: "運動計畫", type: 3)),
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
                    child: Box.boxHasRadius(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Center(child: MyText(text: "肌力測試", type: 3)),
                    ),
                  ),
                  GestureDetector(
                    child: Box.boxHasRadius(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Center(child: MyText(text: "邀約運動", type: 3)),
                    ),
                  ),
                ],
              ),
              // Box.titleText("運動等級", gap: 15, fontSize: MySize.titleSize),
              // SizedBox(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Box.boxHasRadius(
              //         width: 100,
              //         height: 150,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             Box.titleText(
              //               "運動訓練",
              //               fontSize: MySize.subtitleSize,
              //               alignment: AlignmentDirectional.center,
              //             ),
              //             Box.boxHasRadius(
              //                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              //                 color: Colors.black,
              //                 child: GestureDetector(
              //                   onTap: () => Navigator.pushNamed(
              //                       context, GroupEvent.routeName),
              //                   child: Text(
              //                     '開始',
              //                     style: myText(color: Colors.white),
              //                   ),
              //                 )),
              //             Box.boxHasRadius(
              //               padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              //               color: MyTheme.buttonColor,
              //               child: GestureDetector(
              //                 onTap: () => Navigator.pushNamed(
              //                     context, SingleEvent.routeName),
              //                 child: Text(
              //                   '分析',
              //                   style: myText(color: Colors.white),
              //                 ),
              //               ),
              //             )
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // Row(
              //   children: [
              //     Box.titleText("運動邀約", gap: 15, fontSize: MySize.titleSize),
              //     const Padding(padding: EdgeInsets.all(10)),
              //     Box.boxHasRadius(
              //         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              //         color: MyTheme.hintColor,
              //         child: GestureDetector(
              //           onTap: () {
              //             Navigator.pushNamed(context, InsertInvite.routeName);
              //           },
              //           child: Box.titleText("新增", color: Colors.white),
              //         ))
              //   ],
              // ),
              // SizedBox(
              //   height: 200,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       inviteBox(Invite(
              //           host: "羅真",
              //           remark: "活動中心集合",
              //           name: "運動小隊",
              //           dateTime: DateTime.now(),
              //           accept: "接受")),
              //       inviteBox(Invite(
              //           host: "羅真",
              //           remark: "活動中心集合",
              //           name: "運動小隊",
              //           dateTime: DateTime.now(),
              //           accept: "接受"))
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
