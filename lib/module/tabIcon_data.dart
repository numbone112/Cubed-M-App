import 'package:flutter/animation.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.title = '',
    this.isSelected = true,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  String title;
  bool isSelected;
  int index;
  // IconData icon;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/images/friend_outlined.png',
      selectedImagePath: 'assets/images/friend.png',
      title:'復健者',
      index: 0,
      isSelected: false,
      animationController: null,
      
    ),
    TabIconData(
      imagePath: 'assets/images/home_outlined.png',
      selectedImagePath: 'assets/images/home.png',
      title:'首頁',
      index: 1,
      isSelected: false,
      animationController: null,
      
    ),
    TabIconData(
      imagePath: 'assets/images/user_outlined.png',
      selectedImagePath: 'assets/images/user.png',
      title:'復健師',
      index: 2,
      isSelected: false,
      animationController: null,
      
    ),
     TabIconData(
      imagePath: 'assets/images/user_outlined.png',
      selectedImagePath: 'assets/images/user.png',
      title:'New',
      index: 3,
      isSelected: false,
      animationController: null,
      
    ),
  ];

static List<TabIconData> newAppList = <TabIconData>[
   TabIconData(
      imagePath: 'assets/images/home_outlined.png',
      selectedImagePath: 'assets/images/home.png',
      title: '首頁',
      index: 0,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/images/friend_outlined.png',
      selectedImagePath: 'assets/images/friend.png',
      title: 'Mo 伴',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/images/exercise_outline.png',
      selectedImagePath: 'assets/images/exercise.png',
      title: '運動',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
   
    TabIconData(
      imagePath: 'assets/images/user_outlined.png',
      selectedImagePath: 'assets/images/user.png',
      title: '其他',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
