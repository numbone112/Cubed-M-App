import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});
  static const routeName = '/invite/';

  @override
  State<StatefulWidget> createState() => InviteState();
}

class InviteState extends State<InvitePage> {
  late Invite invite;
  @override
  Widget build(BuildContext context) {
    invite=ModalRoute.of(context)!.settings.arguments as Invite;
    return CustomPage(
      body: Column(
        
        children: [
          Container(
              width: MediaQuery.of(context).size.width*0.8,
            alignment: Alignment.centerLeft,
            child: Box.inviteInfo(invite),
          ),
          Box.boxHasRadius(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 30,bottom: 30),
            width: MediaQuery.of(context).size.width*0.8,
            height: 40,
            child: GridView.count(
              crossAxisCount: 3,
              children: const [
                Text("召集人"),
                Text("小明"),
              ],
            ),
          ),
          Box.boxHasRadius(
            margin: const EdgeInsets.only(bottom: 30),

            padding: const EdgeInsets.all(10),
            
              width: MediaQuery.of(context).size.width*0.8,
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              children: const [
                Text("成員"),
                Text("羅真"),
              ],
            ),
          ),
          Box.yesnoBox(() => null, () =>Navigator.pop(context))
         
        ],
      ),
      title: "邀約",
      buildContext: context,
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
    );
  }
}
