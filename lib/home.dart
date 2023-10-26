import 'package:e_fu/pages/exercise/exercise.dart';
import 'package:e_fu/pages/home/home_page.dart';
import 'package:e_fu/pages/mo/mo.dart';
import 'package:e_fu/pages/profile/profile.dart';
import 'package:flutter/material.dart';

import 'bottom_bar_view.dart';
import 'module/tab_icon_data.dart';
import 'my_data.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({super.key, required this.userName});
  final String userName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.newAppList;
  late Widget tabBody;

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    super.initState();
    tabBody = const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: MyTheme.backgroudColor,
            body: bottomBar(),
          )),
    );
  }

  Widget bottomBar() {
    return Column(
      children: [
        Expanded(
          child: tabBody,
        ),
        SizedBox(
          height: 64,
          child: BottomBarView(
            tabIconsList: tabIconsList,
            changeIndex: (int index) {
              if (index == 0) {
                animationController?.reverse().then<dynamic>((data) {
                  // if (!mounted) {
                  //   return;
                  // }
                  setState(() {
                    tabBody = const HomePage();
                  });
                });
              } else if (index == 1) {
                // if (!mounted) {
                //   return;
                // }
                setState(() {
                  tabBody =  Mo(userName: widget.userName,);
                });
              } else if (index == 2) {
                setState(() {
                  tabBody = ExerciseHome(
                    userName: widget.userName,
                  );
                });
              } else if (index == 3) {
                setState(() {
                  tabBody = ProfileInfo(
                    userName: widget.userName,
                  );
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
