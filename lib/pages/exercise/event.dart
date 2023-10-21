import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/exercise/EventRecord.dart';
import 'package:e_fu/pages/exercise/bleService.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:ele_progress/ele_progress.dart';
import 'package:flutter/material.dart';



class EventBox extends StatefulWidget {
  final EventRecordDetail eventRecordDetail;

  const EventBox({
    super.key,
    required this.eventRecordDetail,
  });
  @override
  State<StatefulWidget> createState() => EventBoxState();
}

class EventBoxState extends State<EventBox> {
  late EventRecord eventRecord;

  @override
  void initState() {
    super.initState();
    eventRecord = EventRecord(
        eventRecordDetail: widget.eventRecordDetail,
        eventRecordInfo: EventRecordInfo(
          done: [],
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<String> exerciseItem = ["左手", "右手", "坐立"];
    return (Box.boxHasRadius(
      border: Border.all(color: MyTheme.color),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: List.generate(
              exerciseItem.length,
              (eIndex) => Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (eventRecord.now == eIndex)
                        ? Box.boxHasRadius(
                            child: Text(
                              exerciseItem[eIndex],
                              style: myText(color: Colors.white),
                            ),
                            color: MyTheme.buttonColor,
                            padding: const EdgeInsets.all(5))
                        : Text(
                            exerciseItem[eIndex],
                          ),
                    const Padding(padding: EdgeInsets.all(5)),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: EProgress(
                        progress: eventRecord.progress[eIndex] ?? 0,
                        colors: [MyTheme.buttonColor],
                        showText: true,
                        format: (progress) {
                          return '${eventRecord.eventRecordDetail.item[eIndex]}';
                        },
                        textStyle: TextStyle(
                            color: eventRecord.now == eIndex
                                ? MyTheme.buttonColor
                                : Colors.black),
                        type: ProgressType.dashboard,
                        backgroundColor: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          eventRecord.isConnect
              ? const Text("已連接")
              : GestureDetector(
                  onTap: () {
                    //這邊要show 配對還要更改isConnect
                    //                     if (isBleOn) {
//                       _scan();
//                       //沒在列印的時候再startScan
//                       if (!isScan) {
//                         flutterBlue.startScan(
//                             timeout: const Duration(seconds: 4));
//                       }
//                       await showDialog(
//                         context: context,
//                         builder: (ctx) => AlertDialog(
//                           title: const Text("您已開啟藍芽"),
//                           content: toPairDialog(index),
//                           actions: <Widget>[
//                             TextButton(
//                               onPressed: () => Navigator.of(context).pop(),
//                               child: Container(
//                                 padding: const EdgeInsets.all(14),
//                                 child: const Text("關閉"),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else {
//                       await showDialog(
//                         context: context,
//                         builder: (ctx) => CupertinoAlertDialog(
//                           content: Column(
//                             children: const [
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Align(
//                                 alignment: Alignment(0, 0),
//                                 child: Text("是否要開啟藍芽？"),
//                               )
//                             ],
//                           ),
//                           actions: [
//                             CupertinoDialogAction(
//                               child: const Text('取消'),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             CupertinoDialogAction(
//                               child: const Text('開啟藍芽'),
//                               onPressed: () async {
//                                 await FlutterBluePlus.instance
//                                     .turnOn()
//                                     .then((value) {
//                                   setState(() {
//                                     isBleOn = true;
//                                   });
//                                 });
//                                 _scan();
//                                 if (context.mounted) {
//                                   Navigator.pop(context);
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Box.textRadiusBorder("連接",
                      font: Colors.white, filling: MyTheme.color)),
          const Padding(padding: EdgeInsets.all(2)),
          Text("提醒：請配戴裝置")
        ],
      ),
    ));
  }
}
