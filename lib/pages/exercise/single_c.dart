// import 'package:e_fu/module/box_ui.dart';
// import 'package:e_fu/module/page.dart';
// import 'package:e_fu/my_data.dart';
// import 'package:e_fu/pages/exercise/bleService.dart';
// import 'package:e_fu/pages/exercise/event.dart';
// import 'package:e_fu/request/invite/invite_data.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:logger/logger.dart';

// class SingleEvent extends StatefulWidget {
//   static const routeName = 'single/event';

//   const SingleEvent({super.key, required this.userName});
//   final String userName;

//   @override
//   State<StatefulWidget> createState() => SingleEventState();
// }

// class SingleEventState extends State<SingleEvent> {
//   var logger = Logger();
//   bool isHost = true;
//   bool ready = false;
//   List<EventRecord> eventRecordList = [];
//   BleService bleService = BleService();
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final eventRecordDetail =
//         ModalRoute.of(context)!.settings.arguments as EventRecordDetail;
//     if (eventRecordList.isEmpty) {
//       // eventRecordList.add(EventRecord(eventRecordDetail: eventRecordDetail));
//     }

//     Invite invite = Invite(
//       name: "${DateTime.now().day}的旅程",
//       time: DateTime.now().toIso8601String(),
//       m_id: widget.userName,
//       remark: "",
//     );
//     List<Widget> renderList = eventRecordList
//         .map((eventRecord) =>
//             EventBox(eventRecordDetail: eventRecord.eventRecordDetail))
//         .toList();
//     renderList.addAll([
//       SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height / 2.5,
//         child: ListView(
//           children: [
//             //         Stack(
//             //   children: <Widget>[
//             //     //底层显示的PageView
//             //     BuildPageView(),
//             //     //表层的圆点指示器
//             //     BuildCircleIndicator(),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//       Box.boxHasRadius(
//         child: ExpansionTile(
//           collapsedShape: Border.all(color: MyTheme.backgroudColor),
//           title: Text("運動分級表"),
//           children: [Text("運動分級表詳細資料")],
//         ),
//       )
//     ]);
//     return (CustomPage(
//       width: MediaQuery.of(context).size.width * 0.8,
//       body: Column(children: renderList),
//       title: "肌力測試",
//       buildContext: context,
//     ));
//   }
// }
