import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/exercise_process.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/exercise/event_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

toast(BuildContext context, String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black45,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16);
}

setTarget(BuildContext context, List<ItemWithField> items,
    {Function()? yes, Function()? no}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          title: textWidget(
              text: '設定運動組數', type: TextType.fun, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              width: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: items
                          .map((e) =>
                              Box.setsBox(e.item, e.textEditingController))
                          .toList(),
                    ),
                  ),
                  Expanded(
                      child: Box.yesnoBox(context, () {}, () {}, width: 100.0))
                ],
              ),
            ),
          ),
        );
      });
}

showDelDialog(BuildContext context, String delName) {
  showDialog(
    context: context,
    builder: ((context) => AlertDialog(
          content: SizedBox(
            height: 150,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textWidget(text: "確定要刪除$delName?", type: TextType.fun),
                  Box.yesnoBox(
                      context, () => null, () => Navigator.pop(context))
                ]),
          ),
        )),
  );
}

showMoInfo(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box.titleText("Mo 伴是什麼？",
                    gap: 10, fontSize: MySize.subtitleSize),
                Text("曾一起運動的朋友。", style: textStyle(color: MyTheme.hintColor)),
                Box.titleText("運動綜合評分如何計算？",
                    gap: 10, fontSize: MySize.subtitleSize),
                Text("從運動者最後一次運動中，將各動作等級換算成數字，再以算術平均計算。",
                    style: textStyle(color: MyTheme.hintColor)),
              ],
            ),
          ),
        );
      });
}

showCommendInfo(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box.titleText("與過往相比？", gap: 10, fontSize: MySize.subtitleSize),
                Text("將前五筆的各種類的運動平均分數，與本次運動做比較。",
                    style: textStyle(color: MyTheme.hintColor)),
              ],
            ),
          ),
        );
      });
}

showplanInfo(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box.titleText("當週運動計畫", gap: 10, fontSize: MySize.subtitleSize),
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        height: 30,
                        color: MyTheme.gray,
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text("表示未來預計要運動",
                        style: textStyle(color: MyTheme.hintColor)),
                  ],
                ),
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        height: 30,
                        color: MyTheme.green,
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text("表示過去預計要運動，也確實完成運動",
                          style: textStyle(color: MyTheme.hintColor)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        height: 30,
                        color: MyTheme.pink,
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text("表示過去預計要運動，卻沒有運動",
                          style: textStyle(color: MyTheme.hintColor)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

showRace(BuildContext context, List<EventRace> list, Function() close,String text) {
  list.sort(((a, b) => b.times.compareTo(a.times)));
  //發送mqtt
  double h = MediaQuery.of(context).size.height;
  double m = (h - 300) / 2;
  return Stack(children: [
    Container(
      color: HexColor("3d3d3d").withOpacity(0.95),
      height: h,
    ),
    Box.boxHasRadius(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(50, m, 50, m-200),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
        width: 75,
        height: 75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SpinKitPouringHourGlassRefined(
              color: MyTheme.color,
            ),
             Text(text)
          ],
        ),
      ),
          Box.titleText("即時排行榜",
              gap: 10,
              fontSize: MySize.subtitleSize,
              alignment: Alignment.center),
          const SizedBox(
            width: 300,
            height: 30,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "排名",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "名稱",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "次數",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 300,
            height: 200,
            child: list.isEmpty
                ? Container()
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: ((context, index) => Box.boxHasRadius(
                          child: Box.boxHasRadius(
                            margin: const EdgeInsets.only(bottom: 5),
                            color: list[index].isHost()
                                ? MyTheme.lightColor
                                : Colors.white,
                            height: 30,
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    (index + 1).toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    list[index].name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    list[index].times.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent, onTap: close,
            child: textWidget(text: "關閉")),
        ],
      ),
    ),
  ]);
}
