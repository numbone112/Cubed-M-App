import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/plan/plan.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:ele_progress/ele_progress.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatefulWidget {
  final String userId;
  final List<Color> gradientColors = const [
    Color.fromARGB(255, 5, 122, 189),
    Color(0xff02d39a),
  ];

  const AnalysisPage({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => AnalysisPageState();
}

class AnalysisPageState extends State<AnalysisPage> {
  PlanRepo planRepo = PlanRepo();
  AnalysisChart _analysisChart = AnalysisChart();
  static Map<int, String> monthMap = const {
    1: '1月',
    2: '2月',
    3: '3月',
    4: '4月',
    5: '5月',
    6: '6月',
    7: '7月',
    8: "8月",
    9: '9月',
    10: '10月',
    11: "11月",
    12: "12月"
  };

  static Map<int, String> moneyMap = const {
    -2: '不好',
    -1: '差',
    0: '普通',
    1: '尚好',
    2: '很好',
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planRepo.getChart(widget.userId).then((value) {
      setState(() {
        _analysisChart =
            AnalysisChart.fromJson(jsonDecode(jsonEncode(value.D)));
      });
      print(_analysisChart.runChart
          .map((e) => FlSpot(double.parse(e.id.split("-")[1]), e.avg))
          .toList()
          .length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      safeAreaColor: MyTheme.lightColor,
      title: "成效分析",
      headTextColor: Colors.white,
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      buildContext: context,
      body: Column(children: [
        Space.tenPadding(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: EProgress(
                    progress: _analysisChart.sportRate(),
                    colors: [MyTheme.buttonColor],
                    showText: true,
                    format: (progress) {
                      return '${_analysisChart.sportRate()}%';
                    },
                    type: ProgressType.dashboard,
                    backgroundColor: MyTheme.gray,
                  ),
                ),
                textWidget(text: '運動達成率', type: TextType.content),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: EProgress(
                    progress: 412 ~/ 5,
                    colors: [MyTheme.buttonColor],
                    showText: true,
                    format: (progress) {
                      return ' 好\n3.5';
                    },
                    type: ProgressType.dashboard,
                    // textStyle: TextStyle(),
                    backgroundColor: MyTheme.gray,
                  ),
                ),
                textWidget(text: '平均等級', type: TextType.content),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(mainData()),
                  ),
                ),
              ),
            ],
          ),
        ),
        textWidget(text: '歷程等級趨勢圖', type: TextType.content),
      ]),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(100, 100, 100, 100),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(100, 100, 100, 100),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, meta) {
              String? month = monthMap[value.toInt()];

              return Text(month ?? "");
            },
          )),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, meta) {
              String? money = moneyMap[value.toInt()];

              return Text(money ?? "");
            },
          ))),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 10,
      maxX: 12,
      minY: -2,
      maxY: 2,
      baselineX: 10,
      lineBarsData: [
        LineChartBarData(
          color: MyTheme.color,
          spots: _analysisChart.runChart
              .map((e) => FlSpot(double.parse(e.id.split("-")[1]), e.avg))
              .toList(),
          isCurved: true,
          // colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            // colors:
            //     gradientColors.map((color) => color.withOpacity(0.2)).toList(),
          ),
        ),
      ],
    );
  }
}
