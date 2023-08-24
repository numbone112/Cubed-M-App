import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  final String userName;
  const Profile({super.key, required this.userName});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    
    return CustomPage(
        body: ListView(children: [
          BoxUI.twoinfo("ID", "11136000"),
          BoxUI.twoinfo("姓名", "11136000"),
          BoxUI.twoinfo("性別", "11136000"),
          BoxUI.twoinfo("生日", "11136000"),
          BoxUI.twoinfo("手機號碼", "11136000"),
          BoxUI.twoinfo("身高", "11136000"),
          BoxUI.twoinfo("體重", "11136000"),
          BoxUI.twoinfo("疾病", "11136000"),
          BoxUI.twoinfo("編輯個人資料", ""),
        ]),
        title: "個人檔案",
        headColor: MyTheme.lightColor,
        prevColor: Colors.white,
        headTextColor: Colors.white,
        buildContext: context,);
  }
}
