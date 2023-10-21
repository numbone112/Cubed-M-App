import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key, required this.userName});
  static const routeName = '/invite/';
  final String userName;
  @override
  State<StatefulWidget> createState() => InviteState();
}

class InviteState extends State<InvitePage> {
  Invite invite = Invite();
  InviteRepo inviteRepo = InviteRepo();

  List<Widget> showOnInvite(List<String> friends) {
    List<Widget> result = [];
    for (var f in friends) {
      result.add(f.contains(friends.first) ? const Text("成員") : const Text(" "));
      result.add(Box.textRadiusBorder(f,filling: Colors.white,font: Colors.black));
      // result.add(Text(f));
      result.add(Box.textRadiusBorder("已接受",));
    }
    return result;
  }

  sendReply(int accept) {
    inviteRepo.replyInvite(accept, widget.userName, invite.i_id).then((value) {
      setState(() {
        invite.accept = accept;
      });
      print(value.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    invite = ModalRoute.of(context)!.settings.arguments as Invite;
    print(invite.accept);
    return CustomPage(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Box.inviteInfo(invite, false),
          ),
          Box.boxHasRadius(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            height: 40,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                const Text('召集人'),
                Text(invite.m_name),
              ],
            ),
          ),
          Box.boxHasRadius(
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.all(10),
            height: 300,
            child: GridView.count(
              childAspectRatio:2.5,
              crossAxisCount: 3,
              children: showOnInvite(invite.friend),
            ),
          ),
          invite.accept != 3
              ? Container()
              : Box.yesnoBox(() {
                  sendReply(1);
                }, () => sendReply(2), noTitle: "拒絕")
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
