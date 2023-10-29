import 'package:e_fu/my_data.dart';

import 'package:e_fu/pages/exercise/history.dart';
import 'package:e_fu/pages/exercise/invite.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Box {
  static final List<String> executeText = ["一", '二', '三', '四', '五', '六', '日'];
  static const BorderRadius normamBorderRadius =
      BorderRadius.all(Radius.circular(30));
  static List<BoxShadow> getshadow(Color color) {
    return [
      BoxShadow(
          color: color,
          offset: const Offset(6.0, 6.0), //陰影x軸偏移量
          blurRadius: 0, //陰影模糊程度
          spreadRadius: 0 //陰影擴散程度
          )
    ];
  }

  static Widget boxHasRadius(
      {Color? color,
      double? height,
      double? width,
      Border? border,
      required Widget? child,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding,
      List<BoxShadow>? boxShadow}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: normamBorderRadius,
        color: color ?? Colors.white,
        border: border,
        boxShadow: boxShadow,
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
      {int? textType,
      Color? color,
      Color? border,
      double? width,
      EdgeInsets margin = const EdgeInsets.all(10),
      EdgeInsets padding = const EdgeInsets.all(2.5),
      double? height,
      Color? filling}) {
    return Container(
        padding: padding,
        margin: margin,
        alignment: const Alignment(0, 0),
        height: height ?? 30,
        width: width ?? 110,
        decoration: BoxDecoration(
            color: filling ?? MyTheme.buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(height ?? 25)),
            border: Border.all(color: border ?? Colors.white)),
        child: textWidget(
            text: text,
            type: textType ?? TextType.sub,
            color: color ?? Colors.white));
  }

  static Widget titleText(String title,
      {AlignmentGeometry? alignment,
      double? gap,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight}) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(0, gap ?? 0, 0, gap ?? 0),
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

  static Widget inviteBox(Invite invite, BuildContext context) {
    return Box.boxHasRadius(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, InvitePage.routeName,
                  arguments: invite),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: invite.name,
                      type: TextType.sub,
                      color: MyTheme.buttonColor,
                      fontWeight: true),
                  textWidget(
                      text: invite.time
                          .toString()
                          .substring(0, 17)
                          .replaceAll('T', ''),
                      type: TextType.sub),
                  textWidget(
                      text: '召集人：${invite.m_id}',
                      type: TextType.content,
                      color: MyTheme.hintColor),
                  textWidget(
                      text: '共 ${invite.friend.length} 人',
                      type: TextType.content,
                      color: MyTheme.hintColor),
                  textWidget(
                      text: '備註：${invite.remark.isEmpty ? '無' : invite.remark}',
                      type: TextType.content,
                      color: MyTheme.hintColor)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget history(
      History history, BuildContext context, String userName) {
    Widget item, label;
    if (history.isGroup()) {
      item = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: textWidget(
              text: '運動評分',
              type: TextType.sub,
            ),
          ),
          Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: textWidget(text: '我', type: TextType.content)),
              Box.textRadiusBorder(history.score.toString(),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  filling: MyTheme.buttonColor,
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0)),
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: textWidget(text: '平均', type: TextType.content)),
              Box.textRadiusBorder(history.avgScore.toString(),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  filling: MyTheme.color,
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0)),
            ],
          )
        ],
      );
      label = Box.textRadiusBorder("團體",
          color: HexColor("C6AC78"),
          filling: Colors.white,
          border: HexColor("C6AC78"),
          width: 60);
    } else {
      item = Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: textWidget(
                text: '運動評分',
                type: TextType.sub,
              ),
            ),
            Box.textRadiusBorder(history.score.toString(),
                margin: const EdgeInsets.only(top: 20), width: 60),
          ],
        ),
      );

      label = Box.textRadiusBorder('個人',
          filling: Colors.white,
          border: Colors.black45,
          color: Colors.black45,
          width: 60);
    }

    return Box.boxHasRadius(
      height: 160,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Logger logger = Logger();
          logger.v("this is push");
          Navigator.pushNamed(context, HistoryDetailPage.routeName,
              arguments: history);
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      label,
                      history.isGroup()
                          ? textWidget(
                              text: history.name,
                              type: TextType.sub,
                              color: MyTheme.buttonColor,
                              fontWeight: true)
                          : Container()
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textWidget(
                              text: history.time.toString().substring(0, 10),
                              type: TextType.sub),
                          textWidget(
                              text: history.time
                                  .toString()
                                  .substring(11, 16)
                                  .replaceAll('T', ''),
                              type: TextType.sub),
                          textWidget(
                              text: '召集人：${history.m_name}',
                              type: TextType.content,
                              color: MyTheme.hintColor),
                          history.isGroup()
                              ? textWidget(
                                  text: '共 ${history.peopleCount()} 人',
                                  type: TextType.content,
                                  color: MyTheme.hintColor)
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 15), child: item)
          ],
        ),
      ),
    );
  }

  static Widget inviteMember({String? type, String? name, Widget? accept}) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 2, child: textWidget(text: type ?? '', type: TextType.sub)),
        Expanded(
            flex: 5,
            child: Center(
                child: textWidget(text: name ?? '', type: TextType.sub))),
        Expanded(flex: 2, child: accept ??= Container()),
      ],
    );
  }

  static Widget twoinfo(String title, String? describe,
      {List<Widget>? widget}) {
    return Box.boxHasRadius(
      padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget ??
            [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(describe!),
            ],
      ),
    );
  }

  static Widget twoinfoWithInput(
      String title, TextEditingController controller) {
    return Box.boxHasRadius(
      padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              floatingLabelStyle: TextStyle(color: MyTheme.lightColor),
            ),
          )
        ],
      ),
    );
  }

  //邀約運動資訊
  static Widget inviteInfo(Invite invite, bool isHost) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    text: invite.name,
                    type: TextType.fun,
                    color: MyTheme.buttonColor,
                    fontWeight: true),
                textWidget(
                    text: invite.time
                        .toString()
                        .substring(0, 17)
                        .replaceAll("T", " "),
                    type: TextType.sub),
                textWidget(
                    text: '備註：${invite.remark.isEmpty ? '無' : invite.remark}',
                    type: TextType.content,
                    color: MyTheme.hintColor)
              ],
            ),
          ),
          isHost
              ? GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                    decoration: BoxDecoration(
                        color: MyTheme.lightColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        textWidget(
                            text: '邀請',
                            type: TextType.content,
                            color: Colors.white)
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  static Widget boxWithX(String title, {Function()? function}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: function,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Box.textRadiusBorder(
            title,
            color: MyTheme.buttonColor,
            filling: Colors.white,
            border: MyTheme.buttonColor,
            margin: const EdgeInsets.fromLTRB(5, 15, 5, 5),
          ),
          Box.boxHasRadius(
            child: const Text(
              "X",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            color: MyTheme.lightColor,
            width: 15,
            height: 15,
          )
        ],
      ),
    );
  }

  static Widget yesnoBox(Function() yes, Function() no,
      {String? yestTitle,
      noTitle,
      double? height,
      width,
      Color? noColor,
      yesColor}) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Box.boxHasRadius(
              height: height,
              width: width,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: no,
                  child: Box.textRadiusBorder(noTitle ?? '取消',
                      border: noColor ?? MyTheme.lightColor,
                      filling: noColor ?? MyTheme.lightColor)),
              color: noColor ?? MyTheme.lightColor),
          Box.boxHasRadius(
            height: height,
            width: width,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: yes,
              child: Box.textRadiusBorder(yestTitle ?? '確定',
                  border: yesColor ?? MyTheme.buttonColor,
                  filling: yesColor ?? MyTheme.buttonColor),
            ),
            color: yesColor ?? MyTheme.buttonColor,
          )
        ],
      ),
    );
  }

  // static Widget connectInfo(ConnectState connectState) {
  //   return Box.boxHasRadius(
  //     margin: const EdgeInsets.only(bottom: 10, top: 10),
  //     padding: const EdgeInsets.only(bottom: 10, top: 10),
  //     child: Row(
  //       children: [
  //         Expanded(
  //             flex: 0,
  //             child: Box.textRadiusBorder("",
  //                 filling: connectState.state ? Colors.green : Colors.red,
  //                 width: 25)),
  //         Expanded(
  //           flex: 2,
  //           child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [Text(connectState.id), Text(connectState.name)]),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: connectState.isHost == null
  //               ? Box.textRadiusBorder(connectState.text(),
  //                   filling: MyTheme.lightColor)
  //               : Box.textRadiusBorder("主持人",
  //                   filling: Colors.white, font: MyTheme.color),
  //         )
  //       ],
  //     ),
  //   );
  // }

  static Widget planBox(Plan plan, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 150,
      child: (Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    plan.name,
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: const Text("編輯"),
                      ),
                      GestureDetector(
                        child: const Text("刪除"),
                      )
                    ],
                  ))
            ],
          ),
          Text(plan.getRange()),
          Row(children: executeWeek()),
          Row(children: planWeek(plan))
        ],
      )),
    );
  }

  static List<Widget> executeWeek({bool? show}) {
    List<Widget> result = [];
    int today = DateTime.now().weekday;
    bool check = show != null && show;

    for (var element in executeText) {
      bool isToday = (today == (result.length + 1) && check);

      result.add(Expanded(
        flex: 1,
        child: Box.boxHasRadius(
            height: 30,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                element,
                textAlign: TextAlign.center,
                style: TextStyle(color: isToday ? Colors.white : null),
              ),
            ),
            color: isToday ? MyTheme.color : Colors.white),
      ));
    }
    return result;
  }

  static List<Widget> planWeek(Plan plan, {List<bool>? exe}) {
    List<Widget> result = [];
    bool isHome = exe != null;
    for (var check in plan.execute) {
      Widget widget = const SizedBox(width: 30, height: 30);
      if (isHome) {
        if (DateTime.now().weekday > result.length) {
          widget = Container(
            padding: const EdgeInsets.all(5),
            child: ClipOval(
              child: Container(
                height: 30,
                color: exe[result.length] ? MyTheme.green : MyTheme.pink,
                child: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          widget = Container(
            padding: const EdgeInsets.all(5),
            child: ClipOval(
              child: Container(
                height: 30,
                color: MyTheme.gray,
                child: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
          );
          // widget = Box.boxHasRadius(
          //     child: Icon(
          //       Icons.check_circle,
          //       color: Colors.grey,
          //     ),
          //     height: 30);
        }
      }
      // result.add(
      //    check ? widget : Container(),
      // );
      result.add(Expanded(
        flex: 1,
        child: check ? widget : Container(),
      ));
    }
    return result;
  }

  //設立組數的輸入框
  static Widget setsBox(String title, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: 70, alignment: Alignment.center, child: Text(title)),
        TextInput.radius('組數', controller, width: 80),
        const SizedBox(width: 40, child: Text('組')),
      ],
    );
  }

  //表單標題和輸入框
  static Widget textInput(
      String title, String hintText, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Expanded(child: TextInput.radius(hintText, controller)),
      ],
    );
  }
}

class Chart {
  static Widget avgChart(List<double> values) {
    return RadarChart(
      RadarChartData(
          titlePositionPercentageOffset: 0.3,
          getTitle: (index, angle) {
            switch (index) {
              case 0:
                return const RadarChartTitle(text: '左手');
              case 2:
                return const RadarChartTitle(text: '右手');
              case 1:
                return const RadarChartTitle(text: '下肢');
              default:
                return const RadarChartTitle(text: '');
            }
          },
          ticksTextStyle: const TextStyle(fontSize: 0),
          dataSets: [
            RadarDataSet(
              fillColor: MyTheme.lightColor,
              borderColor: MyTheme.lightColor,
              entryRadius: 2.3,
              dataEntries: values.map((e) => RadarEntry(value: e)).toList(),
              borderWidth: 2.3,
            )
          ]),

      swapAnimationDuration: const Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }
}

class TextInput {
  static Widget radius(
    String text,
    TextEditingController controller, {
    TextField? textField,
    Function()? onTap,
    double? width,
    double? height,
    Color? color,
  }) {
    return Container(
        width: width,
        height: height ?? 45,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: color ?? MyTheme.lightColor)),
        child: textField ??
            TextField(
              onTap: onTap,
              controller: controller,
              cursorColor: color ?? MyTheme.lightColor,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: text,
                hintStyle: TextStyle(color: MyTheme.hintColor, fontSize: 14),
              ),
            ));
  }

  static Widget radiusWithTitle(String text, TextEditingController controller,
      {TextField? textField, Function()? onTap}) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Row(
        children: [
          Text(text),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: MyTheme.lightColor)),
            child: textField ??
                TextFormField(
                  onTap: onTap,
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // labelText: text,
                    floatingLabelStyle: TextStyle(color: MyTheme.lightColor),
                  ),
                ),
          )
        ],
      ),
    );
  }
}
