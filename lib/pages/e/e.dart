import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/e/e_update.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileCreateState createState() => ProfileCreateState();
}

class ProfileCreateState extends State<Profile> {
  ProfileData? profile;
  ERepo eRepo = ERepo();
  var logger = Logger();

  getProfile() {
    EasyLoading.show(status: 'loading...');
    try {
      eRepo.getProfile("11136008").then((value) {
        setState(() {
          profile = parseProfile(value.D);
        });
        EasyLoading.dismiss();
      });
    } catch (e) {
      logger.v(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      getProfile();
    }
    return (profile == null)
        ? Container()
        : CustomPage(
            rightButton: GestureDetector(
              child: const Text("編輯"),
              onTap: () async {
                await Navigator.pushNamed(context, ProfileUpdate.routeName,
                        arguments: profile)
                    .then((value) {
                  logger.v("after await $value");
                  if (value != null) {
                    try {
                      ProfileData p = value as ProfileData;
                      setState(() {
                        profile = p;
                      });
                    } catch (e) {
                      logger.v("after await catch :$e");
                    }
                  }
                });
              },
            ),
            body: Column(
              children: [
                BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  height: 70,
                  color: MyTheme.lightColor,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile!.name,
                        // textAlign: TextAlign.center,

                        style: whiteText(),
                      )
                    ],
                  ),
                ),
                BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(10),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text("性別 : ${profile?.sex}"),
                  ),
                ),
                BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(10),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("出生年月日"),
                      Text(profile!.birthday.toIso8601String().substring(0,10))
                    ],
                  ),
                ),
                BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(10),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Text("手機號碼"), Text(profile!.phone)],
                  ),
                ),
                BoxUI.boxHasRadius(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 70,
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "修改密碼",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            title: "個人資料");
  }
}
