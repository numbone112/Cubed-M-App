
import 'package:e_fu/pages/event/eventHome.dart';
import 'package:e_fu/pages/people/people.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_bar_view.dart';
import 'module/tabIcon_data.dart';
import 'myData.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  // final String userName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = EventHome();

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    super.initState();
    // tabBody = EventScreen(animationController: animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            
            tabBody,
            bottomBar(),
          ],
        ));
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
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
                  tabBody =const People();
                });
              });
            }else if(index==1){
                // if (!mounted) {
                //   return;
                // }
                setState(() {
                  tabBody =const EventHome();
                });
            }else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                // if (!mounted) {
                //   return;
                // }
                setState(() {
                  tabBody = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Center(
                        child: ElevatedButton(
                          style:ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.dartColor
                          ), 
                          // ButtonStyle(
                          //   col: MyTheme.color
                          // ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  prefs.clear();
                                  Navigator.popAndPushNamed(context, "welcome");
                            },
                            child: Text("登出")),
                      )
                    ],
                  );
                });
              });
            }
          },
        ),
      ],
    );
  }
}
