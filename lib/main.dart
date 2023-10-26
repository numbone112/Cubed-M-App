import 'package:e_fu/home.dart';
import 'package:e_fu/pages/event/event_now_result.dart';

import 'package:e_fu/pages/exercise/detail.dart';
import 'package:e_fu/pages/exercise/history.dart';
import 'package:e_fu/pages/exercise/insert.dart';
import 'package:e_fu/pages/exercise/invite.dart';
import 'package:e_fu/pages/mo/hide_mo_list.dart';
import 'package:e_fu/pages/mo/mo_detail.dart';
import 'package:e_fu/pages/mo/mo_list.dart';
import 'package:e_fu/pages/plan/plan.dart';
import 'package:e_fu/pages/plan/plan_insert.dart';
import 'package:e_fu/pages/profile/profile_edit.dart';
import 'package:e_fu/pages/profile/profile_goal.dart';
import 'package:e_fu/pages/profile/profile_update.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:e_fu/pages/event/event.dart';
import 'package:e_fu/sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'my_data.dart';

void main() {
  runApp(const MyApp());
  const MyApp();
  EasyLoading.instance
    ..indicatorColor = Colors.white
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 90.0
    ..maskType = EasyLoadingMaskType.custom
    // ..displayDuration = const Duration(seconds: 2)
    // ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskColor = Colors.grey.withOpacity(0.5)
    ..userInteractions = true
    ..backgroundColor = MyTheme.backgroudColor
    ..indicatorWidget = SpinKitWaveSpinner(
      color: MyTheme.backgroudColor,
      trackColor: MyTheme.color,
      waveColor: MyTheme.buttonColor,
    )
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => MyappState();
}

class MyappState extends State<MyApp> {
  String userName = "";

  _loadUser() async {
    if (userName == "") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        if (prefs.containsKey(Name.userName)) {
          userName = prefs.getString(Name.userName) ?? "";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "taipei"),
      builder: EasyLoading.init(),
      color: MyTheme.backgroudColor,
      home: Container(
        color: MyTheme.backgroudColor,
        child: SafeArea(
          bottom: false,
          child: userName.isEmpty
              ? const Login()
              : Home(
                  userName: userName,
                ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        Home.routeName: (_) => Home(userName: userName),
        Login.routeName: (_) => const Login(),
        Event.routeName: (_) => Event(userName: userName),
        ProfileUpdate.routeName: (_) => const ProfileUpdate(),
        EventNowResult.routeName: (_) => EventNowResult(userName: userName),
        MoList.routeName: (_) => MoList(userName: userName),
        HindMoList.routeName: (_) => HindMoList(userName: userName),
        InsertInvite.routeName: (_) => InsertInvite(userName: userName),
        Profile.routeName: (_) => Profile(userName: userName),
        // ProfileGoal.routeName: (_) => ProfileGoal(userName: userName),
        InvitePage.routeName: (_) => InvitePage(userName: userName),
        HistoryDetailPerson.routeName: (_) => HistoryDetailPerson(
              userName: userName,
            ),
        HistoryDetailPage.routeName: (_) => HistoryDetailPage(
              userName: userName,
            ),
        PlanPage.routeName: (_) => PlanPage(userName: userName),
        PlanInsertPage.routeName: (_) => PlanInsertPage(userName: userName),
        // MoDetail.routeName: (_) => MoDetail(userName: userName),
      },
    );
  }
}
