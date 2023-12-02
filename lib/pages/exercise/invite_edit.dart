import 'dart:convert';

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

class InviteEditPage extends StatefulWidget {
  final String userID;
  final Invite invite;
  final List<InviteDetail> inviteDetail;

  const InviteEditPage(
      {super.key,
      required this.invite,
      required this.inviteDetail,
      required this.userID});
  static const routeName = '/invite/edit';

  @override
  State<StatefulWidget> createState() => EditInvitestate();
}

class EditInvitestate extends State<InviteEditPage> {
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

  @override
  void initState() {
    super.initState();
    MoSearch mo = MoSearch(name: "", id: "");
    nameInput.text = widget.invite.name;
    remarkInput.text = widget.invite.remark;
    dateInput.text = widget.invite.time.substring(0, 10);
    timeInput.text = widget.invite.time.substring(12);
    selectFriend = widget.inviteDetail
        .map((e) => e.user_id != widget.userID
            ? MoSearch(name: e.userName, id: e.user_id)
            : mo)
        .toSet();
    selectFriend.remove(mo);
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
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

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
                  return Box.boxWithX(
                      "  " + selectFriend.elementAt(index).name + "  ");
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
                      child: InviteBox.peopleItem(
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
                id: widget.invite.i_id,
                time: formatter.format(sendDate),
                remark: remarkInput.text,
                friend: selectFriend.map((select) => select.id).toList(),
              );
              api.updateInvite(invite).then((value) {
                EasyLoading.dismiss();
                if (value.success!) {
                  toast(context, "編輯成功");
                  Navigator.pop(context,true);
                } else {}
              });
            }, () => Navigator.pop(context))
          ],
        ),
        buildContext: context,
        title: '編輯邀約',
        headColor: MyTheme.lightColor,
        headTextColor: Colors.white,
        prevColor: Colors.white,
      ),
    );
  }
}
