import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:flutter/material.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});
  static const routeName = '/update';

  @override
  ProfileUpdateState createState() => ProfileUpdateState();
}

class ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController phoneinput = TextEditingController();
  TextEditingController sexinput = TextEditingController();
  TextEditingController nameinput = TextEditingController();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  ERepo eRepo = ERepo();
  var logger = Logger();

  ProfileData? _profileData;
  @override
  Widget build(BuildContext context) {
    if (_profileData == null) {
      setState(() {
        _profileData =
            ModalRoute.of(context)!.settings.arguments as ProfileData;
      });

      dateinput.text = dateFormat.format(_profileData!.birthday);
      phoneinput.text = _profileData!.phone;
      sexinput.text = _profileData!.sex;
      nameinput.text = _profileData!.name;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyTheme.backgroudColor,
      body: SafeArea(
        child: (CustomPage(
          title: "編輯個人資料",
          body: Column(
            children: [
              BoxUI.boxHasRadius(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 25, left: 20, right: 20),
                child: TextField(
                  decoration: const InputDecoration(labelText: "姓名"),
                  controller: nameinput,
                ),
              ),
              BoxUI.boxHasRadius(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 25, left: 20, right: 20),
                child: TextField(
                  // controller: TextEditingController(text: args.birthday.toIso8601String()),
                  controller: dateinput, //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "出生年月日" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      dateinput.text = dateFormat.format(pickedDate);
                    } else {
                      logger.v("Date is not selected");
                    }
                  },
                ),
              ),
              BoxUI.boxHasRadius(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 25, left: 20, right: 20),
                child: TextField(
                  decoration: const InputDecoration(labelText: "手機號碼"),
                  controller: phoneinput,
                ),
              ),
            ],
          ),
        )),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
              child: BoxUI.boxHasRadius(
            color: MyTheme.lightColor,
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              child: Text(
                "取消",
                style: whiteText(),
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.pop(context, null),
            ),
          )),
          Expanded(
            child: BoxUI.boxHasRadius(
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.all(20),
              color: MyTheme.buttonColor,
              child: GestureDetector(
                onTap: () {
                  EasyLoading.show(status: "loading...");
                  ProfileData toSend = ProfileData(
                      password: "",
                      birthday: DateTime.parse(dateinput.text),
                      id: _profileData!.id,
                      phone: phoneinput.text,
                      sex: sexinput.text,
                      name: nameinput.text);
                  logger.v(toSend.toJson());
                  eRepo.updateProfile(toSend).then((value) {
                    EasyLoading.dismiss();
                    if (value.D == "good") {
                      Navigator.pop(context, toSend);
                    }
                  });
                },
                child: Text(
                  "送出",
                  style: whiteText(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
