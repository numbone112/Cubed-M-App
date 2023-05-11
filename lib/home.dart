
import 'package:e_fu/pages/e/e.dart';
import 'package:e_fu/pages/event/event_home.dart';
import 'package:e_fu/pages/people/people_page.dart';
import 'package:flutter/material.dart';

import 'bottom_bar_view.dart';
import 'module/tabIcon_data.dart';
import 'my_data.dart';


class Home extends StatefulWidget {
  static const routeName = '/home'; 
  const Home({super.key});
  // final String userName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = const EventHome();

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
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          
            resizeToAvoidBottomInset: false,
            backgroundColor:MyTheme.backgroudColor,
      
            body: Container(
              
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Stack(
                
                children: <Widget>[
                  
                  Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),child: tabBody,),
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
                  tabBody = const PeoplePage();
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
              setState(() {
                  tabBody =const Profile();
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
            }
          },
        ),
      ],
    );
  }
}
