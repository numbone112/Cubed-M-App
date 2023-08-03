import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/exercise/invite_data.dart';
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
      {AlignmentGeometry? alignment, double? fontSize, Color? color}) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(0, gap, 0, gap),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: fontSize, color: color),
        textAlign: TextAlign.left,
      ),
    );
  }

  static Widget inviteBox(Invite invite) {
    return (BoxUI.boxHasRadius(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  invite.name,
                  style: TextStyle(
                      color: MyTheme.buttonColor, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(invite.time.toString().substring(0, 10)),
                Text(
                  invite.people,
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  invite.remark,
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            )),
            GestureDetector(
              child: const Icon(Icons.cancel_sharp),
            ),
            GestureDetector(
              child: const Icon(Icons.check),
            ),
          ],
        )));
  }

  static Widget history(History history) {
    Widget item, label;
    if (history.isGroup) {
      item = Row(
        children: [
          Column(
            children: [
              Padding(padding: EdgeInsets.all(5),child: Text("我"),), 
              Padding(padding: EdgeInsets.all(5),child: Text("平均"),), 
            ]
          ),
          Column(
            children: [
              BoxUI.boxHasRadius(
                padding: EdgeInsets.all(5),
                  child: Text(
                    history.score.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  color: MyTheme.buttonColor),
              BoxUI.boxHasRadius(
                padding: EdgeInsets.all(5),
                  child: Text(
                    history.avgScore.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  color: MyTheme.lightColor)
            ],
          )
        ],
      );
      label = boxHasRadius(child: const Text("團體"));
    } else {
      item = BoxUI.boxHasRadius(child: Text(history.score.toString()));
      label = boxHasRadius(child: const Text("個人"));
    }

    return BoxUI.boxHasRadius(
        height: 100,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      history.isGroup
                          ? Text(
                              history.name,
                              style: TextStyle(
                                  color: MyTheme.buttonColor,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      label
                    ],
                  ),
                  Text(history.time.toString().substring(0, 10)),
                  Text(
                    "召集人: ${history.name}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "共 ${history.peopleCount} 人",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(children: [const Text("運動評分"), item])
          ],
        ));
  }
}
