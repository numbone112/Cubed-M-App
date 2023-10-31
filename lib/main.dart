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
  String userID = "";

  _loadUser() async {
    if (userID == "") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        if (prefs.containsKey(Name.userID)) {
          userID = prefs.getString(Name.userID) ?? "";
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
          child: userID.isEmpty
              ? const Login()
              : Home(
                  userID: userID,
                ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        Home.routeName: (_) => Home(userID: userID),
        Login.routeName: (_) => const Login(),
        Event.routeName: (_) => Event(userID: userID),
        ProfileUpdate.routeName: (_) => const ProfileUpdate(),
        EventNowResult.routeName: (_) => EventNowResult(userID: userID),
        MoList.routeName: (_) => MoList(userID: userID),
        HindMoList.routeName: (_) => HindMoList(userID: userID),
        InsertInvite.routeName: (_) => InsertInvite(userID: userID),
        Profile.routeName: (_) => Profile(userID: userID),
        // ProfileGoal.routeName: (_) => ProfileGoal(userName: userName),
        InvitePage.routeName: (_) => InvitePage(userID: userID),
        HistoryDetailPerson.routeName: (_) => HistoryDetailPerson(
              userID: userID,
            ),
        HistoryDetailPage.routeName: (_) => HistoryDetailPage(
              userID: userID,
            ),
        PlanPage.routeName: (_) => PlanPage(userID: userID),
        PlanInsertPage.routeName: (_) => PlanInsertPage(userID: userID),
        // MoDetail.routeName: (_) => MoDetail(userName: userName),
      },
    );
  }
}
