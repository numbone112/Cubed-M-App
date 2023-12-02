import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/plan/plan_edit.dart';
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

  List<Widget> planBoxList() {
    List<Widget> result = [];
    for (var plan in planlist) {
      result.add(
        Box.boxHasRadius(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          padding: Space.allTen,
          child: Box.planBox(plan, context, widget.userID),
        ),
      );
    }
    return result;
  }

  @override
  void initState() {
    super.initState();

    planRepo.getPlan(widget.userID).then((value) {
      setState(() {
        planlist = parsePlanList(jsonEncode(value.D));
        barChartGroupData = [
          groupData(1, 5, 10),
          groupData(2, 5, 10),
          groupData(3, 3, 10),
          groupData(4, 8, 10),
          groupData(5, 7, 10),
          groupData(6, 4, 10),
        ];
      });
    });
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

  List<BarChartGroupData> barChartGroupData = [];

  String getTitles(value) {
    switch (value.toInt()) {
      case 1:
        return 'Apr';
      case 2:
        return 'May';
      case 3:
        return 'Jun';
      case 4:
        return 'Jul';
      case 5:
        return 'Aug';
      case 6:
        return 'Sep';
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
                    width: 500,
                    color: const Color(0xFFFFFFFF),
                    child: Column(
                      children: [
                        textWidget(text: '運動次數', type: TextType.content),
                        SizedBox(
                          width: 500,
                          height: 150,
                          child: BarChart(BarChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
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
                          )),
                        ),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 255),
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                  decoration: BoxDecoration(
                      color: MyTheme.lightColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, PlanInsertPage.routeName),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        textWidget(
                            text: '新增',
                            type: TextType.content,
                            color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ] +
              planBoxList()),
      title: "運動計畫",
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
      buildContext: context,
    );
  }
}
