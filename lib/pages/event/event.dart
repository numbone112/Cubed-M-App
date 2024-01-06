import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:e_fu/module/mqttHelper.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/pages/event/ble_device.dart';
import 'package:e_fu/pages/exercise/afterEvent.dart';
import 'package:e_fu/pages/exercise/event_record.dart';
import 'package:e_fu/request/exercise/eventRace_data.dart';
import 'package:e_fu/request/exercise/history.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
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

class EventState extends State<Event> with SingleTickerProviderStateMixin {
  int mode = 1;

  bool isBleOn = false;
  bool isScan = false;
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  Map<int, String> connectDevice = {};
  List<BluetoothCharacteristic> startCharList = [];
  List<BluetoothCharacteristic> signCharList = [];
  List<Record> toSave = [];
  List<BluetoothDevice> hasPair = [];
  AsciiDecoder asciiDecoder = const AsciiDecoder();
  List<String> exerciseItem = ["左手", "右手", "坐立"];
  List<String> levelItem = ["手臂屈舉", "椅子坐立"];
  Map<int, Set<String>> hasFinish = {};
  ERepo eRepo = ERepo();
  bool notyet = true;
  int trainCount = 0;
  List<EventRecord> eventRecordList = [];
  int trainGoal = 0;
  var logger = Logger();
  HistoryRepo historyRepo = HistoryRepo();
  InviteRepo inviteRepo = InviteRepo();
  ScrollController scrollController = ScrollController();
  ExpansionTileController expansionTileController = ExpansionTileController();
  List<EventRace> event_race = [];
  List<EventRace> originEvent_race = [];
  MqttHandler mqttHandler = MqttHandler();
  bool isExercise = false;
  bool exercising = false;

  //判斷裝置藍牙是否開啟
  Future<void> updateBleState() async {
    //判斷裝置是否支援藍芽套件
    // if (await FlutterBluePlus.isSupported == false) {
    // }

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.on) {
        await FlutterBluePlus.startScan();
        setState(() {
          isBleOn = true;
        });
      } else {
        setState(() {
          isBleOn = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateBleState();
    mqttHandler.connect(widget.userID);
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

  closeExercising() {
    setState(() {
      exercising = false;
    });
  }

  Future<void> finish() async {
    List<RecordSenderItem> detail = [];
    for (var element in eventRecordList) {
      element.processData(element.eventRecordInfo.age, true);
      detail.add(
        RecordSenderItem(
            done: element.done,
            total_score: element.total_avg,
            each_score: element.each_score,
            user_id: element.eventRecordInfo.user_id,
            i_id: element.eventRecordInfo.id),
      );
    }

    for (var element in hasPair) {
      element.disconnect();
    }

    //進入結果頁

    int inviteIndex = eventRecordList.first.eventRecordInfo.id;
    if (inviteIndex == -1) {
      // logger.v("invite index=-1");
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
          id: recordInfo.id,
          remark: recordInfo.remark);

      sendDataAndLeave(toSave, detail, invite);
    }
    logger.v("end finish");
  }

  sendDataAndLeave(List<Record> recordList, List<RecordSenderItem> reSenderList,
      Invite invite) async {
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AfterEventPage(
            userID: widget.userID,
            recordList: recordList,
            reSenderList: reSenderList,
            history: History(
              name: invite.name,
              time: invite.time,
              remark: invite.remark,
              m_id: invite.m_id,
              done: [],
              friend: invite.friend,
              i_id: invite.i_id,
              m_name: invite.m_name,
            ),
          ),
        ),
      );
    }
  }

  connect(BluetoothDevice device, int pIndex, EventRecord forEvent,
      String checkString, BuildContext context) async {
    List<BluetoothService> services = [];

    try {
      await device.connect();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      toast(context, "已連結到$checkString");
      setState(() {
        connectDevice[pIndex] = device.toString();
      });
    } on PlatformException catch (e) {
      if (e.code != 'already_connected') {
        rethrow;
      } else {}
    } finally {
      services = await device.discoverServices();
      final subscription = device.mtu.listen((int mtu) {
        // iOS: initial value is always 23, but iOS will quickly negotiate a higher value
        print("mtu $mtu");
      });

      device.cancelWhenDisconnected(subscription);

      if (Platform.isAndroid) {
        await device.requestMtu(512);
      }
    }
    setState(() {
      if (!hasPair.contains(device)) {
        hasPair.add(device);
        event_race.add(
          EventRace(
              name: forEvent.eventRecordInfo.user_name,
              times: 0,
              m_id: forEvent.eventRecordInfo.m_id,
              user_id: forEvent.eventRecordInfo.user_id),
        );
        originEvent_race.add(
          EventRace(
              name: forEvent.eventRecordInfo.user_name,
              times: 0,
              m_id: forEvent.eventRecordInfo.m_id,
              user_id: forEvent.eventRecordInfo.user_id),
        );
      }

      trainGoal = max(
          trainGoal, forEvent.eventRecordDetail.item.fold(0, (p, c) => p + c));
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
                    isExercise = false;
                  });
                  //全部結束
                  if (trainCount >= trainGoal) {
                    //關閉所有連線
                  }
                }
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
                logger.v('value length${value.length}');

                List<String> raw = string.split(",");
                if (string != "0.00,0.00,0.00,0.00,0.00,0.00,0.00,0") {
                  Record record = Record.getRecordJson(raw, trainCount,
                      forEvent.now, forEvent.eventRecordInfo.id);
                  toSave.add(record);
                  int index = event_race.indexWhere((element) =>
                      element.user_id == forEvent.eventRecordInfo.user_id);
                  EventRace temp = event_race[index];
                  temp.times = record.times.toInt();
                  setState(() {
                    event_race[index] = temp;
                  });
                }
              } catch (e) {
                logger.v('error$e');
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
                  String checkString = r.device.platformName;

                  if (checkString.contains("cubed M")) {
                    return ListTile(
                        title: Text(checkString),
                        onTap: () {
                          connect(
                              r.device, pIndex, forEvent, checkString, context);
                        });
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

  Widget exerciseBox(int index, BuildContext context) {
    EventRecord forEvent = eventRecordList[index];

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
          connectDevice.containsKey(index)
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
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      if (Platform.isAndroid) {
                        await FlutterBluePlus.turnOn();
                        setState(() {
                          isBleOn = true;
                        });
                      }
                    }
                  },
                ),
          const Padding(padding: EdgeInsets.all(1))
        ],
      ),
    );
  }

  //開始運動
  sendStart() async {
    if (connectDevice.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => const AlertDialog(
          content: Text("尚未連接裝置"),
        ),
      );
    } else {
      setState(() {
        exercising = true;
        isExercise = true;
        event_race = originEvent_race;
      });

      if (trainCount < 3) {}
      for (var element in signCharList) {
        await element.setNotifyValue(true);
      }
      for (int i = 0; i < startCharList.length; i++) {
        String sign =
            eventRecordList[i].now < 2 ? "cubed-M hand" : "cubed-M foot";

        startCharList[i].write(utf8.encode(sign));
      }
    }
  }

  List<Widget> levelBtn() {
    List<Widget> result = [];
    final filtersID = [1, 2];

    for (int i = 0; i < levelItem.length; i++) {
      result.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() {
          mode = filtersID[i];
        }),
        child: Box.textRadiusBorder(
          levelItem[i],
          margin: const EdgeInsets.only(right: 10),
          color: mode == filtersID[i] ? Colors.white : MyTheme.color,
          filling: mode == filtersID[i] ? MyTheme.color : Colors.white,
          border: MyTheme.color,
        ),
      ));
    }
    return result;
  }

  Widget levelPic() {
    String typeTxt = '';
    mode == 1 ? typeTxt = 'biceps' : typeTxt = 'chair_stand';
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Image.asset(
            'assets/images/male_$typeTxt.png',
            scale: 1,
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Image.asset(
            'assets/images/female_$typeTxt.png',
            scale: 1,
          ),
        ],
      ),
    );
  }

  //排序自己到第一位
  List<Widget> deepBoxs() {
    List<Widget> result = [];

    for (int i = 0; i < eventRecordList.length; i++) {
      EventRecord event = eventRecordList[i];
      if (event.eventRecordInfo.user_id == widget.userID) {
        result.insert(0, exerciseBox(i, context));
      } else {
        result.add(exerciseBox(i, context));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (event_race.isNotEmpty) {
      mqttHandler.publishMessage(jsonEncode(event_race), widget.userID);
    }
    if (eventRecordList.isEmpty) {
      setState(() {
        eventRecordList =
            ModalRoute.of(context)!.settings.arguments as List<EventRecord>;
      });
    }
    return Stack(children: [
      CustomPage(
        buildContext: context,
        title: '肌力運動',
        titWidget: Padding(
          padding: Space.onlyTopTen,
          child: Box.inviteInfo(
            Invite(
              name: eventRecordList.first.eventRecordInfo.name,
              remark: eventRecordList.first.eventRecordInfo.remark,
              time: eventRecordList.first.eventRecordInfo.time,
            ),
            false,
            context,
          ),
        ),
        headHeight: 118,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.68,
                child: ListView(
                  controller: scrollController,
                  children: [
                    eventRecordList.isEmpty
                        ? const Text(" ")
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.63,
                            child: ListView(children: deepBoxs())),
                    Box.boxHasRadius(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                          colorScheme: const ColorScheme.light(
                            primary: Colors.white,
                          ),
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          onExpansionChanged: ((value) {
                            if (value) {
                              scrollController.animateTo(
                                MediaQuery.of(context).size.height * 0.63,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.linear,
                              );
                            }
                          }),
                          collapsedShape:
                              Border.all(color: MyTheme.backgroudColor),
                          iconColor: Colors.black,
                          collapsedIconColor: Colors.black,
                          title: textWidget(text: "運動分級表"),
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: levelBtn()),
                            ),
                            levelPic(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Space.screenW8(context),
                child: Box.yesnoBox(context, () => finish(), () => sendStart(),
                    noTitle: '開始運動',
                    noColor: MyTheme.color,
                    yestTitle: '結束',
                    yesColor: MyTheme.lightColor),
              ),
            ],
          ),
        ),
      ),
      exercising
          ? showRace(context, event_race, closeExercising, isExercise)
          : Container()
    ]);
  }
}
