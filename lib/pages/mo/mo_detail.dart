import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/profile/profile.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoDetail extends StatefulWidget {
  static const routeName = '/mo/detail';
  final int first = 1;
  const MoDetail({super.key, required this.userName});
  final String userName;

  @override
  State<MoDetail> createState() => MoDetailState();
}

class MoDetailState extends State<MoDetail> {
  HistoryRepo historyRepo = HistoryRepo();

  List<History> hisotrylist = [];

  List<RawDataSet> rawDataSetList = [
    RawDataSet(title: "復健者", color: Colors.blue, values: [5, 3, 1])
  ];

  @override
  void initState() {
    super.initState();
    historyRepo.historyList(widget.userName).then((value) {
      List<History> historyList = parseHistoryList(jsonEncode(value.D));
      setState(() {
        hisotrylist = historyList;
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
        Box.boxHasRadius(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(left: 30, right: 30),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("林哲卉"), Text("女 66")],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("運動評分"),
                  Box.boxHasRadius(child: const Text("4.1"), color: Colors.red)
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
                height: 200,
                margin: const EdgeInsets.only(left: 30),
                padding: const EdgeInsets.all(10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("與好友一起運動"),
                    Text(
                      "共 15 次",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text("最後一次運動2023/04/05")
                  ],
                )),
            Box.boxHasRadius(
              height: 200,
              margin: const EdgeInsets.only(right: 30),
              child: Column(
                children: [
                  const Text("分析圖"),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 150,
                    height: 150,
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
                          dataSets: rawDataSetList.asMap().entries.map((entry) {
                            final rawDataSet = entry.value;


                            return RadarDataSet(
                              fillColor: Colors.grey.withOpacity(0.5),
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
