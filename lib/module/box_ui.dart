import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';

class BoxUI {
  static Widget boxHasRadius(
      {Color? color,
      double? height,
      double? width,
      required Widget child,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: color ?? Colors.white,
      ),
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      child: child,
    );
  }

  static Widget boxWithTitle(String title, Widget child) {
    return (Column(
      children: [Text(title), const Padding(padding: EdgeInsets.all(5)), child],
    ));
  }

  static Widget titleText(String title, double gap,
      {AlignmentGeometry? alignment, double? fontSize,
      Color? color
      }) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(0, gap, 0, gap),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize,color: color),
        textAlign: TextAlign.left,
      ),
    );
  }
  static Widget inviteBox(Invite invite){
  return (BoxUI.boxHasRadius(child: Row(
    children: [
      Column(children: [
        Text(invite.name),
        Text(invite.time.toString()),
        Text(invite.people),
        Text(invite.remark)
      ],),
      GestureDetector(child: Icon(Icons.cancel_sharp),),
      GestureDetector(child: Icon(Icons.check),),
    ],
  )));
}
}

