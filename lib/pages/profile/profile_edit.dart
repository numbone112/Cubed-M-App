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
  Widget profileItem({String? title, String? subtitle, Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: subtitle == null
          ? MediaQuery.of(context).size.height * 0.07
          : MediaQuery.of(context).size.height * 0.1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: textWidget(text: title ?? '', type: TextType.sub),
        subtitle: textWidget(
            text: subtitle == '' ? '無' : subtitle ?? '',
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
        profileItem(title: '性別', subtitle: args.sex),
        profileItem(
            title: '生日',
            subtitle: args.birthday.toIso8601String().substring(0, 10)),
        profileItem(title: '手機號碼', subtitle: args.phone),
        profileItem(title: '身高', subtitle: args.height.toString()),
        profileItem(title: '體重', subtitle: args.height.toString()),
        profileItem(title: '疾病', subtitle: args.disease.join(" , ")),
        profileItem(
          title: '編輯個人檔案',
          onTap: () => Navigator.pushNamed(context, ProfileUpdate.routeName,
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
