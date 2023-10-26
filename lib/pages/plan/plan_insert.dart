import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';

import 'package:e_fu/request/plan/plan.dart';
import 'package:e_fu/request/plan/plan_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class PlanInsertPage extends StatefulWidget {
  static const routeName = '/plan/insert';
  final String userName;
  const PlanInsertPage({super.key, required this.userName});

  @override
  PlanInsertState createState() => PlanInsertState();
}

class PlanInsertState extends State<PlanInsertPage> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  List<bool> execute = [];
  @override
  void initState() {
    super.initState();
    execute = [false, false, false, false, false, false, false];
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
                Text(
                  "星期${Box.executeText[i]}",
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
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "新增計畫",
      buildContext: context,
      body: ListView(
        children: [
          Row(
            children: [
              const Text("計畫名稱"),
              Expanded(child: TextInput.radius("", nameInput))
            ],
          ),
          Row(
            children: [
              const Text("開始時間"),
              Expanded(
                child: TextInput.radius("", strInput,
                    onTap: () => dateInput(strInput)),
              )
            ],
          ),
          Row(
            children: [
              const Text("結束時間"),
              Expanded(
                child: TextInput.radius(
                  "",
                  endInput,
                  onTap: () => dateInput(endInput),
                ),
              )
            ],
          ),
          const Text(
            "運動計畫表",
            textAlign: TextAlign.center,
          ),
          const Text(
            "請點選欲安排運動之星期",
            textAlign: TextAlign.center,
          ),
          choise(),
          Box.yesnoBox(() {
            Plan plan = Plan(
                name: nameInput.text,
                user_id: widget.userName,
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
