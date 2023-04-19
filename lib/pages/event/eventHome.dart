import 'dart:convert';

import 'package:e_fu/module/arrange.dart';
import 'package:e_fu/request/record/record.dart';
import 'package:e_fu/myData.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:http/http.dart';

import '../../request/data.dart';
import '../../request/record/record_data.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<StatefulWidget> createState() => EventHomeState();
}

class EventHomeState extends State<EventHome> {
  int _page = 0;
  List<Arrange> _list = [];
  Arrange? selected_arrange;
  bool isBleOn = false;
  bool isScan = false;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  //沒連線的裝置
  List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  Map<int, String> connectDeviec = {};
  List<BluetoothCharacteristic> characteristic_list = [];
  List<Record> to_save = [];
  List<BluetoothDevice> hasPair = [];
  AsciiDecoder asciiDecoder = AsciiDecoder();
  String number = "0";

  // List<>

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _list = [
      Arrange(time: "9:00", peopleNumber: 3, people: [
        People(
            id: "555",
            items: [Items(typeId: 0, quota: 5), Items(typeId: 1, quota: 5)]),
        People(
            id: "554",
            items: [Items(typeId: 0, quota: 5), Items(typeId: 1, quota: 5)]),
        People(
            id: "553",
            items: [Items(typeId: 0, quota: 5), Items(typeId: 1, quota: 5)])
      ]),
      Arrange(time: "9:00", peopleNumber: 3, people: [
        People(
            id: "555",
            items: [Items(typeId: 0, quota: 5), Items(typeId: 1, quota: 5)]),
        People(
            id: "554",
            items: [Items(typeId: 0, quota: 5), Items(typeId: 1, quota: 5)]),
        People(
            id: "553",
            items: [Items(typeId: 0, quota: 5), Items(typeId: 1, quota: 5)])
      ]),
      Arrange(time: "11:00", peopleNumber: 1, people: [
        People(
            id: "555",
            items: [Items(typeId: 0, quota: 5), Items(typeId: 1, quota: 5)]),
      ])
    ];

    @override
    void dispose() {
      FlutterBluePlus.instance.stopScan();
    }

    @override
    void deactivate() {
      for (var element in devicesList) {
        if (connectDeviec.containsValue(element.id.toString())) {
          element.disconnect();
        }
      }
    }

    FlutterBluePlus.instance.state.listen((state) {
      if (state == BluetoothState.on) {
        print('藍牙狀態爲開啓');
        setState(() {
          isBleOn = true;
        });
      } else if (state == BluetoothState.off) {
        print('藍牙狀態爲關閉');
        setState(() {
          isBleOn = false;
        });
      }
    });
    // _scan();
  }

  //偵測是否在列印裝置
  _scan() {
    FlutterBluePlus.instance.isScanning.listen((event) {
      setState(() {
        isScan = event;
      });
    });
  }

  var recordRepo = RecordRepo();

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      
      children: [
        _page==1?IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () { setState(() {
          _page=0;
        }); },):Container(),
        Column(
          children: [
            Text("時間"),
            Flexible(child: getUI()),
            IconButton(onPressed: (){}, icon: const Icon(Icons.not_started_rounded))
          ],
        ),
      ],
    ));
  }

  Widget toPairDialog(int pIndex) {
    return SizedBox(
      width: double.minPositive,
      height: 200,
      child: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.instance.scanResults,
        initialData: const [],
        builder: (c, snapshot) => Column(
          children: 
              snapshot.data!.map(
                (r) {
                  
                  if (r.advertisementData.connectable && r.device.name != "") {
                    if (r.device.name.substring(0, 4) == "e-fu" ||
                        r.device.name.substring(0, 4) == "Ardu") {
                          // print(r.device.services);
                      return ListTile(
                        title: Text(r.device.name),
                        onTap: () async {
                          List<BluetoothService> _services = [];

                          try {
                            await r.device.connect();
                          } on PlatformException catch (e) {
                            if (e.code != 'already_connected') {
                              rethrow;
                            }
                          } finally {
                            _services = await r.device.discoverServices();
                          }
                          setState(() {
                            hasPair.add(r.device);
                            connectDeviec[pIndex] = r.device.id.toString();
                          });
                          
                          print("連接到" + r.device.name);
                          print(connectDeviec);
                          for (BluetoothCharacteristic characteristic
                              in _services.first.characteristics) {
                            print(characteristic.uuid.toString());
                            if (characteristic.uuid.toString() ==
                                "0000ff00-0000-1000-8000-00805f9b34fb") {
                              characteristic_list.add(characteristic);
                            } else if (characteristic.uuid.toString() ==
                                "0000ff01-0000-1000-8000-00805f9b34fb") {
                              characteristic.value.listen((value) {
                                print("enter heree");
                                try {
                                  print("from number:" + value.toString());

                                  number = String.fromCharCodes(value);
                                } catch (e) {
                                  print("number char errors");
                                }
                              });
                            } else {
                              characteristic.value.listen((value) {
                                try {
                                  String string = String.fromCharCodes(value);
                                  List<String> raw = string.split(",");

                                  to_save.add(Record(
                                      double.parse(raw[0]),
                                      double.parse(raw[1]),
                                      double.parse(raw[2]),
                                      double.parse(raw[3]),
                                      double.parse(raw[4]),
                                      double.parse(raw[5])));
                                } catch (e) {
                                  print("error:" + e.toString());
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
                  } else {
                    return Container();
                  }
                },
              ).toList(),
        ),
      ),
    );
  }

  Widget getUI() {
    if (_page == 0) {
      if (_list.isEmpty) {
        return Container();
      } else {
        return ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.event_seat),
              title: Text('${_list[index].time}'),
              subtitle: Text('${_list[index].peopleNumber}'),
              onTap: () {
                setState(() {
                  selected_arrange = _list[index];
                  _page = 1;
                });
              },
            );
          },
        );
      }
    } else {
      if (selected_arrange != null) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: selected_arrange?.peopleNumber,
                    itemBuilder: (context, index) {
                      
                      int pIndex = index;
                      return 
                     
                      ListTile(
                        
                        trailing: connectDeviec.containsKey(index)?Text("已連接"):TextButton(
                          
                                child: Text("連接"),
                                onPressed: () async {
                                  FlutterBluePlus.instance.state
                                      .listen((state) {
                                    if (state == BluetoothState.on) {
                                      print('藍牙狀態爲開啓');
                                      setState(() {
                                        isBleOn = true;
                                      });
                                    } else if (state == BluetoothState.off) {
                                      print('藍牙狀態爲關閉');
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
                                          timeout: Duration(seconds: 4));
                                    }
                                    await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text("您已開啟藍芽"),
                                        content: toPairDialog(pIndex),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
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
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    child: Text("是否要開啟藍芽？"),
                                                    alignment: Alignment(0, 0),
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                CupertinoDialogAction(
                                                  child: Text('取消'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: Text('開啟藍芽'),
                                                  onPressed: () async {
                                                    await FlutterBluePlus
                                                        .instance
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
                                            ));
                                  }
                                },
                              ),
                        leading:                           Icon(Icons.people),

                        title: Text('${selected_arrange?.people?[index].id}'),
                            
                      );
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      characteristic_list.forEach((element) {
                        element.write(utf8.encode("true"));
                      });
                    },
                    child: Text("全部開始")),
                TextButton(
                  onPressed: () async {
                    print(to_save.length);
                    Format a =
                        await recordRepo.record(Arrange_date("t01", to_save));
                    if (a.message == "ok") {
                      print("成功");
                    }
                  },
                  child: Text("傳送"),
                ),
                TextButton(
                  onPressed: () async {
                    for (var element in hasPair) {
                      element.disconnect();
                    }
                    setState(() {
                      connectDeviec = {};
                      hasPair = [];
                    });
                  },
                  child: Text("關閉"),
                ),
                TextButton(
                  onPressed: () async {
                    print("numbers: " + number);
                  },
                  child: Text("print"),
                )
              ],
            ));
      } else {
        setState(() {
          _page = 0;
        });
        return Container();
      }
    }
  }
}
