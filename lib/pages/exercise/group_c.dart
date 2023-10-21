// import 'package:e_fu/module/box_ui.dart';
// import 'package:e_fu/module/page.dart';
// import 'package:e_fu/my_data.dart';
// import 'package:e_fu/pages/exercise/event.dart';
// import 'package:e_fu/request/invite/invite_data.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';

// class GroupEvent extends StatefulWidget {
//   static const routeName = 'group/event';

//   const GroupEvent({super.key, required this.userName});
//   final String userName;

//   @override
//   State<StatefulWidget> createState() => GroupEventState();
// }

// class ConnectState {
//   const ConnectState(
//       {required this.id, required this.name, required this.state, this.isHost});
//   final String id;
//   final String name;
//   final bool state;
//   final bool? isHost;
//   String text() {
//     return state ? "準備中..." : "已準備";
//   }
// }

// class GroupEventState extends State<GroupEvent> {
//   var logger = Logger();
//   bool isHost = true;
//   bool ready = false;

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
//     // final invite =ModalRoute.of(context)!.settings.arguments as Invite;
//     Invite invite = Invite(
//       name: "0918運動GO",
//       time: DateTime(2023, 9, 19, 13).toIso8601String().replaceAll("T", " "),
//       m_id: "m_id",
//       remark: "13:00準時上線!!!逾時不候",
//     );
//     return (CustomPage(
//       width: MediaQuery.of(context).size.width * 0.8,
//       body: Column(children: [
//         Box.connect(context, EventRecordDetail(item: [5,5,5])),
//         SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height / 2.5,
//           child: ListView(
//             children: [
//               Box.connectInfo(ConnectState(
//                   id: "zen3855", name: '羅真', state: true, isHost: true)),
//               Box.connectInfo(
//                   ConnectState(id: "111360098", name: '邱明彥', state: true)),
//               Box.connectInfo(
//                   ConnectState(id: "ting", name: '王皓婷', state: false)),
//             ],
//           ),
//         ),
//         (isHost)
//             ? Box.boxHasRadius(
//                 padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
//                 color: MyTheme.color,
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   child: const Text(
//                     "開始運動",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ))
//             : (ready)
//                 ? Box.boxHasRadius(
//                     padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
//                     color: MyTheme.color,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       child: const Text(
//                         "取消準備",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ))
//                 : Box.boxHasRadius(
//                     padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
//                     color: MyTheme.color,
//                     child: GestureDetector(
//                       child: const Text(
//                         "準備",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )),
//       ]),
//       title: "連接裝置",
//       titWidget: Box.inviteInfo(invite, isHost),
//       buildContext: context,
//     ));
//   }
// }
