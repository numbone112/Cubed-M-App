import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/notification.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/plan/plan_insert.dart';

import 'package:e_fu/request/plan/plan.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PlanPage extends StatefulWidget {
  static const routeName = '/plan';
  final String userID;
  const PlanPage({super.key, required this.userID});

  @override
  PlanState createState() => PlanState();
}

class PlanState extends State<PlanPage> {
  List<Plan> planlist = [];
  PlanRepo planRepo = PlanRepo();
  final ScrollController _scrollController = ScrollController();
  int mode = 1;
  List<Widget> planBoxList = [];

  List<BarChartGroupData> barChartGroupData = [];

  @override
  void initState() {
    super.initState();

    planRepo.getPlan(widget.userID).then((value) {
      setState(() {
        planlist = parsePlanList(jsonEncode(value.D));
      });
    }).then((value) {
      filter(1);
    }).then((value) async {
      //設定通知
      List<Plan> temp =
          planlist.where((element) => element.isNowPlan()).toList();
      if (temp.length == 1) {
        NotificationPlugin().setCostomize(temp.first);
      }
    });
    planRepo.getExeCount(widget.userID).then((value) {
      List<ExeCount> exeCountList = parseExeCount(jsonEncode(value.D));
      List<BarChartGroupData> temp = [];
      int max = getMaxExecount(exeCountList);
      for (int i = 0; i < 12; i++) {
        int c = 0;
        List<ExeCount> filter =
            exeCountList.where((element) => element.month == (i + 1)).toList();
        if (filter.isNotEmpty) c = filter.first.count;

        temp.add(groupData(i + 1, c.toDouble(), max.toDouble()));
      }
      setState(() {
        barChartGroupData = temp;
      });
      _scrollController.jumpTo(500);
    });
  }

  void filter(int m) {
    List<Widget> result = [];
    for (Plan plan in planlist) {
      //要找現在的=尚未結束計畫
      if (m != 1 && plan.end_date.isAfter(DateTime.now())) {
        continue;
      }
      //要找過去的且該計畫
      if (m != 2 && plan.end_date.isBefore(DateTime.now())) {
        continue;
      }

      result.add(
        Box.boxHasRadius(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          padding: Space.allTen,
          child: Box.planBox(plan, context, widget.userID, m == 2),
        ),
      );
    }
    if (m == 2) {
      result = result.reversed.toList();
    }

    setState(() {
      planBoxList = result;
      mode = m;
    });
  }

  List<Widget> getfilterButtons() {
    List<Widget> result = [];
    final filters = ['近期計畫', "歷史計畫"];
    final filtersID = [1, 2];

    for (int i = 0; i < filters.length; i++) {
      result.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => filter(filtersID[i]),
          child: Box.textRadiusBorder(
            filters[i],
            margin: const EdgeInsets.all(5),
            color: mode == filtersID[i] ? Colors.white : MyTheme.color,
            filling: mode == filtersID[i] ? MyTheme.color : Colors.white,
            border: MyTheme.color,
          ),
        ),
      );
    }
    result.add(Expanded(child: Container()));
    result.add(
      Container(
        // margin: const EdgeInsets.only(left: 255),
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
        decoration: BoxDecoration(
            color: MyTheme.lightColor, borderRadius: BorderRadius.circular(30)),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, PlanInsertPage.routeName),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
              textWidget(
                  text: '新增', type: TextType.content, color: Colors.white)
            ],
          ),
        ),
      ),
    );
    return result;
  }

  BarChartGroupData groupData(int x, double y, double backY) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y,
        color: MyTheme.color,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          toY: backY,
          color: MyTheme.gray,
        ),
      ),
    ]);
  }

  String getTitles(value) {
    switch (value.toInt()) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return "Jui";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      body: ListView(
          children: [
                Box.boxHasRadius(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding: Space.allTen,
                  height: 200,
                  color: Colors.white,
                  child: Column(
                    children: [
                      textWidget(text: '運動次數', type: TextType.content),
                      SizedBox(
                        width: 500,
                        height: 150,
                        child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 750,
                              height: 150,
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    leftTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            getTitles(value),
                                            style: const TextStyle(
                                                // color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                      border: Border.all(
                                          color: Colors.white, width: 0.5)),
                                  alignment: BarChartAlignment.spaceEvenly,
                                  maxY: 16,
                                  barGroups: barChartGroupData,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getfilterButtons(),
                  ),
                ),
              ] +
              planBoxList),
      title: "運動計畫",
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
      buildContext: context,
    );
  }
}
