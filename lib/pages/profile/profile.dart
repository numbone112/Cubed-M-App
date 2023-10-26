import 'package:e_fu/main.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/plan/plan.dart';
import 'package:e_fu/pages/profile/analysis.dart';
import 'package:e_fu/pages/profile/profile_edit.dart';
import 'package:e_fu/request/user/account.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../module/cusbehiver.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key, required this.userName});
  final String userName;

  @override
  ProfileCreateState createState() => ProfileCreateState();
}

// class RawDataSet {
//   RawDataSet({
//     required this.title,
//     required this.color,
//     required this.values,
//   });

//   final String title;
//   final Color color;
//   final List<double> values;
// }

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
                  builder: (BuildContext context) => const DailyEarnings(),
                ),
              ),
          widget: const Icon(Icons.accessibility_new_rounded)),
      SubMenu(
          title: "管理運動計畫",
          img: "assets/images/target.png",
          function: () => Navigator.pushNamed(context, PlanPage.routeName,
              arguments: profile)),
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
          
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: element.function,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: element.widget ??
                      Image.asset(
                        element.img,
                        scale: 2.0,
                      ),
                ),
                Text(
                  element.title,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "其他",
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: SingleChildScrollView(
          child: (Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                  (profile == null)
                      ? Box.boxHasRadius(
                          // height: MediaQuery.of(context).size.height * 0.33,
                          color: MyTheme.backgroudColor,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: MyTheme.lightColor,
                          )),
                        )
                      : Box.boxHasRadius(
                          // height: MediaQuery.of(context).size.height * 0.25,
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: MyTheme.color,
                            ),
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
                                    child: textWidget(
                                        text: profile!.name,
                                        type: TextType.sub,
                                        color: Colors.white),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: textWidget(
                                          text:
                                              "性別：${profile!.sex != "female" ? "男" : "女"}",
                                          type: TextType.content,
                                          color: Colors.white)),
                                  textWidget(
                                      text:
                                          "年齡：${DateTime.now().year - profile!.birthday.year}",
                                      type: TextType.content,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                ] +
                intos(),
          )),
        ),
      ),
    );
  }
}
