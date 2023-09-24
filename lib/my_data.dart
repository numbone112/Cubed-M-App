import 'package:flutter/material.dart';

class MyTheme {
  static Color color = const Color(0xff4E707E);
  static Color lightColor = const Color(0xff9AADB5);
  static Color backgroudColor = const Color(0xffF9F9F9);
  static Color titleColor = const Color(0xff5C5C5C);
  static Color hintColor = const Color(0xff969696);
  static Color buttonColor = HexColor("ff023246");
  static Color black = HexColor("575757");
  // static Color pink = HexColor("ED9F8E");
  static Color pink = HexColor("DDA1A1");
  static Color green = HexColor("CAD1A2");
  static Color gray = HexColor("E3E3E3");
}

class MySize {
  static double iconSize = 25;
  static double circularSize = 30;
  static double titleSize = 20;
  static double subtitleSize = 16;
  static double body = 14;
}

Widget MyText({String text = "", int? type, Color? color = Colors.black}) {
  //1:page大標 2:功能文字 3:小標 4:內文 5:提示文字
  if (type == 1) {
    return Text(text,
        style:
            TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color));
  } else if (type == 2) {
    return Text(text,
        style:
            TextStyle(fontSize: 18, color: color));
  } else if (type == 3) {
    return Text(text,
        style: TextStyle(
          fontSize: 16,
          color: color,
        ));
  } else if (type == 4) {
    return Text(text, style: TextStyle(fontSize: 14, color: color));
  } else if (type == 5) {
    return Text(text, style: TextStyle(fontSize: 12, color: color));
  } else
    return Text(text);
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

TextStyle myText({double? fontsize, Color? color, double? height}) {
  return TextStyle(
      color: color ?? Colors.black, fontSize: fontsize, height: height);
}
