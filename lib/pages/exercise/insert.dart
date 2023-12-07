import 'dart:convert';

import 'package:e_fu/module/alert.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/module/util.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:e_fu/request/mo/mo.dart';
import 'package:e_fu/request/mo/mo_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:logger/logger.dart';

import '../../module/page.dart';

class InsertInvite extends StatefulWidget {
  final String userID;

  const InsertInvite({super.key, required this.userID});
  static const routeName = '/invite/insert';

  @override
  State<StatefulWidget> createState() => InsertInvitestate();
}

class InsertInvitestate extends State<InsertInvite> {
  InviteAPI api = InviteRepo();
  TextEditingController nameInput = TextEditingController();
  TextEditingController remarkInput = TextEditingController();
  TextEditingController quaryInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  DateTime selectDate = DateTime.now();
  DateTime sendDate = DateTime.now();
  List<MoSearch> searchList = [];
  Set<MoSearch> selectFriend = {};

  TimeOfDayFormat timeFormat = TimeOfDayFormat.HH_colon_mm;
  MoRepo moRepo = MoRepo();

  bool alreadAdd(String name) {
    bool result = false;
    for (var element in selectFriend) {
      if (element.name == name) {
        result = true;
        break;
      }
    }
    return result;
  }

  List<String> getFriend() {
    List<String> result = selectFriend.map((select) => select.id).toList();
    result.add(widget.userID);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    return SizedBox(
      width: Space.screenW8(context),
      height: MediaQuery.of(context).size.height,
      child: CustomPage(
        body: ListView(
          children: [
            Row(
              children: [
                textWidget(text: '邀約名稱：', type: TextType.content),
                Expanded(
                  child: TextInput.radius(' 請輸入邀約名稱', nameInput),
                )
              ],
            ),
            Row(
              children: [
                textWidget(text: '運動日期：', type: TextType.content),
                Expanded(
                  child: TextInput.radius(
                    "請選擇運動日期",
                    dateInput,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        selectDate = pickedDate;
                        sendDate = pickedDate;
                        dateInput.text =
                            formatter.format(pickedDate).substring(0, 10);
                      } else {
                        logger.v("Date is not selected");
                      }
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                textWidget(text: '運動時段：', type: TextType.content),
                Expanded(
                  child: TextInput.radius(
                    '請選擇運動時段',
                    timeInput,
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());

                      if (pickedTime != null && context.mounted) {
                        sendDate = formatter.parse(
                            "${formatter.format(selectDate).substring(0, 12)}${pickedTime.hour}:${pickedTime.minute}:00");
                        timeInput.text = pickedTime.format(context);
                      } else {
                        logger.v("Date is not selected");
                      }
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                textWidget(text: '備註：', type: TextType.content),
                Expanded(
                  child: TextInput.radius(' 例如：地點', remarkInput),
                )
              ],
            ),
            Container(
              margin: Space.allTen,
              child: const Divider(height: 1.0, color: Colors.grey),
            ),
            textWidget(text: '欲邀請的人', type: TextType.content),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ListView.builder(
                itemCount: selectFriend.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  MoSearch moSearch = selectFriend.elementAt(index);
                  return Box.boxWithX(close: () {
                    setState(() {
                      selectFriend.remove(moSearch);
                    });
                  }, "  ${moSearch.name}  ");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: Row(
                children: [
                  Expanded(child: TextInput.radius(' 請搜尋姓名或ID', quaryInput)),
                  const Padding(padding: EdgeInsets.all(5)),
                  GestureDetector(
                    child: textWidget(text: "搜尋", color: MyTheme.color),
                    onTap: () {
                      moRepo.search(quaryInput.text).then((value) {
                        setState(() {
                          searchList = parseMoSearchList(jsonEncode(value.D)).where((element) => element.id!=widget.userID).toList();
                        });
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: ListView.builder(
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectFriend.add(searchList[index]);
                        });
                      },
                      child: InviteBox.peopleItem(
                          select: alreadAdd(searchList[index].name)
                              ? MyTheme.lightColor
                              : null,
                          searchList[index].id,
                          searchList[index].name),
                    );
                  }),
            ),
            Box.yesnoBox(
              context,
              () {
                EasyLoading.show(status: "loading...");
                Invite invite = Invite(
                  m_id: widget.userID,
                  name: nameInput.text,
                  time: formatter.format(sendDate),
                  remark: remarkInput.text,
                  friend: getFriend(),
                );
                api.createInvite(invite).then(
                  (value) {
                    EasyLoading.dismiss();
                    if (value.success!) {
                      toast(context, "新增成功");
                      Navigator.pop(context);
                    } else {
                      alert(context, '錯誤', value.message.toString());
                    }
                  },
                );
              },
              () => Navigator.pop(context),
            )
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
