import 'package:e_fu/pages/exercise/event_record.dart';


import 'package:e_fu/module/page.dart';

import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';

import 'package:flutter/material.dart';

class EventNowResult extends StatefulWidget {
  static const routeName = '/event/result/now';
  final String userName;

  const EventNowResult({super.key, required this.userName});

  @override
  State<StatefulWidget> createState() => EventNowResultState();
}

class PersonResult extends StatelessWidget {
  final Logger logger = Logger();
  final EventRecordInfo eventRecordInfo;
  final Map<int, List<int>> done;

  PersonResult(this.eventRecordInfo, {super.key, required this.done});
  @override
  Widget build(BuildContext context) {
    Map<int, String> table = {0: "左手", 1: "右手", 2: "坐立"};
    List<Widget> results = [];

    done.forEach((key, value) {
      results.add(Box.boxHasRadius(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              children: [
                Text(table[key]!),
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
                      (index) => Box.boxHasRadius(
                        margin: const EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          "${value[index]}",
                          style: textStyle(color: Colors.white),
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
            children: <Widget>[Text("運動者：${eventRecordInfo.name}")] + results));
  }
}

class EventNowResultState extends State<EventNowResult> {
  Logger logger = Logger();
  ERepo eRepo = ERepo();
  int currentPageIndex = 0;
  List<PersonResult> reulstList = [];


  @override
  Widget build(BuildContext context) {
    if (reulstList.isEmpty) {
      try {
        final args = ModalRoute.of(context)!.settings.arguments as List<Object>;
        logger.v("args length ${args.length}");
        final forEvnetList = args[0] as List<EventRecord>;
        for (var element in forEvnetList) {
          //補年紀
          element.processData(element.eventRecordInfo.id,true);
        }
        logger.v('done data${forEvnetList[0].data}');

        setState(() {
          reulstList = List.generate(forEvnetList.length, (index) {
            return PersonResult(forEvnetList[index].eventRecordInfo,
                done: forEvnetList[index].data);
          });
        });
      } catch (e) {
        logger.v("event result build $e");
      }
    } else {
      logger.v('else ${reulstList.length}');
    }

    final PageController controller = PageController();

    return CustomPage(
        buildContext: context,
        body: Column(children: [
          const Text('sport date'
              // "運動日期: ${DateFormat("yyyy/mm/dd HH:mm").format()}"
              ),
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
        title: "本次運動紀錄");
  }
}
