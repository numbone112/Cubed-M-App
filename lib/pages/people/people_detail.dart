
import 'package:e_fu/module/page.dart';
import 'package:e_fu/module/people_box.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../my_data.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:e_fu/module/box_ui.dart';

class PeopleDetail extends StatefulWidget {
  static const routeName = '/people/';

  PeopleDetail({super.key, required this.function, required this.ePeople});
  Function(int a) function;
  EPeople ePeople;

  @override
  PeopleDetailState createState() => PeopleDetailState();
}

class PeopleDetailState extends State<PeopleDetail> {
  ERepo eRepo = ERepo();
  Logger logger = Logger();
  PatientData? patientData;
  void getDetail() {
    eRepo.getFuDatil(widget.ePeople.id).then((value) {
      logger.v(value.D);
      PatientData patient = PatientData.fromJson(value.D[0]);
      logger.v('getDetail: ${patient.appointment.length}');
      setState(() {
        patientData = patient;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getDetail();
    EPeople ePeople = widget.ePeople;
    PeopleBox p = PeopleBox(
        name: ePeople.name,
        height: ePeople.height,
        weight: "155",
        disease: ["0", "1"],
        gender: ePeople.sex,
        birthday: ePeople.birthday);
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
              Box.boxHasRadius(
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
              Box.boxWithTitle(
                  "預約復健",
                  Container(
                    child: Box.boxHasRadius(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                // flex: 1,
                                child: Box.boxHasRadius(
                                    height: 100,
                                    color: MyTheme.lightColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${patientData?.appointment.last.tf_time.year}',
                                          style: myText(color: Colors.white),
                                        ),
                                        Text(
                                          "3/21",
                                          style: myText(color: Colors.white),
                                        ),
                                        Text(
                                          "9:00-10:00",
                                          style: myText(color: Colors.white),
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
              // BoxUI.boxWithTitle(
              //     "復健分析",
              //     Container(
              //       child: BoxUI.boxHasRadius(
              //           height: 100,
              //           child: Row(
              //             children: const [],
              //           )),
              //     )),
              Box.boxWithTitle(
                "歷史復健紀錄",
                Container(
                  child: Box.boxHasRadius(
                    height: 300,
                    child: Row(
                      children: patientData==null
                          ? [Container()]
                          : patientData!.appointment.isEmpty
                              ? [Container()]
                              : List.generate(patientData!.appointment.length,
                                  (index) {
                                  EAppointmentDetailBase eBase =
                                      patientData!.appointment[index];

                                  return (Text('${eBase.id}'));
                                }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: "復健者資料"));
  }
}
