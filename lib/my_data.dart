import 'package:flutter/material.dart';

class MyTheme {
  static Color color = const Color(0xff4E707E);
  static Color lightColor = const Color(0xff9AADB5);
  static Color backgroudColor = const Color(0xffF9F9F9);
  static Color titleColor = const Color(0xff5C5C5C);
  static Color hintColor = const Color(0xff969696);
  static Color buttonColor=const Color(0xff023246);
  static Color black =HexColor("575757");
}

class MySize {
  static double iconSize = 25;
  static double circularSize = 30;
  static double titleSize = 20;
  static double subtitleSize = 16;
  static double body = 14;
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

TextStyle myText({double? fontsize,Color? color,double? height}){
  return TextStyle(color: color??Colors.black,fontSize: fontsize,height: height);
}

