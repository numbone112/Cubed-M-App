import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/exercise/invite_data.dart';
import 'package:flutter/material.dart';

class BoxUI {
  static Widget boxHasRadius({
    Color? color,
    double? height,
    double? width,
    required Widget child,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
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

  static Widget textRadiusBorder(String text,
      {Color? font,
      Color? border,
      double? width,
      EdgeInsets? margin,
      Color? filling}) {
    return Container(
      margin: margin ?? const EdgeInsets.all(10),
      alignment: const Alignment(0, 0),
      height: 25,
      width: width ?? 50,
      decoration: BoxDecoration(
          color: filling ?? MyTheme.buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(color: border ?? Colors.white)),
      child: Text(text, style: TextStyle(color: font ?? Colors.white)),
    );
  }

  static Widget titleText(String title, double gap,
      {AlignmentGeometry? alignment,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight}) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(0, gap, 0, gap),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: fontWeight ?? FontWeight.bold,
            fontSize: fontSize,
            color: color),
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
              children: [
                Text(
                  invite.name,
                  style: TextStyle(
                      color: MyTheme.buttonColor, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(invite.time.toString().substring(0, 10)),
                Text(
                  '召集人：${invite.m_id}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  '備註：${invite.remark}',
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
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Text("我"),
            ),
            Padding(padding: EdgeInsets.all(2.5)),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text("平均"),
            ),
          ]),
          Column(
            children: [
              BoxUI.textRadiusBorder(history.score.toString(),
                  margin: const EdgeInsets.all(5)),
              const Padding(
                padding: EdgeInsets.all(2.5),
              ),
              BoxUI.textRadiusBorder(
                history.avgScore.toString(),
                filling: MyTheme.lightColor,
                margin: const EdgeInsets.all(5),
              ),
            ],
          )
        ],
      );
      label = BoxUI.textRadiusBorder(
        "團體",
        font: HexColor("C6AC78"),
        filling: Colors.white,
        border: HexColor("C6AC78"),
       
      );
    } else {
      item = BoxUI.textRadiusBorder(history.score.toString(),
          margin: EdgeInsets.zero);

      label = BoxUI.textRadiusBorder('個人',
          filling: Colors.white, border: Colors.black45, font: Colors.black45);
    }

    return BoxUI.boxHasRadius(
        margin: const EdgeInsets.all(5),
        height: 120,
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      label,
                      history.isGroup
                          ? Text(
                              history.name,
                              style: TextStyle(
                                  color: MyTheme.buttonColor,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container()
                    ],
                  ),
                  Text(history.time.toString().substring(0, 10)),
                  Text(
                    "召集人: ${history.name}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  history.isGroup
                      ? Text(
                          "共 ${history.peopleCount} 人",
                          style: const TextStyle(color: Colors.grey),
                        )
                      : Container(),
                ],
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text("運動評分"), item])
          ],
        ));
  }
}

class TextInput {
  static Widget radius(String text) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: MyTheme.lightColor)),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: text,
          floatingLabelStyle: TextStyle(color: MyTheme.lightColor),
        ),
      ),
    );
  }
}
