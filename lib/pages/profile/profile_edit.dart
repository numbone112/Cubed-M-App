import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';

import 'package:e_fu/pages/profile/profile_update.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  final String userName;
  const Profile({super.key, required this.userName});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GetUser;

    return CustomPage(
      body: ListView(children: [
        Box.twoinfo("ID", args.id),
        Box.twoinfo("姓名", args.name),
        Box.twoinfo("性別", args.sex),
        Box.twoinfo("生日", args.birthday.toIso8601String().substring(0, 10)),
        Box.twoinfo("手機號碼", args.phone),
        Box.twoinfo("身高", args.height.toString()),
        Box.twoinfo("體重", args.height.toString()),
        Box.twoinfo("疾病", args.disease.join(" , ")),
        Box.twoinfo("", "", widget: [
          GestureDetector(
            child: const Text("編輯個人資料",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => Navigator.pushNamed(context, ProfileUpdate.routeName,
                arguments: args),
          )
        ]),
      ]),
      title: "個人檔案",
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
      buildContext: context,
    );
  }
}
