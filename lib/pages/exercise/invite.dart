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
      // result
      //     .add(f.contains(friends.first) ? const Text("成員") : const Text(" "));
      // result.add(
      //     Box.textRadiusBorder(f, filling: Colors.white, font: Colors.black));
      // // result.add(Text(f));
      // result.add(Box.textRadiusBorder(
      //   "已接受",
      // ));
      result.add(Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Box.inviteMember(
            type: f.contains(friends.first) ? '成員' : '',
            name: f,
            // accept: Container(
            //   child: Box.boxHasRadius(
            //     child: GestureDetector(
            //         child: Box.textRadiusBorder('已接受',
            //             border: MyTheme.lightColor,
            //             filling: MyTheme.lightColor,
            //             textType: TextType.content)),
            //     color: MyTheme.lightColor,
            //     height: 30,
            //     margin: EdgeInsets.all(0),
            //     padding: EdgeInsets.all(0),
            //   ),
            // )
            accept: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: MyTheme.color,
                  borderRadius: BorderRadius.circular(30)),
              child: MyText(
                  text: '已接受',
                  color: Colors.white,
                  textAlign: TextAlign.center),
            )),
      ));
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
          Box.inviteInfo(invite, false),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Box.inviteMember(type: '召集人', name: invite.m_name)),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            height: MediaQuery.of(context).size.height * 0.56,
            child: ListView(children: showOnInvite(invite.friend)),
          ),
          invite.accept != 3
              ? Container()
              : Box.yesnoBox(
                  () => sendReply(1),
                  yestTitle: '接受',
                  () => sendReply(2),
                  noTitle: '拒絕')
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
