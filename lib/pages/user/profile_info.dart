
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/mo/mo_list.dart';
import 'package:e_fu/request/user/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../module/cusbehiver.dart';
import '../../request/user/get_user_model.dart';

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
  GetUserModel? profile;
  UserRepo userRepo = UserRepo();
  var logger = Logger();
  List<RawDataSet> rawDataSetList = [
    RawDataSet(title: "復健者", color: Colors.blue, values: [5, 3, 1])
  ];

  getProfile() {
    EasyLoading.show(status: 'loading...');
    try {
      userRepo.getUser(widget.userName).then((value) {
        setState(() {
          profile = value;
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
        ? Container(
            color: MyTheme.backgroudColor,
            child: Center(
                child: CircularProgressIndicator(
              color: MyTheme.lightColor,
            )),
          )
        : ScrollConfiguration(
            behavior: CusBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: (Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BoxUI.titleText("個人資訊", 15, fontSize: MySize.titleSize),
                    BoxUI.boxHasRadius(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                profile!.d.name,
                                // textAlign: TextAlign.center,
                                style: myText(
                                    color: Colors.white,
                                    fontsize: MySize.subtitleSize),
                              ),
                              Text(
                                "性別：${profile!.d.sex != "female" ? "男" : "女"}",
                                // textAlign: TextAlign.center,

                                style: myText(color: Colors.white),
                              ),
                              Text(
                                "年齡：${DateTime.now().year - profile!.d.birthday.year}",
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
                                  dataSets: rawDataSetList
                                      .asMap()
                                      .entries
                                      .map((entry) {
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
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                child: Image.asset('assets/images/profile.png',
                                    scale: 2.0),
                              ),
                              Text("個人檔案", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        )),
                    BoxUI.boxHasRadius(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                child: Image.asset('assets/images/target.png',
                                    scale: 2.0),
                              ),
                              Text("管理目標", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        )),
                    GestureDetector(
                      child: BoxUI.boxHasRadius(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                          height: 70,
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                  child: Image.asset(
                                      'assets/images/setting_friend.png',
                                      scale: 2.0),
                                ),
                                Text("管理Mo伴", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          )),
                      onTap: () {
                        Navigator.pushNamed(context, MoList.routeName,
                            arguments: widget.userName);
                      },
                    ),
                    BoxUI.boxHasRadius(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                              child: Image.asset('assets/images/setting.png',
                                  scale: 2.0),
                            ),
                            Text("設定", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    BoxUI.boxHasRadius(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                child: Image.asset('assets/images/logout.png',
                                    scale: 2.0),
                              ),
                              Text("登出", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        )),
                  ],
                )),
              ),
            ),
          );
  }
}
