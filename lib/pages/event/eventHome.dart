import 'dart:convert';

import 'package:e_fu/module/boxUI.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:e_fu/request/record/record.dart';
import 'package:e_fu/myData.dart';
import 'package:flutter/material.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<StatefulWidget> createState() => EventHomeState();
}

class EventHomeState extends State<EventHome> {
  List<EAppointment> _list = [];
  ERepo eRepo = ERepo();
  CalendarFormat? _calendarFormat;
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  late final ValueNotifier<List<EAppointment>> _selectedEvents;

  // List<EAppointment> _selectedEvents=[];

  Future<List<EAppointment>> getEAppointment() async {
    List<EAppointment> res = [];
    try {
      EasyLoading.show(status: "loading ...");
      Format d = await eRepo.getAps("11136008");
      print(d.D);
      if (d.D.runtimeType != String) res = parseEApointment(jsonEncode(d.D));
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
      return res;
    }
  }

  @override
  void initState() {
    super.initState();
    _list = [];
    _selectedDay = DateTime.now();

    _selectedEvents = ValueNotifier(_getEventsForDay(DateTime.now()));

    getEAppointment().then((value) {
      setState(() {
        _list = value;
        _getEventsForDay(DateTime.now());
      });
    });
  }

  List<EAppointment> _getEventsForDay(DateTime day) {
    return _list.where((element) {
      DateTime target = element.tf_id.start_date;
      return (target.day == day.day &&
          target.year == day.year &&
          target.month == day.month);
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "復健安排",
          style: TextStyle(fontSize: 30),
        ),
        (TableCalendar(
          calendarFormat: _calendarFormat ?? CalendarFormat.week,
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay ?? DateTime.now(),
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: _onDaySelected,
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
          calendarBuilders: CalendarBuilders(
          
            todayBuilder: (context, day, focusedDay) {
               final text = DateFormat.d().format(day);

              return BoxUI.boxHasRadius(
                margin:EdgeInsets.all(3) ,
                  color: MyTheme.lightColor,
                  child: Center(
                    
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
            },
            selectedBuilder: (context, day, focusedDay) {
              final text = DateFormat.d().format(day);

              return BoxUI.boxHasRadius(
                margin:EdgeInsets.all(3) ,
                  color: MyTheme.color,
                  child: Center(
                    
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
            },
            dowBuilder: (context, day) {
              if (day.weekday == DateTime.sunday) {
                final text = DateFormat.E().format(day);

                return Center(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          ),
        )),
        const SizedBox(height: 8.0),
        Expanded(
            child: ValueListenableBuilder<List<EAppointment>>(
                valueListenable: _selectedEvents,
                builder: ((context, value, child) {
                  return _selectedEvents.value.length == 0
                      ? Container()
                      : ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: GestureDetector(
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  height: 100,
                                  width: 600,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('${value[index].tf_id.time}')
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: MyTheme.buttonColor),
                                        child: Text(
                                          '${value[index].count}',
                                          style: whiteText(),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.edit_square))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "/event",
                                      arguments: value[index]);
                                },
                              ),
                            );
                          });
                })))
      ],
    );

    Column(
      children: [
        const Text(
          "復健安排",
          style: TextStyle(fontSize: 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
            const Text("今天"),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios))
          ],
        ),
        getUI()
      ],
    );
  }

  Widget getUI() {
    if (_list.isEmpty) {
      return Container();
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 350,
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 100,
                width: 600,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('${_list[index].tf_id.time}')],
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: MyTheme.buttonColor),
                      child: Text(
                        '${_list[index].count}',
                        style: whiteText(),
                      ),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit_square))
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, "/event", arguments: _list[index]);
              },
            );
          },
        ),
      );
    }
  }
}
