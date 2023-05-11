import 'package:e_fu/module/page.dart';
import 'package:e_fu/module/people_box.dart';
import 'package:flutter/material.dart';
import '../../my_data.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:e_fu/module/box_ui.dart';

class PeopleDetail extends StatefulWidget {
  static const routeName = '/people/';

  const PeopleDetail({super.key, required this.function});
  final Function(int a) function;
  @override
  PeopleDetailState createState() => PeopleDetailState();
}

class PeopleDetailState extends State<PeopleDetail> {
  PeopleBox p = PeopleBox(
      id: "id",
      name: "王小明",
      height: 166,
      weight: "77",
      disease: ["0", "1"],
      gender: "男",
      birthday: DateTime(1988, 1, 2));
  @override
  Widget build(BuildContext context) {
    return (CustomPage(
        change: () => widget.function(1),
        floatButton: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 70),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FloatingActionButton.extended(
            backgroundColor: MyTheme.buttonColor,
            onPressed: () {},
            elevation: 0,
            label: const Text(
              "安排復健",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
        body: SizedBox(
          height: 600,
          child: ListView(
            children: [
              BoxUI.boxHasRadius(
                child: Row(children: [
                  Expanded(
                      child: Column(
                    children: [Text(p.name), Text(p.gender)],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("年齡 : ${AgeCalculator.age(p.birthday).years}"),
                      Text("身高 : ${p.height}"),
                      Row(
                        children: [
                          Text("體重 : ${p.weight}"),
                          // IconButton(onPressed: () {}, icon: Icon(Icons.info,size: 18,),)
                        ],
                      ),
                      const Text("疾病"),
                    ],
                  ))
                ]),
              ),
              BoxUI.boxWithTitle(
                  "預約復健",
                  Container(
                    child: BoxUI.boxHasRadius(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                // flex: 1,
                                child: BoxUI.boxHasRadius(
                                    height: 100,
                                    color: MyTheme.lightColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "2023",
                                          style: whiteText(),
                                        ),
                                        Text(
                                          "3/21",
                                          style: whiteText(),
                                        ),
                                        Text(
                                          "9:00-10:00",
                                          style: whiteText(),
                                        )
                                      ],
                                    ))),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("左手 5"),
                                    Text("右手 5"),
                                    Text("深蹲 5")
                                  ],
                                ))
                          ],
                        )),
                  )),
              BoxUI.boxWithTitle(
                  "復健分析",
                  Container(
                    child: BoxUI.boxHasRadius(
                        height: 100,
                        child: Row(
                          children: const [],
                        )),
                  )),
              BoxUI.boxWithTitle(
                  "歷史復健紀錄",
                  Container(
                    child: BoxUI.boxHasRadius(
                        height: 300,
                        child: Row(
                          children: const [],
                        )),
                  )),
            ],
          ),
        ),
        title: "復健者資料"));
  }
}
