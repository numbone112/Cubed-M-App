// import 'dart:io';

// import 'package:e_fu/pages/event/ble_device.dart';
// import 'package:e_fu/pages/exercise/event.dart';
// import 'package:e_fu/request/record/record_data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:logger/logger.dart';

// class BleService {
//   bool isBleOn = false;
//   bool isScan = false;
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   //沒連線的裝置
//   List<BluetoothDevice> devicesList = <BluetoothDevice>[];
//   Map<int, String> connectDeviec = {};
//   List<BluetoothCharacteristic> characteristicList = [];
//   List<Record> toSave = [];
//   List<BluetoothDevice> hasPair = [];
//   // AsciiDecoder asciiDecoder = const AsciiDecoder();
//   List<BluetoothService> services = [];
//   String number = "0";
//   List<String> exerciseItem = ["左手", "右手", "坐立"];
//   // ERepo eRepo = ERepo();
//   bool notyet = true;
//   int trainCount = 0;
//   Logger logger = Logger();

//   void updateBleState() {
//     FlutterBluePlus.instance.state.listen((event) async {
//       if (event == BluetoothState.on) {
//         logger.v('藍牙狀態爲開啓');

//         isBleOn = true;
//       } else if (event == BluetoothState.off) {
//         logger.v('藍牙狀態爲關閉');

//         isBleOn = false;
//       } else {
//         logger.v('updateBleState: $event');
//         await FlutterBluePlus.instance.turnOn().then((value) {
//           isBleOn = true;
//         });
//       }
//     });
//   }

//   Future<void> omg() async {
//     for (BluetoothCharacteristic characteristic
//         in services.first.characteristics) {
//       if (characteristic.uuid.toString() == BleDevice.start) {
//         characteristicList.add(characteristic);
//       } else if (characteristic.uuid.toString() == BleDevice.endSign) {
//         characteristic.value.listen((value) {
//           if (value.isEmpty) {
//             logger.v("empty");
//           } else {
//             logger.v(value);
//           }
//         });
//         await characteristic.setNotifyValue(true);
//       } else if (characteristic.uuid.toString() == BleDevice.record) {
//         //一直接收
//         // characteristic.value.listen((value) {
//         //   try {
//         //     String string = String.fromCharCodes(value);
//         //     logger.v(string);
//         //     List<String> raw = string.split(",");
//         //     if (string ==
//         //         "0.00,0.00,0.00,0.00,0.00,0.00,0.00,0") {
//         //       logger.v("end here");

//         //       FlutterRingtonePlayer.play(
//         //         android: AndroidSounds.notification,
//         //         ios: IosSounds.glass,
//         //         looping: true, // Android only - API >= 28
//         //         volume: 0.3, // Android only - API >= 28
//         //         asAlarm: false, // Android only - all APIs
//         //       );
//         //       // logger.v("結束$trainCount / $trainGoal");

//         //       //結束後收到
//         //       trainCount++;
//         //       forEvent.data[forEvent.now]!
//         //           .add(toSave.last.times.toInt());
//         //       forEvent.changeProgress();
//         //       setState(() {
//         //         forEventList[pIndex] = forEvent;
//         //       });
//         //       //全部結束
//         //       if (trainCount >= trainGoal) {
//         //         //關閉所有連線
//         //         for (var element in hasPair) {
//         //           element.disconnect();
//         //         }
//         //         try {
//         //           logger.v("end done${forEvent.data}");
//         //           finish();
//         //         } catch (e) {
//         //           logger.v("event all done $e");
//         //         }
//         //         if (context.mounted) {
//         //           Navigator.pushReplacementNamed(
//         //               context, EventNowResult.routeName,
//         //               arguments: [
//         //                 [forEvent],
//         //                 eAppointment
//         //               ]);
//         //         }
//         //         logger.v("enter else");
//         //       }
//         //       if (trainCount < 3) {
//         //         //直接到下一個步驟
//         //         forEvent.change(trainCount);

//         //         setState(() {
//         //           forEventList[pIndex] = forEvent;
//         //         });
//         //       } else if (trainCount == 3) {
//         //         forEvent.change(0);

//         //         setState(() {
//         //           forEventList[pIndex] = forEvent;
//         //         });
//         //       } else if (trainCount < forEvent.goal) {
//         //         if (forEvent.data[forEvent.now]!.length ==
//         //             forEvent.appointmentDetail
//         //                 .item[forEvent.now]) {
//         //           forEvent.change(forEvent.now + 1);
//         //         }
//         //         setState(() {
//         //           forEventList[pIndex] = forEvent;
//         //         });
//         //       }
//         //     } else {
//         //       toSave.add(Record(
//         //           double.parse(raw[0]),
//         //           double.parse(raw[1]),
//         //           double.parse(raw[2]),
//         //           double.parse(raw[3]),
//         //           double.parse(raw[4]),
//         //           double.parse(raw[5]),
//         //           double.parse(raw[6]),
//         //           double.parse(raw[7]),
//         //           trainCount.toDouble(),
//         //           forEvent.now.toDouble(),
//         //           forEvent.appointmentDetail.id));
//         //     }
//         //   } catch (e) {
//         //     logger.v("error:$e");
//         //   }
//         // });
//         // try {
//         //   await characteristic.setNotifyValue(true);
//         // } catch (e) {
//         //   logger.v(e);
//         //   logger.v("await char set notifyvalue");
//         // }
//       }
//     }
//   }

//   Widget toPairDialog(EventRecord forEvent) {
//     return SizedBox(
//       width: double.minPositive,
//       height: 200,
//       child: StreamBuilder<List<ScanResult>>(
//         stream: FlutterBluePlus.instance.scanResults,
//         initialData: const [],
//         builder: (c, snapshot) => Column(
//           children: snapshot.data!.map(
//             (r) {
//               if (r.advertisementData.connectable && r.device.name != "") {
//                 try {
//                   String checkString = (Platform.isAndroid)
//                       ? r.device.name
//                       : r.advertisementData.localName;
//                   logger.v(checkString);
//                   if (checkString.substring(0, 4) == "e-fu") {
//                     return ListTile(
//                       title: Text(checkString),
//                       onTap: () async {
//                         try {
//                           await r.device.connect();
//                         } on PlatformException catch (e) {
//                           if (e.code != 'already_connected') {
//                             rethrow;
//                           }
//                         } finally {
//                           services = await r.device.discoverServices();
//                         }

//                         hasPair.add(r.device);
//                         // connectDeviec[pIndex] = r.device.id.toString();

//                         logger.v("連接到$checkString");
//                       },
//                     );
//                   } else {
//                     return Container();
//                   }
//                 } catch (e) {
//                   logger.v(e);
//                   return Container();
//                 }
//               } else {
//                 return Container();
//               }
//             },
//           ).toList(),
//         ),
//       ),
//     );
//   }

//   // //偵測是否在列印裝置
//   // _scan() {
//   //   FlutterBluePlus.instance.isScanning.listen((event) {
//   //     setState(() {
//   //       isScan = event;
//   //     });
//   //   });
//   // }
// }
