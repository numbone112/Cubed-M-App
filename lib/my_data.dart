
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

class TextType {
  static const int page = 1;
  static const int fun = 2;
  static const int sub = 3;
  static const int content = 4;
  static const int hint = 5;
}

Widget textWidget(
    {String text = "",
    int? type = TextType.content,
    Color? color = Colors.black,
    TextAlign? textAlign = TextAlign.left,
    bool fontWeight = false}) {
  switch (type) {
    //1:page大標 2:功能文字 3:小標 4:內文 5:提示文字
    case TextType.page:
      return Text(text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: textAlign);
    case TextType.fun:
      return Text(text,
          style: TextStyle(
              fontSize: 20,
              color: color,
              fontWeight: fontWeight ? FontWeight.bold : null),
          textAlign: textAlign);
    case TextType.sub:
      return Text(text,
          style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: fontWeight ? FontWeight.bold : null),
          textAlign: textAlign);
    case TextType.content:
      return Text(text,
          style: TextStyle(fontSize: 14, color: color), textAlign: textAlign);

    case TextType.hint:
      return Text(text,
          style: TextStyle(fontSize: 12, color: color), textAlign: textAlign);
    default:
      return Text(text,
          style: TextStyle(fontSize: 14, color: color), textAlign: textAlign);
  }
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

TextStyle textStyle({double? fontsize, Color? color, double? height}) {
  return TextStyle(
      color: color ?? Colors.black, fontSize: fontsize, height: height);
}
