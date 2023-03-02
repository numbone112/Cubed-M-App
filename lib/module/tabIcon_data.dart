import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.icon = Icons.offline_bolt_outlined,
    this.index = 0,
    this.selectedIcon = Icons.offline_bolt,
    this.isSelected = true,
    this.animationController,
  });

  // String imagePath;
  IconData selectedIcon;
  bool isSelected;
  int index;
  IconData icon;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      icon: Icons.hide_image_outlined,
      
      selectedIcon: Icons.hide_image,
      index: 0,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      icon: Icons.home_outlined,
      
      selectedIcon: Icons.home,
      index: 1,
      isSelected: false,
      animationController: null,
    ),
     TabIconData(
      icon: Icons.enhance_photo_translate_outlined,
      
      selectedIcon: Icons.enhance_photo_translate_sharp,
      index: 2,
      isSelected: false,
      animationController: null,
    ),
   
  ];
}
