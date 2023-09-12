import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class GroupEvent extends StatefulWidget {
  static const routeName = 'group/event';

  const GroupEvent({super.key, required this.userName});
  final String userName;

  @override
  State<StatefulWidget> createState() => GroupEventState();
}

class GroupEventState extends State<GroupEvent> {
  var logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final invite =ModalRoute.of(context)!.settings.arguments as Invite;
    Invite invite = Invite(
        name: "name",
        time: DateTime.now(),
        m_id: "m_id",
        remark: "remark",
        friend: []);
    return (CustomPage(
      width: MediaQuery.of(context).size.width * 0.8,
      body: Column(children: [
        Align(
          child: Box.inviteInfo(invite),
          alignment: Alignment.centerLeft,
        ),
        Box.connect(context),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: ListView(
            children: [
              Box.boxHasRadius(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Text("雯雯"), Text("準備中"), Text("綠")],
                    )
                  ],
                ),
              ),
              Box.boxHasRadius(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Text("雯雯"), Text("準備中"), Text("綠")],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Box.boxHasRadius(
                child: GestureDetector(
              child: const Text("開始運動"),
            )),
            Box.boxHasRadius(
                child: GestureDetector(
              child: const Text("準備好了"),
            )),
         
          ],
        )
      ]),
      title: "連接裝置",
      buildContext: context,
    ));
  }
}
