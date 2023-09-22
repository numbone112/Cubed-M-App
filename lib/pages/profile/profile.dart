import 'package:e_fu/main.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/mo/mo_list.dart';
import 'package:e_fu/pages/plan/plan.dart';
import 'package:e_fu/pages/profile/profile_edit.dart';
import 'package:e_fu/pages/profile/profile_goal.dart';
import 'package:e_fu/request/user/account.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../module/cusbehiver.dart';

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
  GetUser? profile;
  UserRepo userRepo = UserRepo();
  var logger = Logger();
  List<RawDataSet> rawDataSetList = [
    RawDataSet(title: "復健者", color: Colors.blue, values: [5, 3, 1])
  ];

  getProfile() {
    try {
      userRepo.getUser(widget.userName).then((value) {
        setState(() {
          profile = GetUser.fromJson(value.D);
        });
      });
    } catch (e) {
      logger.v(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Widget setsBox(String title, TextEditingController controller) {
    return Row(
      children: [
        Text(title),
        Expanded(child: TextInput.radius("組數", controller))
      ],
    );
  }

  setTarget() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //shape 可以改變形狀
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0))),
            title: Text("設定運動組數"),

            content: Container(
                height: 300,
                width: 300,
                child: Column(
                  children: [
                    // TextInput.radius("text", TextEditingController()),
                    setsBox("左手", TextEditingController()),
                    setsBox("右手", TextEditingController()),
                    setsBox("椅子坐立", TextEditingController()),

                    Box.yesnoBox(() {}, () {})
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
                    Box.titleText("個人資訊", gap: 15, fontSize: MySize.titleSize),
                    Box.boxHasRadius(
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
                                profile!.name,
                                // textAlign: TextAlign.center,
                                style: myText(
                                    color: Colors.white,
                                    fontsize: MySize.subtitleSize),
                              ),
                              Text(
                                "性別：${profile!.sex != "female" ? "男" : "女"}",
                                // textAlign: TextAlign.center,

                                style: myText(color: Colors.white),
                              ),
                              Text(
                                "年齡：${DateTime.now().year - profile!.birthday.year}",
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
                    Box.boxHasRadius(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, Profile.routeName,
                              arguments: profile),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                child: Image.asset(
                                  'assets/images/profile.png',
                                  scale: 2.0,
                                ),
                              ),
                              const Text(
                                "個人檔案",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )),
                    Box.boxHasRadius(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, PlanPage.routeName,
                              arguments: profile),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                child: Image.asset('assets/images/target.png',
                                    scale: 2.0),
                              ),
                              const Text("管理計畫",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        )),
                    GestureDetector(
                      child: Box.boxHasRadius(
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
                              const Text("管理Mo伴",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, MoList.routeName,
                            arguments: widget.userName);
                      },
                    ),
                    Box.boxHasRadius(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => setTarget(),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                              child: Image.asset('assets/images/setting.png',
                                  scale: 2.0),
                            ),
                            const Text("設定", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    Box.boxHasRadius(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove(Name.userName);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const MyApp(),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                child: Image.asset('assets/images/logout.png',
                                    scale: 2.0),
                              ),
                              const Text("登出", style: TextStyle(fontSize: 16)),
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