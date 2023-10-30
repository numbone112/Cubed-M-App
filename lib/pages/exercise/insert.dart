import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:e_fu/request/mo/mo.dart';
import 'package:e_fu/request/mo/mo_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
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
  List<MoSearch> searchList = [];
  Set<MoSearch> selectFriend = {};
  DateFormat dateFormat = DateFormat('yyyy-MM-dd ');
  TimeOfDayFormat timeFormat = TimeOfDayFormat.HH_colon_mm;
  MoRepo moRepo = MoRepo();

  Widget peopleItem(String id, String name, {Color? select}) {
    return Box.boxHasRadius(
      color: select,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 10),
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
    var logger = Logger();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      child: CustomPage(
        body: ListView(
    
          children: [
            Row(
              children: [
                textWidget(text: '邀約名稱：', type: TextType.sub),
                Expanded(
                  child: TextInput.radius(' 請輸入邀約名稱', nameInput),
                )
              ],
            ),
            Row(
              children: [
                textWidget(text: '運動日期：', type: TextType.sub),
                Expanded(
                  child: TextInput.radius(
                    "請選擇運動日期",
                    dateInput,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        dateInput.text = dateFormat.format(pickedDate);
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
                textWidget(text: '運動時段：', type: TextType.sub),
                Expanded(
                  child: TextInput.radius(
                    '請選擇運動時段',
                    timeInput,
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());

                      if (pickedTime != null && context.mounted) {
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
                textWidget(text: '備註：', type: TextType.sub),
                Expanded(
                  child: TextInput.radius(' 例如：地點', remarkInput),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Divider(height: 1.0, color: Colors.grey),
            ),
            textWidget(text: '欲邀請的人', type: TextType.sub),
            Row(
                children: selectFriend
                    .map((mosearch) => Box.boxWithX(mosearch.name))
                    .toList()),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Row(
                children: [
                  Expanded(child: TextInput.radius(' 請搜尋姓名或ID', quaryInput)),
                  GestureDetector(
                    child: const Text("搜尋"),
                    onTap: () {
                      moRepo.search(quaryInput.text).then((value) {
                        setState(() {
                          searchList = parseMoSearchList(jsonEncode(value.D));
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
                      child: peopleItem(
                          select: selectFriend.contains(searchList[index])
                              ? MyTheme.lightColor
                              : null,
                          searchList[index].id,
                          searchList[index].name),
                    );
                  }),
            ),
            Box.yesnoBox(() {
              EasyLoading.show(status: "loading...");
              Invite invite = Invite(
                m_id: widget.userID,
                name: nameInput.text,
                time: DateTime.now().toIso8601String(),
                remark: remarkInput.text,
                friend: selectFriend.map((select) => select.id).toList(),
              );
              api.createInvite(invite).then((value) => {
                    EasyLoading.dismiss(),
                    if (value.success!) {Navigator.pop(context)} else {}
                  });
            }, () => Navigator.pop(context))
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
