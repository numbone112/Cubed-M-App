import 'package:e_fu/changePassword.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/exercise_process.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/my_data.dart';

import 'package:e_fu/pages/profile/profile_update.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  final String userID;
  const Profile({super.key, required this.userID});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<Profile> {
  Widget profileItem({String? title, String? subtitle, Function()? onTap}) {
    return Container(
      margin: Space.onlyTopTen,
      height: subtitle == null
          ? MediaQuery.of(context).size.height * 0.07
          : MediaQuery.of(context).size.height * 0.1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: textWidget(text: title ?? '', type: TextType.content),
        subtitle: subtitle == null
            ? null
            : textWidget(
                text: subtitle == '' ? '無' : subtitle,
                type: TextType.content,
                color: MyTheme.hintColor),
        dense: true,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GetUser;

    return CustomPage(
      body: ListView(children: [
        profileItem(title: 'ID', subtitle: args.id),
        profileItem(title: '姓名', subtitle: args.name),
        profileItem(title: '性別', subtitle: args.sex != "female" ? "男" : "女"),
        profileItem(
            title: '生日',
            subtitle: args.birthday.toIso8601String().substring(0, 10)),
        profileItem(title: '手機號碼', subtitle: args.phone),
        profileItem(title: '身高', subtitle: args.weight.toString()),
        profileItem(title: '體重', subtitle: args.height.toString()),
        profileItem(title: '疾病', subtitle: args.disease.join(" , ")),
        profileItem(
          title: '修改運動組數',
          onTap: () => setTarget(
            context,
            ItemSets.withField(
                args.sport_info.map((e) => e.target_sets.toString()).toList()),
          ),
        ),
        profileItem(
          title: '編輯個人檔案',
          onTap: () => Navigator.pushNamed(context, ProfileUpdate.routeName,
              arguments: args),
        ),
        profileItem(
          title: '修改密碼',
          onTap: () => Navigator.pushNamed(context, UpdatePsw.routeName,
              arguments: args),
        ),
      ]),
      title: "個人檔案",
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
      buildContext: context,
    );
  }
}
