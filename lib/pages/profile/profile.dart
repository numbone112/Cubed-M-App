import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key, required this.userName});
  final String userName;

  @override
  ProfileCreateState createState() => ProfileCreateState();
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}

class ProfileCreateState extends State<ProfileInfo> {
  ProfileData? profile;
  ERepo eRepo = ERepo();
  var logger = Logger();
  List<RawDataSet> rawDataSetList = [
    RawDataSet(title: "復健者", color: Colors.blue, values: [5, 3, 1])
  ];

  getProfile() {
    EasyLoading.show(status: 'loading...');
    try {
      eRepo.getProfile(widget.userName).then((value) {
        setState(() {
          profile = parseProfile(value.D);
        });
        EasyLoading.dismiss();
      });
    } catch (e) {
      logger.v(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      getProfile();
    }
    return (profile == null)
        ? Container()
        : CustomPage(
            body: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                children: [
                  BoxUI.boxHasRadius(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    height: 200,
                    color: MyTheme.lightColor,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profile!.name,
                              // textAlign: TextAlign.center,

                              style: myText(color: Colors.white),
                            ),
                            Text(
                              "性別",
                              // textAlign: TextAlign.center,

                              style: myText(color: Colors.white),
                            ),
                            Text(
                              "age",
                              // textAlign: TextAlign.center,

                              style: myText(color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
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
                                dataSets:
                                    rawDataSetList.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final rawDataSet = entry.value;

                                  final isSelected = true;

                                  return RadarDataSet(
                                    fillColor: isSelected
                                        ? rawDataSet.color.withOpacity(0.2)
                                        : rawDataSet.color.withOpacity(0.05),
                                    borderColor: isSelected
                                        ? rawDataSet.color
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
                        )
                      ],
                    ),
                  ),
                  BoxUI.boxHasRadius(
                      margin: const EdgeInsets.all(10),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Center(child: Text("個人檔案")),
                      )),
                  BoxUI.boxHasRadius(
                      margin: const EdgeInsets.all(10),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Center(child: Text("管理目標")),
                      )),
                  BoxUI.boxHasRadius(
                      margin: const EdgeInsets.all(10),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Center(child: Text("Mo伴管理")),
                      )),
                  BoxUI.boxHasRadius(
                      margin: const EdgeInsets.all(10),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Center(child: Text("設定檔案")),
                      )),
                  BoxUI.boxHasRadius(
                      margin: const EdgeInsets.all(10),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Center(child: Text("登出")),
                      )),
                ],
              ),
            ),
            title: "個人資訊");
  }
}
