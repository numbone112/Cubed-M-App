import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';

import 'package:e_fu/request/plan/plan.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class PlanEditPage extends StatefulWidget {
  static const routeName = '/plan/edit';
  final String userID;
  final Plan plan;
  const PlanEditPage({super.key, required this.userID, required this.plan});

  @override
  PlanEditState createState() => PlanEditState();
}

class PlanEditState extends State<PlanEditPage> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  List<bool> execute = [];
  @override
  void initState() {
    super.initState();
    execute = widget.plan.execute;
    nameInput.text=widget.plan.name;
    strInput.text=widget.plan.str_date.toIso8601String();
    endInput.text=widget.plan.end_date.toIso8601String();
  }

  var logger = Logger();

  TextEditingController nameInput = TextEditingController();
  TextEditingController strInput = TextEditingController();
  TextEditingController endInput = TextEditingController();
  PlanRepo planRepo = PlanRepo();

  Widget choise() {
    List<Widget> list = [];
    for (var i = 0; i < execute.length; i++) {
      list.add(
        Box.boxHasRadius(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
          border: Border.all(color: MyTheme.lightColor),
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          color: execute[i] ? MyTheme.lightColor : null,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => setState(() {
              execute[i] = !execute[i];
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWidget(
                  text: "星期${Box.executeText[i]}",
                  color: execute[i] ? Colors.white:Colors.black
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: list,
    );
  }

  void dateInput(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      controller.text = dateFormat.format(pickedDate);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "編輯計畫",
      buildContext: context,
      headColor: MyTheme.lightColor,
      prevColor: Colors.white,
      headTextColor: Colors.white,
      body: ListView(
        children: [
          Box.textInput('計畫名稱', '請輸入運動計畫名稱', nameInput),
          Box.textInput('開始時間', '請選擇開始時間', strInput,
              onTap: () => dateInput(strInput), readOnly: true),
          Box.textInput('結束時間', '請選擇結束時間', endInput,
              onTap: () => dateInput(endInput), readOnly: true),
          textWidget(
            text: "運動計畫表",
            textAlign: TextAlign.center,
            type: TextType.sub
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: textWidget(
                text: "請點選欲安排運動之星期",
                textAlign: TextAlign.center,
                type: TextType.hint,
                color: MyTheme.hintColor),
          ),
          choise(),
          Box.yesnoBox(() {
            Plan plan = Plan(
                name: nameInput.text,
                user_id: widget.userID,
                str_date: DateTime.parse(strInput.text),
                end_date: DateTime.parse(endInput.text),
                execute: execute);
            planRepo.createPlan(plan).then((value) {
              logger.v(value.message);
              logger.v(value.D);
            });
          }, () => Navigator.pop(context))
        ],
      ),
    );
  }
}
