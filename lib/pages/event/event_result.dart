import 'package:e_fu/module/page.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EventResult extends StatefulWidget {
  static const routeName = '/event/result';

  const EventResult({super.key});

  @override
  State<StatefulWidget> createState() => EventResultState();
}

class PersonResult extends StatelessWidget {
  final Logger logger = Logger();

  PersonResult({super.key});
  @override
  Widget build(BuildContext context) {
    Map<String, List<int>> data = {
      "左手": [
        12,
      ],
      "右手": [
        12,
      ],
      "坐立": [
        0,
      ]
    };
    List<Widget> results = [];
    data.forEach(
      (key, value) {
        results.add(BoxUI.boxHasRadius(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(key),
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
                              style: whiteText(),
                            )),
                            color: MyTheme.color,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )));
      },
    );
    return SizedBox(
        child: Column(children: <Widget>[const Text("復健者：貓咪")] + results));
  }
}

class EventResultState extends State<EventResult> {
  Logger logger = Logger();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    List<PersonResult> reulstList = [];

    reulstList.add(PersonResult());

    return CustomPage(
        buildContext: context,
        body: Column(children: [
          const Text("復健師"),
          const Text("復健日期: 2023年 5月 14日"),
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
