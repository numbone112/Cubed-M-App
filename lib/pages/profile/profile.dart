import 'package:e_fu/main.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/mo/mo_list.dart';
import 'package:e_fu/pages/plan/plan.dart';
import 'package:e_fu/pages/profile/analysis.dart';
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

class SubMenu {
  SubMenu({required this.title, this.function, required this.img, this.widget});
  final String title;
  final String img;
  Widget? widget;
  Function()? function;
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

  List<Widget> intos() {
    List<Widget> result = [];
    List<SubMenu> subMenus = [
      SubMenu(
          title: "個人檔案",
          img: "assets/images/profile.png",
          function: () => Navigator.pushNamed(context, Profile.routeName,
              arguments: profile)),
      SubMenu(
          title: "成效分析",
          img: "",
          function: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => DailyEarnings(),
                ),
              ),
          widget: Icon(Icons.accessibility_new_rounded)),
      SubMenu(
          title: "管理運動計畫",
          img: "assets/images/target.png",
          function: () => Navigator.pushNamed(context, PlanPage.routeName,
              arguments: profile)),
      // SubMenu(
      //   title: "設定",
      //   img: "assets/images/setting.png",
      //   function: () => setTarget(),
      // ),
      SubMenu(
        title: "登出",
        img: "assets/images/logout.png",
        function: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove(Name.userName);
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const MyApp(),
              ),
            );
          }
        },
      )
    ];

    for (var element in subMenus) {
      result.add(
        Box.boxHasRadius(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          height: 70,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: element.function,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: element.widget ??
                      Image.asset(
                        element.img,
                        scale: 2.0,
                      ),
                ),
                Text(
                  element.title,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return result;
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
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "其他",
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ScrollConfiguration(
          behavior: CusBehavior(),
          child: SingleChildScrollView(
            child: (Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                    (profile == null)
                        ? Box.boxHasRadius(
                            height: MediaQuery.of(context).size.height * 0.33,
                            color: MyTheme.backgroudColor,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: MyTheme.lightColor,
                            )),
                          )
                        : Box.boxHasRadius(
                            height: MediaQuery.of(context).size.height * 0.25,
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(0),
                                    ),
                                    color: MyTheme.color,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.33,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 40, 20, 20),
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 20),
                                          child: MyText(
                                              text: profile!.name,
                                              type: TextType.sub,
                                              color: Colors.white),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: MyText(
                                                text:
                                                    "性別：${profile!.sex != "female" ? "男" : "女"}",
                                                type: TextType.content,
                                                color: Colors.white)),
                                        MyText(
                                            text:
                                                "年齡：${DateTime.now().year - profile!.birthday.year}",
                                            type: TextType.content,
                                            color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    width: 150,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
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
                                                    text: '下肢',
                                                    angle: usedAngle);
                                              default:
                                                return const RadarChartTitle(
                                                    text: '');
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
                                                  ? MyTheme.lightColor
                                                      .withOpacity(0.5)
                                                  // rawDataSet.color.withOpacity(0.2)
                                                  : rawDataSet.color
                                                      .withOpacity(0.05),
                                              borderColor: isSelected
                                                  ? Colors.white
                                                      .withOpacity(0.8)
                                                  // rawDataSet.color
                                                  : rawDataSet.color
                                                      .withOpacity(0.25),
                                              entryRadius: isSelected ? 3 : 2,
                                              dataEntries: rawDataSet.values
                                                  .map((e) =>
                                                      RadarEntry(value: e))
                                                  .toList(),
                                              borderWidth: isSelected ? 2.3 : 2,
                                            );
                                          }).toList()),
                                      swapAnimationDuration: const Duration(
                                          milliseconds: 150), // Optional
                                      swapAnimationCurve:
                                          Curves.linear, // Optional
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ] +
                  intos(),
            )),
          ),
        ),
      ),
    );
  }
}
