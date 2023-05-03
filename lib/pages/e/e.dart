import 'package:e_fu/module/boxUI.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/myData.dart';
import 'package:e_fu/pages/e/eUpdate.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileCreateState createState() => ProfileCreateState();
}

class ProfileCreateState extends State<Profile> {
  ProfileData? profile;
  ERepo eRepo = ERepo();

  getProfile() {
    EasyLoading.show(status: 'loading...');
    try {
      eRepo.getProfile("11136008").then((value) {
        setState(() {
          print(value.D);
          profile = parseProfile(value.D);
        });
            EasyLoading.dismiss();

      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      getProfile();
    }
    return (profile == null)
        ? Container(
            
          )
        : CustomPage(
            rightButton: GestureDetector(
              child: const Text("編輯"),
              onTap: () {
                Navigator.pushNamed(context, ProfileUpdate.routeName,arguments: profile);
              },
            ),
            body: Column(
              children: [
                BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
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
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("性別"), Text(profile!.sex)],
                  ),
                ),
                BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(10),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("出生年月日"),
                      Text(profile!.birthday.toIso8601String())
                    ],
                  ),
                ),
                BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(10),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("手機號碼"), Text(profile!.phone)],
                  ),
                ),
                BoxUI.boxHasRadius(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 70,
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
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
