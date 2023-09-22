import 'dart:convert';
import 'dart:math';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/plan/plan_insert.dart';

import 'package:e_fu/pages/profile/profile_update.dart';
import 'package:e_fu/request/plan/plan.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PlanPage extends StatefulWidget {
  static const routeName = '/plan';
  final String userName;
  const PlanPage({super.key, required this.userName});

  @override
  PlanState createState() => PlanState();
}

class PlanState extends State<PlanPage> {
  List<Plan> plan_list = [];
  PlanRepo planRepo = PlanRepo();

  List<Widget> planBoxList() {
    List<Widget> result = [];
    for (var plan in plan_list) {
      result.add(Box.boxHasRadius(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
        padding: const EdgeInsets.all(10),
        child: Box.planBox(plan, context),
      ));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();

    planRepo.getPlan(widget.userName).then((value) {
      setState(() {
        plan_list = parsePlanList(jsonEncode(value.D));
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
          color: MyTheme.hintColor,
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView(
            children: [
                  Box.boxHasRadius(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      padding: const EdgeInsets.all(10),
                      height: 200,
                      width: 500,
                      color: Color(0xFFFFFFFF),
                      child: Column(
                        children: [
                          Text("運動長條圖"),
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
                                        style: TextStyle(
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, PlanInsertPage.routeName),
                      child: Text(
                        "+新增  ",
                        style: TextStyle(color: MyTheme.color),
                      ),
                    ),
                  ),
                ] +
                planBoxList()),
      ),
      title: "運動計畫",
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
      buildContext: context,
    );
  }
}
