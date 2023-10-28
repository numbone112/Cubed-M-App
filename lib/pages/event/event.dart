import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:age_calculator/age_calculator.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/pages/event/ble_device.dart';
import 'package:e_fu/pages/exercise/event_record.dart';
import 'package:e_fu/pages/exercise/history.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';
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

import 'package:e_fu/request/record/record_data.dart';

class Event extends StatefulWidget {
  static const routeName = '/event';

  const Event({super.key, required this.userName});
  final String userName;

  @override
  State<StatefulWidget> createState() => EventState();
}

class EventState extends State<Event> {
  List<EventRecordInfo> selectedArrange = [];
  List<EventRecordInfo> doing = [];

  bool isBleOn = false;
  bool isScan = false;
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  //沒連線的裝置
  List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  Map<int, String> connectDeviec = {};
  List<BluetoothCharacteristic> startCharList = [];
  List<BluetoothCharacteristic> signCharList = [];
  List<Map<String, dynamic>> toSave = [];
  List<BluetoothDevice> hasPair = [];
  AsciiDecoder asciiDecoder = const AsciiDecoder();
  List<String> exerciseItem = ["左手", "右手", "坐立"];
  Map<int, Set<String>> hasFinish = {};
  ERepo eRepo = ERepo();
  bool notyet = true;
  int trainCount = 0;
  List<EventRecord> forEventList = [];
  int trainGoal = 0;
  var logger = Logger();
  HistoryRepo historyRepo = HistoryRepo();
  InviteRepo inviteRepo = InviteRepo();

  Future<void> updateBleState() async {
    if (await FlutterBluePlus.isSupported == false) {
      return;
    }

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.on) {
        logger.v('藍牙狀態爲開啓');
        Set<DeviceIdentifier> seen = {};
        var subscription = FlutterBluePlus.scanResults.listen(
          (results) {
            for (ScanResult r in results) {
              if (seen.contains(r.device.remoteId) == false) {
                seen.add(r.device.remoteId);
              }
            }
          },
        );
        await FlutterBluePlus.startScan();

        setState(() {
          isBleOn = true;
        });
      } else {
        logger.v('藍牙狀態爲關閉');
        setState(() {
          isBleOn = false;
        });
        if (Platform.isAndroid) {
          await FlutterBluePlus.turnOn();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateBleState();
  }

  @override
  void dispose() {
    super.dispose();
    for (var element in hasPair) {
      element.disconnect();
    }
    EasyLoading.instance.indicatorWidget = SpinKitWaveSpinner(
      color: MyTheme.backgroudColor,
      trackColor: MyTheme.color,
      waveColor: MyTheme.buttonColor,
    );
  }

  //偵測是否在列印裝置
  _scan() {
    FlutterBluePlus.isScanning.listen((event) {
      setState(() {
        isScan = event;
      });
    });
  }

  Future<void> finish() async {
    List<RecordSenderItem> detail = [];
    for (var element in forEventList) {
      //補年紀
      element.processData(
          // AgeCalculator()
          70,
          true);
      detail.add(RecordSenderItem(
          done: element.done,
          score: element.avg,
          user_id: element.eventRecordInfo.name,
          i_id: element.eventRecordInfo.id));
    }
    // 傳送資料給後端
    Format a =
        await recordRepo.record(RecordSender(raw: toSave, detail: detail));
    if (a.message == "ok") {
      logger.v("成功");
    }
    for (var element in hasPair) {
      element.disconnect();
    }

    //跳結果頁
    if (context.mounted) {
      int inviteIndex = forEventList.first.eventRecordInfo.id;
      if (inviteIndex == -1) {
        Invite invite =
            Invite(m_id: widget.userName, friend: [widget.userName]);
        await inviteRepo.createInvite(invite).then((value) async {
          await inviteRepo
              .searchInvite(widget.userName, invite.time)
              .then((value) async {
            inviteIndex = parseInviteList(jsonEncode(value.D))[0].id;
            logger.v("inviteIndex$inviteIndex");
            await historyRepo
                .historyList(widget.userName, iId: inviteIndex.toString())
                .then((value) {
              History history = parseHistoryList(jsonEncode(value.D))[0];
              Navigator.pushReplacementNamed(
                  context, HistoryDetailPage.routeName,
                  arguments: history);
            });
          });
        });
      } else {
        await historyRepo
            .historyList(widget.userName, iId: inviteIndex.toString())
            .then((value) {
          History history = parseHistoryList(jsonEncode(value.D))[0];
          Navigator.pushReplacementNamed(context, HistoryDetailPage.routeName,
              arguments: history);
        });
      }
    }
    logger.v("enter else");
  }

  connect(BluetoothDevice device, int pIndex, EventRecord forEvent,
      String checkString) async {
    List<BluetoothService> services = [];

    try {
      await device.connect();
    } on PlatformException catch (e) {
      if (e.code != 'already_connected') {
        rethrow;
      } else {}
    } finally {
      services = await device.discoverServices();
    }
    setState(() {
      hasPair.add(device);
      trainGoal = max(
          trainGoal, forEvent.eventRecordDetail.item.fold(0, (p, c) => p + c));
      connectDeviec[pIndex] = device.toString();
    });
    for (var service in services) {
      for (BluetoothCharacteristic element in service.characteristics) {
        switch (element.uuid.toString()) {
          case BleDevice.start:
            startCharList.add(element);
            break;
          case BleDevice.endSign:
            signCharList.add(element);
            final chrSubscription =
                element.onValueReceived.listen((value) async {
              if (value.isEmpty) {
                logger.v("empty");
              } else {
                String string = String.fromCharCodes(value);
                logger.v("endsign not empty$string\n$value");
                // await element.setNotifyValue(false);

                if (!forEventList[pIndex].endSign.contains(string)) {
                  FlutterRingtonePlayer.play(
                    android: AndroidSounds.notification,
                    ios: IosSounds.glass,
                    looping: true, // Android only - API >= 28
                    volume: 0.3, // Android only - API >= 28
                    asAlarm: false, // Android only - all APIs
                  );
                  logger.v("結束$trainCount / $trainGoal");

                  //結束後收到
                  // int setsMax = 0;
                  // for (var element in forEventList) {
                  //   setsMax = max(setsMax, element.endSign.length);
                  // }

                  // forEvent.data[forEvent.now]!.add(toSave.last.times.toInt());

                  forEvent.reviceEndSign(string);
                  setState(() {
                    forEventList[pIndex] = forEvent;
                    trainCount = EventRecord.getMax(forEventList);
                  });
                  //全部結束
                  if (trainCount >= trainGoal) {
                    //關閉所有連線
                  }
                }
                EasyLoading.dismiss();
              }
            });

            device.cancelWhenDisconnected(chrSubscription);

            await element.setNotifyValue(true);
            break;
          case BleDevice.record:
            final chrSubscription =
                element.onValueReceived.listen((value) async {
              try {
                String string = String.fromCharCodes(value);
                List<String> raw = string.split(",");
                if (string != "0.00,0.00,0.00,0.00,0.00,0.00,0.00,0") {
                  toSave.add(Record.getRecordJson(raw, trainCount.toDouble(),
                      forEvent.now.toDouble(), forEvent.eventRecordInfo.id));
                }
              } catch (e) {
                logger.v("error:$e");
              }
            });
            device.cancelWhenDisconnected(chrSubscription);
            await element.setNotifyValue(true);
            break;
          default:
        }
      }
    }
    logger.v("連接到$checkString");

    await FlutterBluePlus.stopScan();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget toPairDialog(int pIndex) {
    EventRecord forEvent = forEventList[pIndex];
    return SizedBox(
      width: double.minPositive,
      height: 200,
      child: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.scanResults,
        initialData: const [],
        builder: (c, snapshot) => Column(
          children: snapshot.data!.map(
            (r) {
              if (r.advertisementData.connectable &&
                  r.device.platformName != "") {
                try {
                  String checkString = (Platform.isAndroid)
                      ? r.device.platformName
                      : r.advertisementData.localName;
                  // logger.v(checkString);
                  if (checkString.contains("e-fu")) {
                    return ListTile(
                      title: Text(checkString),
                      onTap: () =>
                          connect(r.device, pIndex, forEvent, checkString),
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

  var recordRepo = RecordRepo();
  
  Widget optional(EventRecord forEvent) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            forEvent.eventRecordInfo.name,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget exerciseBox(index) {
    EventRecord forEvent = forEventList[index];
    logger.v(forEvent.eventRecordInfo.name);
    return Container(
      height: 225,
      decoration: const BoxDecoration(
          borderRadius: Box.normamBorderRadius, color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          optional(forEvent),
          Row(
            children: List.generate(
              exerciseItem.length,
              (eIndex) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!forEvent.hasLeft(eIndex)) {
                      forEvent.change(eIndex);
                      setState(() {
                        forEventList[index] = forEvent;
                      });
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      (forEvent.now == eIndex)
                          ? Box.boxHasRadius(
                              child: Text(
                                exerciseItem[eIndex],
                                style: textStyle(color: Colors.white),
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
                            return '${forEvent.eventRecordDetail.item[eIndex]}';
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
          ),
          connectDeviec.containsKey(index)
              ? const Text("已連接")
              : GestureDetector(
                  child: Box.boxHasRadius(
                      child: Text(
                        "連接",
                        style: textStyle(color: Colors.white),
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
                        // flutterBlue.startScan(
                        //     timeout: const Duration(seconds: 4));
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
                                await FlutterBluePlus.turnOn().then((value) {
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
  Widget build(BuildContext context) {
    if (forEventList.isEmpty) {
      forEventList =
          ModalRoute.of(context)!.settings.arguments as List<EventRecord>;
    }
    return CustomPage(
      buildContext: context,
      title: '肌力運動',
      titWidget: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Box.inviteInfo(Invite(), false),
      ),
      headHeight: 100,
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              forEventList.isEmpty
                  ? const Text(" ")
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: ListView.builder(
                        itemCount: forEventList.length,
                        itemBuilder: ((context, index) {
                          return (exerciseBox(index));
                        }),
                      ),
                    ),
              Box.boxHasRadius(
                child: ExpansionTile(
                  collapsedShape: Border.all(color: MyTheme.backgroudColor),
                  title: const Text("運動分級表"),
                  children: const [Text("運動分級表詳細資料")],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Box.textRadiusBorder(
                      "全部開始",
                      filling: MyTheme.lightColor,
                      width: 100,
                    ),
                    onTap: () async {
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
                              const Text("運動中")
                            ],
                          ),
                        );

                        EasyLoading.show();

                        if (trainCount < 3) {}
                        for (var element in signCharList) {
                          await element.setNotifyValue(true);
                        }
                        for (var element in startCharList) {
                          element.write(utf8.encode("E-fu"));
                        }
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () => finish(),
                    child: Box.textRadiusBorder(
                      "結束",
                      filling: MyTheme.lightColor,
                      width: 100,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
