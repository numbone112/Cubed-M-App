import 'dart:convert';
import 'dart:io';
import 'package:e_fu/pages/event/event_result.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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
  bool unReadable = false;
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

  void changeProgress() {
    int p = data[now]?.length ?? 1;
    progress[now] = (p / appointmentDetail.item[now] * 100).round();
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

  void updateBleState() {
    FlutterBluePlus.instance.state.listen((event) async {
      if (event == BluetoothState.on) {
        logger.v('藍牙狀態爲開啓');
        setState(() {
          isBleOn = true;
        });
      } else if (event == BluetoothState.off) {
        logger.v('藍牙狀態爲關閉');
        setState(() {
          isBleOn = false;
        });
      } else {
        logger.v('updateBleState: $event');
        await FlutterBluePlus.instance.turnOn().then((value) {
          setState(() {
            isBleOn = true;
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateBleState();
  }

  //偵測是否在列印裝置
  _scan() {
    FlutterBluePlus.instance.isScanning.listen((event) {
      setState(() {
        isScan = event;
      });
    });
  }

  Future<void> finish() async {
    //傳送資料給後端
    Format a = await recordRepo.record(toSave);
    if (a.message == "ok") {
      logger.v("成功");
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, EventResult.routeName);
      }
    }
  }

  Widget toPairDialog(int pIndex) {
    ForEvent forEvent = forEventList[pIndex];
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
                  String checkString = (Platform.isAndroid)
                      ? r.device.name
                      : r.advertisementData.localName;
                  logger.v(checkString);
                  if (checkString.substring(0, 4) == "e-fu") {
                    return ListTile(
                      title: Text(checkString),
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

                        logger.v("連接到$checkString");
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
                                logger.v(value);

                                EasyLoading.dismiss();

                                FlutterRingtonePlayer.play(
                                  android: AndroidSounds.notification,
                                  ios: IosSounds.glass,
                                  looping: true, // Android only - API >= 28
                                  volume: 0.3, // Android only - API >= 28
                                  asAlarm: false, // Android only - all APIs
                                );

                                // String string = String.fromCharCodes(value);
                                // logger.v(string);
                                // List<String> raw = string.split(",");

                                logger.v("結束$trainCount / $trainGoal");

                                // logger.v(value);
                                //結束後收到
                                trainCount++;

                                forEvent.data[forEvent.now]!
                                    .add(toSave.last.times.toInt());
                                forEvent.changeProgress();

                                if (trainCount >= trainGoal) {
                                  for (var element in hasPair) {
                                    element.disconnect();
                                  }
                                  //全部結束
                                  Navigator.pushReplacementNamed(
                                      context, EventResult.routeName,
                                      arguments: forEventList);
                                  logger.v("enter else");
                                }
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
                                }
                              }
                            });
                            await characteristic.setNotifyValue(true);
                          } else {
                            //一直接收
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
                                    double.parse(raw[7]),
                                    trainCount.toDouble(),
                                    forEvent.now.toDouble(),
                                    forEvent.appointmentDetail.id));
                              } catch (e) {
                                logger.v("error:$e");
                              }
                            });
                            try {
                              await characteristic.setNotifyValue(true);
                            } catch (e) {
                              logger.v(e);
                              logger.v("await char set notifyvalue");
                            }
                          }
                        }
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
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
      height: 225,
      margin: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          optional(forEvent),
          Row(
            children: List.generate(
              exerciseItem.length,
              (eIndex) => Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    const Padding(padding: EdgeInsets.all(5)),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: EProgress(
                        progress: forEvent.progress[eIndex] ?? 0,
                        colors: [MyTheme.buttonColor],
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
                  child: BoxUI.boxHasRadius(
                      child: Text(
                        "連接",
                        style: whiteText(),
                        textAlign: TextAlign.center,
                      ),
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(10),
                      color: MyTheme.color),
                  onTap: () async {
                    updateBleState();
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
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
          const Padding(padding: EdgeInsets.all(2))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.instance.indicatorWidget = SpinKitWaveSpinner(
      color: MyTheme.backgroudColor,
      trackColor: MyTheme.color,
      waveColor: MyTheme.buttonColor,
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
                        ? const Text(" ")
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
                      child: BoxUI.boxHasRadius(
                        width: 200,
                        padding: const EdgeInsets.all(10),
                        color: MyTheme.lightColor,
                        child: Row(
                          children: [
                            const Icon(Icons.not_started_rounded),
                            Text(
                              "全部開始",
                              style: whiteText(),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        if (connectDeviec.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (ctx) => const AlertDialog(
                              content: Text("尚未連接裝置"),
                            ),
                          );
                        } else {
                          EasyLoading.instance.indicatorWidget = SizedBox(
                            width: 75,
                            height: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SpinKitPouringHourGlassRefined(
                                  color: MyTheme.color,
                                ),
                                const Text("復健中")
                              ],
                            ),
                          );

                          EasyLoading.show();

                          if (trainCount < 3) {}
                          for (var element in characteristicList) {
                            element.write(utf8.encode("E-fu"));
                          }
                        }
                      },
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: TextButton(
                    //         onPressed: () async {
                    //           logger.v(toSave.length);
                    //           Format a = await recordRepo
                    //               .record(ArrangeDate("t01", toSave));
                    //           if (a.message == "ok") {
                    //             logger.v("成功");
                    //           }
                    //         },
                    //         child: const Text("傳送"),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: TextButton(
                    //         onPressed: () async {
                    //           for (var element in hasPair) {
                    //             element.disconnect();
                    //           }
                    //           setState(() {
                    //             connectDeviec = {};
                    //             hasPair = [];
                    //           });
                    //         },
                    //         child: const Text("關閉"),
                    //       ),
                    //     ),
                    //   ],
                    // )
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
