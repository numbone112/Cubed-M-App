import 'dart:convert';
// import 'dart:js_interop';

import 'package:e_fu/module/page.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EventResult extends StatefulWidget {
  static const routeName = '/event/result';
  final String userName;

  const EventResult({super.key, required this.userName});

  @override
  State<StatefulWidget> createState() => EventResultState();
}

class PersonResult extends StatelessWidget {
  final Logger logger = Logger();
  final EAppointmentDetail appointmentDetail;

  PersonResult(this.appointmentDetail, {super.key});
  @override
  Widget build(BuildContext context) {
    Map<int, String> table = {0: "左手", 1: "右手", 2: "坐立"};
    List<Widget> results = [];

    results = List.generate(appointmentDetail.done.length, (index) {
      List<int> value = appointmentDetail.done[index];
      return (BoxUI.boxHasRadius(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              children: [
                Text(table[index]!),
                Container(
                  padding: const EdgeInsets.all(3),
                  height: 35 + 30 * ((value.length / 5.0).ceil() | 1) * 1.0,
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5, childAspectRatio: 1),
                    children: List.generate(
                      value.length,
                      (index) => BoxUI.boxHasRadius(
                        margin: const EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          "${value[index]}",
                          style: myText(color: Colors.white),
                        )),
                        color: MyTheme.color,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ));
    });

    return SizedBox(
        child: Column(
            children:
                <Widget>[Text("復健者：${appointmentDetail.name}")] + results));
  }
}

class EventResultState extends State<EventResult> {
  Logger logger = Logger();
  ERepo eRepo = ERepo();
  int currentPageIndex = 0;
  List<PersonResult> reulstList = [];
  late EAppointment eAppointment;

  Future<List<EAppointmentDetail>> getData(EAppointment eAppointment) async {
    EasyLoading.show(status: 'loading...');
    try {
      Format d = await eRepo.getApDetail(
          widget.userName, eAppointment.id.start_date, eAppointment.id.time);
      return parseEApointmentDetail(jsonEncode(d.D));
    } catch (e) {
      return [];
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reulstList.isEmpty) {
      try {
        final args = ModalRoute.of(context)!.settings.arguments as EAppointment;
        eAppointment = args;
        logger.v("args${args.id.start_date},${args.id.time}");
        getData(args).then((value) {
          logger.v("biuld getdata $value");
          List<PersonResult> tempList = [];
          for (var element in value) {
            logger.v("element: $element");
            tempList.add(PersonResult(element));
          }
          setState(() {
            reulstList = tempList;
          });
        });
      } catch (e) {
        logger.v("event result build $e");
      }
    }

    final PageController controller = PageController();

    return CustomPage(
        buildContext: context,
        body: Column(children: [
          const Text("復健師"),
          Text(
              "復健日期: ${DateFormat("yyyy/mm/dd HH:mm").format(eAppointment.tf_id.start_date)}"),
          Stack(
            children: [
              SizedBox(
                height: 650,
                width: 300,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  controller: controller,
                  children: reulstList,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(reulstList.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPageIndex == i
                              ? MyTheme.color
                              : MyTheme.lightColor),
                    );
                  }).toList(),
                ),
              ),
            ],
          )
        ]),
        title: "本次復健紀錄");
  }
}
