import 'package:e_fu/n_home.dart';
import 'package:e_fu/pages/e/e.dart';
import 'package:e_fu/pages/event/event_home.dart';
import 'package:e_fu/pages/event/event_result.dart';
import 'package:e_fu/pages/people/people_page.dart';
import 'package:flutter/material.dart';

import 'bottom_bar_view.dart';
import 'module/tabIcon_data.dart';
import 'my_data.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
   Home({super.key,required this.userName});
   String userName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  late Widget tabBody ;

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    super.initState();
    tabBody = EventHome(userName: widget.userName,);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: MyTheme.backgroudColor,
            body: Container(
              child: Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              ),
            )),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(
            height: 1,
          ),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                // if (!mounted) {
                //   return;
                // }
                setState(() {
                  tabBody =  PeoplePage(userName: widget.userName,);
                });
              });
            } else if (index == 1) {
              // if (!mounted) {
              //   return;
              // }
              setState(() {
                tabBody =  EventHome(userName: widget.userName,);
              });
            } else if (index == 2) {
              setState(() {
                tabBody =  Profile(userName: widget.userName,);
              });
              // animationController?.reverse().then<dynamic>((data) {

              //   setState(() {
              //     tabBody = Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [

              //         Center(
              //           child: ElevatedButton(
              //             style:ElevatedButton.styleFrom(
              //               backgroundColor: MyTheme.color
              //             ),

              //               onPressed: () async {
              //                 SharedPreferences prefs =
              //                     await SharedPreferences.getInstance();
              //                     prefs.clear();
              //                     Navigator.popAndPushNamed(context, "welcome");
              //               },
              //               child: Text("登出")),
              //         )
              //       ],
              //     );
              //   });
              // });
            } else if (index == 3) {
              Navigator.pushNamed(context, NewHome.routeName);
            }
          },
        ),
      ],
    );
  }
}
