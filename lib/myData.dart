import 'package:flutter/material.dart';




class MyTheme{

static Color color= const Color.fromRGBO(216, 232, 216, 1);
static Color dartColor=const Color.fromRGBO(10, 112, 41, 1);
}

class Name{
  static String userName="user_name";

  
}

class PageName{
  static String  welcome="welcome";
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


