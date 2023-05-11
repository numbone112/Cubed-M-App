import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:e_fu/request/record/record.dart';
import 'package:e_fu/my_data.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ele_progress/ele_progress.dart';

import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/record/record_data.dart';

class Event extends StatefulWidget {
  static const routeName = '/event';

  const Event({super.key});

  @override
  State<StatefulWidget> createState() => EventState();
}

class ForEvent {
  ForEvent({required this.appointmentDetail}) {
    int s = 0;
    for (int i in appointmentDetail.item) {
      s += i;
    }
    goal = s;
  }
  EAppointmentDetail appointmentDetail;
  int now = 0;
  int goal = 3;
  Map<int, int> progress = {0: 0, 1: 0, 2: 0};
  Map<int, List<int>> data = {0: [], 1: [], 2: []};
  // void init() {
  //   for (int i in appointmentDetail.item) {}
  // }

  void record(int count) {
    data[now]!.add(count);
  }

  void change(int n) {
    now = n;
  }

  static List<ForEvent> parseEventList(List<EAppointmentDetail> list) {
    List<ForEvent> res = [];
    for (EAppointmentDetail e in list) {
      res.add(ForEvent(appointmentDetail: e));
    }
    return res;
  }

  static int getMax(List<ForEvent> data) {
    int max = 0;
    for (ForEvent fe in data) {
      int sum = fe.appointmentDetail.item.fold(0, (a, b) => a + b);
      if (sum > max) max = sum;
    }
    return max;
  }
}

class EventState extends State<Event> {
  List<EAppointmentDetail> selectedArrange = [];
  List<EAppointmentDetail> doing = [];

  bool isBleOn = false;
  bool isScan = false;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  //沒連線的裝置
  List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  Map<int, String> connectDeviec = {};
  List<BluetoothCharacteristic> characteristicList = [];
  List<Record> toSave = [];
  List<BluetoothDevice> hasPair = [];
  AsciiDecoder asciiDecoder = const AsciiDecoder();
  String number = "0";
  List<String> exerciseItem = ["左手", "右手", "坐立"];
  ERepo eRepo = ERepo();
  bool notyet = true;
  int trainCount = 0;
  List<ForEvent> forEventList = [];
  int trainGoal = 0;
  var logger = Logger();

  Future<List<EAppointmentDetail>> getData(EAppointment eAppointment) async {
    EasyLoading.show(status: 'loading...');
    try {
      Format d = await eRepo.getApDetail(
          "11136008", eAppointment.id.start_date, eAppointment.id.time);
      return parseEApointmentDetail(jsonEncode(d.D));
    } catch (e) {
      return [];
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.instance.state.listen((state) {
      if (state == BluetoothState.on) {
        logger.v('藍牙狀態爲開啓');
        setState(() {
          isBleOn = true;
        });
      } else if (state == BluetoothState.off) {
        logger.v('藍牙狀態爲關閉');
        setState(() {
          isBleOn = false;
        });
      }
    });
  }

  //偵測是否在列印裝置
  _scan() {
    FlutterBluePlus.instance.isScanning.listen((event) {
      setState(() {
        isScan = event;
      });
    });
  }

  Widget toPairDialog(int pIndex) {
    return SizedBox(
      width: double.minPositive,
      height: 200,
      child: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.instance.scanResults,
        initialData: const [],
        builder: (c, snapshot) => Column(
          children: snapshot.data!.map(
            (r) {
              if (r.advertisementData.connectable && r.device.name != "") {
                try {
                  if (r.device.name.substring(0, 4) == "e-fu" ||
                      r.device.name.substring(0, 4) == "Ardu") {
                    return ListTile(
                      title: Text(r.device.name),
                      onTap: () async {
                        List<BluetoothService> services = [];

                        try {
                          await r.device.connect();
                        } on PlatformException catch (e) {
                          if (e.code != 'already_connected') {
                            rethrow;
                          }
                        } finally {
                          services = await r.device.discoverServices();
                        }
                        setState(() {
                          hasPair.add(r.device);
                          connectDeviec[pIndex] = r.device.id.toString();
                        });

                        logger.v("連接到${r.device.name}");
                        for (BluetoothCharacteristic characteristic
                            in services.first.characteristics) {
                          if (characteristic.uuid.toString() ==
                              "0000ff00-0000-1000-8000-00805f9b34fb") {
                            characteristicList.add(characteristic);
                          } else if (characteristic.uuid.toString() ==
                              "0000ff03-0000-1000-8000-00805f9b34fb") {
                            characteristic.value.listen((value) {
                              if (value.isEmpty) {
                                logger.v("empty");
                              } else {
                                logger.v("結束$trainCount / $trainGoal");
                                // logger.v(value);
                                //結束後收到
                                trainCount++;

                                ForEvent forEvent = forEventList[pIndex];
                                forEvent.data[forEvent.now]!.add(5);
                                int p =
                                    forEvent.data[forEvent.now]?.length ?? 1;
                                forEvent.progress[forEvent.now] = (p /
                                        forEvent.appointmentDetail
                                            .item[forEvent.now] *
                                        100)
                                    .round();

                                if (trainCount < 3) {
                                  //直接到下一個步驟

                                  forEvent.change(trainCount);

                                  setState(() {
                                    forEventList[pIndex] = forEvent;
                                  });
                                } else if (trainCount == 3) {
                                  forEvent.change(0);

                                  setState(() {
                                    forEventList[pIndex] = forEvent;
                                  });
                                } else if (trainCount < forEvent.goal) {
                                  if (forEvent.data[forEvent.now]!.length ==
                                      forEvent.appointmentDetail
                                          .item[forEvent.now]) {
                                    forEvent.change(forEvent.now + 1);
                                  }
                                  setState(() {
                                    forEventList[pIndex] = forEvent;
                                  });
                                } else {
                                  //全部結束
                                  logger.v("enter else");
                                }
                              }
                            });
                            await characteristic.setNotifyValue(true);
                          } else {
                            characteristic.value.listen((value) {
                              try {
                                String string = String.fromCharCodes(value);
                                List<String> raw = string.split(",");

                                toSave.add(Record(
                                  double.parse(raw[0]),
                                  double.parse(raw[1]),
                                  double.parse(raw[2]),
                                  double.parse(raw[3]),
                                  double.parse(raw[4]),
                                  double.parse(raw[5]),
                                  double.parse(raw[6]),
                                ));
                              } catch (e) {
                                logger.v("error:$e");
                              }
                            });
                            await characteristic.setNotifyValue(true);
                          }
                        }
                        Navigator.of(context).pop();
                      },
                    );
                  } else {
                    return Container();
                  }
                } catch (e) {
                  logger.v(e);
                  return Container();
                }
              } else {
                return Container();
              }
            },
          ).toList(),
        ),
      ),
    );
  }

  editDialog(EAppointmentDetail detail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 100.0,
          ),
          //shape 可以改變形狀
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          title: Text(detail.name),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                    child: Center(
                  child: GestureDetector(
                    child: const Text("確認"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      child: const Text(
                        "取消",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                )
              ],
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              exerciseItem.length,
              (index) {
                TextEditingController controller = TextEditingController();
                controller.text = detail.item[index].toString();
                return Column(
                  children: [
                    Text(exerciseItem[index]),
                    TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: '復健組數'),
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                signed: true, decimal: true)
                            : TextInputType.number)
                  ],
                );
              },
              growable: false,
            ),
          ),
        );
      },
    );
  }

  var recordRepo = RecordRepo();
  Widget optional(ForEvent forEvent) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: Text(
            forEvent.appointmentDetail.name,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: PopupMenuButton(
            itemBuilder: (content) {
              return const [
                PopupMenuItem(
                  value: '/edit',
                  child: Text("編輯"),
                ),
                PopupMenuItem(
                  value: '/del',
                  child: Text("刪除"),
                )
              ];
            },
            onSelected: (value) {
              if (value == "/edit") {
                editDialog(forEvent.appointmentDetail);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget exerciseBox(index) {
    ForEvent forEvent = forEventList[index];
    return Container(
      height: 250,
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          optional(forEvent),
          Row(
            children: List.generate(
              exerciseItem.length,
              (eIndex) => Expanded(
                child: Column(
                  children: [
                    (forEvent.now == eIndex)
                        ? BoxUI.boxHasRadius(
                            child: Text(
                              exerciseItem[eIndex],
                              style: whiteText(),
                            ),
                            color: MyTheme.buttonColor,
                            padding: const EdgeInsets.all(5))
                        : Text(
                            exerciseItem[eIndex],
                          ),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: EProgress(
                        progress: forEvent.progress[eIndex] ?? 0,
                        showText: true,
                        format: (progress) {
                          return '${forEvent.appointmentDetail.item[eIndex]}';
                        },
                        textStyle: TextStyle(
                            color: forEvent.now == eIndex
                                ? MyTheme.buttonColor
                                : Colors.black),
                        type: ProgressType.dashboard,
                        backgroundColor: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          connectDeviec.containsKey(index)
              ? const Text("已連接")
              : GestureDetector(
                  child: Container(
                      width: 50,
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: MyTheme.color),
                      child: Text(
                        "連接",
                        style: whiteText(),
                        textAlign: TextAlign.center,
                      )),
                  onTap: () async {
                    FlutterBluePlus.instance.state.listen((state) {
                      if (state == BluetoothState.on) {
                        logger.v('藍牙狀態爲開啓');
                        setState(() {
                          isBleOn = true;
                        });
                      } else if (state == BluetoothState.off) {
                        logger.v('藍牙狀態爲關閉');
                        setState(() {
                          isBleOn = false;
                        });
                      }
                    });
                    if (isBleOn) {
                      _scan();
                      //沒在列印的時候再startScan
                      if (!isScan) {
                        flutterBlue.startScan(
                            timeout: const Duration(seconds: 4));
                      }
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("您已開啟藍芽"),
                          content: toPairDialog(index),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text("關閉"),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      await showDialog(
                        context: context,
                        builder: (ctx) => CupertinoAlertDialog(
                          content: Column(
                            children: const [
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment(0, 0),
                                child: Text("是否要開啟藍芽？"),
                              )
                            ],
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('取消'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text('開啟藍芽'),
                              onPressed: () async {
                                await FlutterBluePlus.instance
                                    .turnOn()
                                    .then((value) {
                                  setState(() {
                                    isBleOn = true;
                                  });
                                });
                                _scan();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EAppointment;
    if (selectedArrange.isEmpty & notyet) {
      getData(args).then(
        (value) {
          setState(() {
            forEventList = ForEvent.parseEventList(value);
            trainGoal = ForEvent.getMax(forEventList);
          });
          notyet = false;
        },
      );
    }
    return (Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyTheme.backgroudColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    "復健",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    forEventList.isEmpty
                        ? const Text("error")
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ListView.builder(
                              itemCount: forEventList.length,
                              itemBuilder: ((context, index) {
                                return (exerciseBox(index));
                              }),
                            ),
                          ),
                    GestureDetector(
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: MyTheme.lightColor),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (trainCount < 3) {}
                                for (var element in characteristicList) {
                                  element.write(utf8.encode("true"));
                                }
                              },
                              icon: const Icon(Icons.not_started_rounded),
                            ),
                            Text(
                              "全部開始",
                              style: whiteText(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              logger.v(toSave.length);
                              Format a = await recordRepo
                                  .record(ArrangeDate("t01", toSave));
                              if (a.message == "ok") {
                                logger.v("成功");
                              }
                            },
                            child: const Text("傳送"),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              for (var element in hasPair) {
                                element.disconnect();
                              }
                              setState(() {
                                connectDeviec = {};
                                hasPair = [];
                              });
                            },
                            child: const Text("關閉"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
