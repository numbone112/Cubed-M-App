import 'dart:convert';
import 'dart:math';

import 'package:e_fu/module/arrange.dart';
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

  Future<List<EAppointment>> getEAppointment() async {
    Format d = await eRepo.getAps("11136008");
    print(d.D);
    if (d.D.runtimeType==String) return [];
    return parseEApointment(jsonEncode(d.D));
  }

  @override
  void initState() {
    super.initState();
    _list = [];
    getEAppointment().then((value) {
      // print(value.length);
      setState(() {
        _list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      children: [Text('${_list[index].id.time}')],
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
                Navigator.pushNamed(context, "/event",arguments:_list[index] );
              },
            );
          },
        ),
      );
    }
  }
}
