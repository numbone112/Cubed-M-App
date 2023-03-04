import 'package:e_fu/module/arrange.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:http/http.dart';

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
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  //沒連線的裝置
  List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  Map<int, String> connectDeviec = {};

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
    ];

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

    _scan();
  }

  //印出可連結藍芽裝置
  _scan() {
    devicesList = [];
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name != "") {
          if (r.device.name.substring(0, 3) == "LED" &&
              !devicesList.contains(r.device) &&
              r.advertisementData.connectable) {
            devicesList.add(r.device);
            print('${r.device.name} found! rssi: ${r.rssi}');
          }
        }
      }
    });

    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: getUI());
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
                      int p_index = index;
                      return ListTile(
                        leading: Icon(Icons.people),
                        title: Text('${selected_arrange?.people?[index].id}'),
                        subtitle: TextButton(
                          child: Text("連接"),
                          onPressed: () async {
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
                            if (isBleOn) {
                              _scan();
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("您已開啟藍芽"),
                                  content: Container(
                                    width: double.minPositive,
                                    height: 200,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: devicesList.length,
                                      itemBuilder: (context, index) {
                                        var d = devicesList[index];
                                        return ListTile(
                                          title: Text(d.name),
                                          onTap: () {
                                            d.connect().then((value) {
                                              connectDeviec[p_index] =
                                                  d.id.toString();
                                              print("連接到" + d.name);
                                              print(connectDeviec);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    ),
                                  ),
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
                                      ));
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                TextButton(onPressed: () {}, child: Text("全部開始"))
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
