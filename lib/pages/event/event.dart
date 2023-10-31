import 'dart:convert';
import 'dart:io';
import 'dart:math';
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

  const Event({super.key, required this.userID});
  final String userID;

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
  // List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  Map<int, String> connectDeviec = {};
  List<BluetoothCharacteristic> startCharList = [];
  List<BluetoothCharacteristic> signCharList = [];
  List<Record> toSave = [];
  List<BluetoothDevice> hasPair = [];
  AsciiDecoder asciiDecoder = const AsciiDecoder();
  List<String> exerciseItem = ["左手", "右手", "坐立"];
  Map<int, Set<String>> hasFinish = {};
  ERepo eRepo = ERepo();
  bool notyet = true;
  int trainCount = 0;
  List<EventRecord> eventRecordList = [];
  int trainGoal = 0;
  var logger = Logger();
  HistoryRepo historyRepo = HistoryRepo();
  InviteRepo inviteRepo = InviteRepo();

  Future<void> updateBleState() async {
    // if (await FlutterBluePlus.isSupported == false) {
    // }

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
          setState(() {
            isBleOn = true;
          });
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
    for (var element in eventRecordList) {
      //補年紀
      element.processData(
          // AgeCalculator(element.eventRecordInfo.age)
          70,
          true);
      detail.add(RecordSenderItem(
          done: element.done,
          total_score: element.total_avg,
          each_score: element.each_score,
          user_id: element.eventRecordInfo.user_id,
          i_id: element.eventRecordInfo.id));
      print("from event finish ${element.total_avg}");
    }

    for (var element in hasPair) {
      element.disconnect();
    }

    //跳結果頁

    int inviteIndex = eventRecordList.first.eventRecordInfo.id;
    if (inviteIndex == -1) {
      Invite invite = Invite(m_id: widget.userID, friend: [widget.userID]);
      await inviteRepo.createInvite(invite).then((value) async {
        await inviteRepo
            .searchInvite(widget.userID, invite.time)
            .then((value) async {
          inviteIndex = parseInviteList(jsonEncode(value.D))[0].id;
          invite.i_id = inviteIndex;
          sendDataAndLeave(changeRecordID(toSave, inviteIndex),
              changeSenderItemID(detail, inviteIndex), invite);
        });
      });
    } else {
      EventRecordInfo recordInfo = eventRecordList.first.eventRecordInfo;
      Invite invite = Invite(
          m_id: recordInfo.m_id,
          name: recordInfo.name,
          i_id: recordInfo.id,
          remark: recordInfo.remark);

      sendDataAndLeave(toSave, detail, invite);
    }
    logger.v("end finish");
  }

  sendDataAndLeave(List<Record> recordList, List<RecordSenderItem> reSenderList,
      Invite invite) async {
        print("sendDataAndLeave${reSenderList.length}");
        print("sendDataAndLeave${reSenderList.first.total_score}");
        print("sendDataAndLeave${reSenderList.first.done.length}");
    // 傳送資料給後端
    await recordRepo
        .record(RecordSender(record: recordList, detail: reSenderList))
        .then((value) async {
      if (value.message == "新增成功") {
        logger.v("成功");
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, HistoryDetailPage.routeName,
              arguments: History(
                  name: invite.name,
                  time: invite.time,
                  remark: invite.remark,
                  m_id: invite.m_id,
                  done: [],
                  friend: invite.friend,
                  i_id: invite.i_id,
                  m_name: invite.m_name));
        }
      }
    });
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

                if (!eventRecordList[pIndex].endSign.contains(string)) {
                  FlutterRingtonePlayer.play(
                    android: AndroidSounds.notification,
                    ios: IosSounds.glass,
                    looping: true, // Android only - API >= 28
                    volume: 0.3, // Android only - API >= 28
                    asAlarm: false, // Android only - all APIs
                  );
                  logger.v("結束$trainCount / $trainGoal");

                  //結束後收到

                  forEvent.reviceEndSign(string);
                  setState(() {
                    eventRecordList[pIndex] = forEvent;
                    trainCount = EventRecord.getMax(eventRecordList);
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
                  toSave.add(Record.getRecordJson(raw, trainCount, forEvent.now,
                      forEvent.eventRecordInfo.id));
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
    EventRecord forEvent = eventRecordList[pIndex];
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

                  if (checkString.contains("cubed M")) {
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

  RecordRepo recordRepo = RecordRepo();
  Widget optional(EventRecord forEvent) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            forEvent.eventRecordInfo.user_name,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget exerciseBox(index) {
    EventRecord forEvent = eventRecordList[index];
    logger.v(forEvent.eventRecordInfo.user_name);
    return Container(
      height: 210,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
          borderRadius: Box.normamBorderRadius, color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: textWidget(
                text: forEvent.eventRecordInfo.user_name,
                type: TextType.content,
                color: MyTheme.buttonColor),
          ),
          Row(
            children: List.generate(
              exerciseItem.length,
              (eIndex) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!forEvent.hasLeft(eIndex)) {
                      forEvent.change(eIndex);
                      setState(() {
                        eventRecordList[index] = forEvent;
                      });
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Box.boxHasRadius(
                          child: textWidget(
                              text: exerciseItem[eIndex],
                              color:
                                  forEvent.now == eIndex ? Colors.white : null,
                              type: TextType.content,
                              textAlign: TextAlign.center),
                          color: forEvent.now == eIndex
                              ? MyTheme.color
                              : Colors.white,
                          width: 50,
                          padding: const EdgeInsets.all(7)),
                      const Padding(padding: EdgeInsets.all(5)),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: EProgress(
                          progress: forEvent.progress[eIndex] ?? 0,
                          colors: [MyTheme.color],
                          showText: true,
                          format: (progress) {
                            return '${forEvent.eventRecordDetail.item[eIndex]}';
                          },
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: "taipei",
                              color: forEvent.now == eIndex
                                  ? MyTheme.buttonColor
                                  : Colors.black),
                          type: ProgressType.dashboard,
                          backgroundColor: MyTheme.gray,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          connectDeviec.containsKey(index)
              ? textWidget(
                  text: '已連結', type: TextType.content, color: MyTheme.color)
              : GestureDetector(
                  child: Box.textRadiusBorder('連結',
                      textType: TextType.content,
                      padding: const EdgeInsets.all(5),
                      filling: MyTheme.buttonColor,
                      width: 75,
                      height: 40),
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
                      if (Platform.isIOS) {
                        await showDialog(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            content: const Column(
                              children: [
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
                    }
                  },
                ),
          const Padding(padding: EdgeInsets.all(2))
        ],
      ),
    );
  }

  sendStart() async {
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
  }

  @override
  Widget build(BuildContext context) {
    if (eventRecordList.isEmpty) {
      eventRecordList =
          ModalRoute.of(context)!.settings.arguments as List<EventRecord>;
    }
    return CustomPage(
        buildContext: context,
        title: '肌力運動',
        titWidget: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Box.inviteInfo(
              Invite(
                  name: eventRecordList.first.eventRecordInfo.name,
                  remark: eventRecordList.first.eventRecordInfo.remark,
                  time: eventRecordList.first.eventRecordInfo.time),
              false),
        ),
        headHeight: 100,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView(
                  children: [
                    eventRecordList.isEmpty
                        ? const Text(" ")
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: ListView.builder(
                              // physics: const NeverScrollableScrollPhysics(),

                              itemCount: eventRecordList.length,
                              itemBuilder: ((context, index) {
                                return (exerciseBox(index));
                              }),
                            ),
                          ),
                    Box.boxHasRadius(
                      child: ExpansionTile(
                        collapsedShape:
                            Border.all(color: MyTheme.backgroudColor),
                        title: const Text("運動分級表"),
                        children: const [Text("運動分級表詳細資料")],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Box.yesnoBox(() => finish(), () => sendStart(),
                    noTitle: '開始運動',
                    noColor: MyTheme.color,
                    yestTitle: '結束',
                    yesColor: MyTheme.lightColor),
              ),
            ],
          ),
        ));
  }
}
