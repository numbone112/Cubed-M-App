import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

import '../../module/page.dart';

class InsertInvite extends StatefulWidget {
  final String userName;

  const InsertInvite({super.key, required this.userName});
  static const routeName = '/invite/insert';

  @override
  State<StatefulWidget> createState() => InsertInvitestate();
}

class InsertInvitestate extends State<InsertInvite> {
  Widget peopleItem(String id, String name) {
    return BoxUI.boxHasRadius(
      margin: const EdgeInsets.only(right: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
            child: Text(
              'ID:$id',
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var invitedPeople = ["sodiffi"];
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      child: CustomPage(
        body: Column(
          children: [
            Row(
              children: [
                const Text("邀約名稱："),
                Expanded(
                  child: TextInput.radius(' 請輸入邀約名稱'),
                )
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
            Row(
              children: [
                const Text("備註："),
                Expanded(
                  child: TextInput.radius(' 例如：地點'),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Divider(
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            const Text('邀請人'),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextInput.radius(' 請搜尋姓名或ID'),
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: ListView.builder(
                  itemCount: invitedPeople.length,
                  itemBuilder: (context, index) {
                    return peopleItem(
                        invitedPeople[index], invitedPeople[index]);
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              
              BoxUI.boxHasRadius(child: GestureDetector(child: BoxUI.textRadiusBorder('取消',border: MyTheme.lightColor)),color: MyTheme.lightColor),
              BoxUI.boxHasRadius(child: GestureDetector(child: BoxUI.textRadiusBorder('確認'),),color: MyTheme.buttonColor)
            ],)
          ],
        ),
        buildContext: context,
        title: '新增邀約',
        headColor: MyTheme.lightColor,
        headTextColor: Colors.white,
        prevColor: Colors.white,
      ),
    );
  }
}
