import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/pages/event/event.dart';
import 'package:e_fu/pages/event/event_result.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

class EventHome extends StatefulWidget {
   EventHome({super.key,required this.userName});
   String userName;

  @override
  State<StatefulWidget> createState() => EventHomeState();
}

class EventHomeState extends State<EventHome> {
  List<EAppointment> _list = [];
  ERepo eRepo = ERepo();
  CalendarFormat? _calendarFormat;
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  Logger logger = Logger();
  late final ValueNotifier<List<EAppointment>> _selectedEvents;

  // List<EAppointment> _selectedEvents=[];

  Future<List<EAppointment>> getEAppointment() async {
    List<EAppointment> res = [];
    try {
      EasyLoading.show(status: "loading ...");
      Format d = await eRepo.getAps(widget.userName);
      logger.v(d.D);
      logger.v(d.D);
      if (d.D.runtimeType != String) res = parseEApointment(jsonEncode(d.D));
      return res;
    } catch (e) {
      logger.v(e);
      return [];
    } finally {
      EasyLoading.dismiss();
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
        _selectedEvents.value = _getEventsForDay(DateTime.now());
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
    return SafeArea(
      child: Column(
        children: <Widget>[
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
                  margin: const EdgeInsets.all(3),
                  color: MyTheme.lightColor,
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                final text = DateFormat.d().format(day);
    
                return BoxUI.boxHasRadius(
                  margin: const EdgeInsets.all(3),
                  color: MyTheme.color,
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday) {
                  final text = DateFormat.E().format(day);
    
                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          )),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<EAppointment>>(
              valueListenable: _selectedEvents,
              builder: ((context, value, child) {
                return _selectedEvents.value.isEmpty
                    ? Container()
                    : ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          EAppointment appointment = value[index];
                          List<String> splitTime =
                              appointment.tf_id.time.split(":");
    
                          bool overTime = appointment.tf_id.start_date
                              .add(Duration(hours: int.parse(splitTime[0])))
                              .isAfter(DateTime.now());
    
                          return GestureDetector(
                            child: BoxUI.boxHasRadius(
                                height: 100,
                                width: 600,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Text(value[index].tf_id.time)],
                                    ),
                                    BoxUI.boxHasRadius(
                                      width: 50,
                                      height: 30,
                                      color: MyTheme.buttonColor,
                                      child: Center(
                                        child: Text(
                                          '${value[index].count}',
                                          style: whiteText(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: (overTime)
                                            ? const Icon(Icons.edit_square)
                                            : const Icon(Icons
                                                .check_circle_outline_rounded))
                                  ],
                                )),
                            onTap: () {
                              if (overTime) {
                                Navigator.pushNamed(context, Event.routeName,
                                    arguments: value[index]);
                              } else {
                                Navigator.pushNamed(
                                    context, EventResult.routeName,
                                    arguments: value[index]);
                              }
                            },
                          );
                        },
                      );
              }),
            ),
          )
        ],
      ),
    );
  }
}
