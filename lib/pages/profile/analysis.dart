import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:ele_progress/ele_progress.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyEarnings extends StatelessWidget {
  final List<Color> gradientColors = const [
    Color.fromARGB(255, 5, 122, 189),
    Color(0xff02d39a),
  ];

  static Map<int, String> monthMap = const {
    0: '5月',
    1: '6月',
    2: '7月',
    3: "8月",
    4: '9月',
    5: '10月',
    6: "11月"
  };

  static Map<int, String> moneyMap = const {
    -2: '很差',
    -1: '差',
    0: '普通',
    1: '好',
    2: '很好',
  };

  const DailyEarnings({super.key});

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
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: EProgress(
                    progress: 88,
                    colors: [MyTheme.buttonColor],
                    showText: true,
                    format: (progress) {
                      return '88%';
                    },
                    type: ProgressType.dashboard,
                    backgroundColor: Colors.grey,
                  ),
                ),
                textWidget(text: '運動達成率', type: TextType.sub),
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
                      return '  好\n4.12';
                    },
                    type: ProgressType.dashboard,
                    // textStyle: TextStyle(),
                    backgroundColor: Colors.grey,
                  ),
                ),
                textWidget(text: '平均等級', type: TextType.sub),
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
        textWidget(text: '歷程等級與預測', type: TextType.sub),
      ]),
    );
  }

  LineChartData mainData() {
    double nowScaleDouble = 4;
    return LineChartData(
      extraLinesData: ExtraLinesData(
        verticalLines: [
          VerticalLine(
            x: nowScaleDouble,
            color: const Color.fromRGBO(197, 0, 0, 1),
            strokeWidth: 2,
            dashArray: [5, 10],
            label: VerticalLineLabel(
              show: true,
              alignment: const Alignment(1, 0.5),
              padding: const EdgeInsets.only(left: 10, top: 5),
              labelResolver: (line) => "now",
            ),
          ),
        ],
      ),
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
      minX: 0,
      maxX: 6,
      minY: -2,
      maxY: 2,
      lineBarsData: [
        LineChartBarData(
          color: MyTheme.color,
          spots: [
            const FlSpot(0, -2),

            const FlSpot(1, -1),
            const FlSpot(2, -1),
            // FlSpot(2, 4),
            const FlSpot(3, 1),
            const FlSpot(4, 0),
            const FlSpot(5.1, 1.5),
            const FlSpot(5.8, 1.7),
          ],
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
