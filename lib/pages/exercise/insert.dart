import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

import '../../module/page.dart';

class Insert_invite extends StatefulWidget {
  String userName;

  Insert_invite({super.key, required this.userName});
  static const routeName = '/invite/insert';

  @override
  State<StatefulWidget> createState() => Insert_invitestate();
}

class Insert_invitestate extends State<Insert_invite> {
  Widget peopleItem(String id, String name) {
    return BoxUI.boxHasRadius(
        child: Column(
      children: [
        Text(
          id,
          style: TextStyle(color: Colors.grey),
        ),
        Text(name)
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var invited_people = ["sodiffi"];
    return CustomPage(
        body: Column(
          children: [
            const Row(
              children: [
                Text("邀約名稱："),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(hintText: "請輸入邀約名稱"),
                ))
              ],
            ),
            const Row(
              children: [
                Text("運動日期："),
                Expanded(
                    child: TextField(
                  enabled: false,
                  decoration: InputDecoration(hintText: "請輸入邀約名稱"),
                ))
              ],
            ),
            const Row(
              children: [
                Text("運動時段："),
                Expanded(
                    child: TextField(
                  enabled: false,
                  decoration: InputDecoration(hintText: "請輸入邀約名稱"),
                ))
              ],
            ),
            Container(),
            const Text('邀請人'),
            const TextField(
              decoration: InputDecoration(hintText: '請搜尋姓名或ID'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: ListView.builder(
                itemCount: invited_people.length,
                itemBuilder: (context, index) {
                return peopleItem(invited_people[index], invited_people[index]);
              }),
            )
          ],
        ),
        buildContext: context,
        title: '新增邀約',
        headColor: MyTheme.lightColor,
        headTextColor: Colors.white);
  }
}
