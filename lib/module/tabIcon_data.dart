import 'package:flutter/material.dart';

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
      imagePath: 'assets/images/f_user_outlined.png',
      selectedImagePath: 'assets/images/f_user.png',
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
      imagePath: 'assets/images/e_user_outlined.png',
      selectedImagePath: 'assets/images/e_user.png',
      title:'復健師',
      index: 2,
      isSelected: false,
      animationController: null,
      
    ),
  ];
}
