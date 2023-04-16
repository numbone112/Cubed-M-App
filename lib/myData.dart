import 'package:flutter/material.dart';

class MyTheme {
  static Color color = Color(0xff4E707E);
  static Color lightColor = Color(0xff9AADB5);
  static Color backgroudColor = Color(0xffF4F5F7);
  static Color titleColor = Color(0xff5C5C5C);
  static Color hintColor = Color(0xff969696);
}

class MySize {
  static double iconSize = 25;
  static double circularSize = 30;
}

class Name {
  static String userName = "user_name";
}

class PageName {
  static String welcome = "welcome";
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
