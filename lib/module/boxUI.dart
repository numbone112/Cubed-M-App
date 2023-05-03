import 'package:flutter/material.dart';

class BoxUI {
  static Widget boxHasRadius(
      {Color? color,
      double? height,
      double? width,
      required Widget child,
      Color? backColor,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding}) {
    return Container(
      
      decoration: BoxDecoration(
        
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: color ?? Colors.white),
      height: height,
      width: width,
      child: child,
      margin: margin,
      padding: padding,
    );
  }

  static Widget boxWithTitle(String title, Widget child) {
    return (Column(
      children: [Text(title), const Padding(padding: EdgeInsets.all(5)), child],
    ));
  }
}