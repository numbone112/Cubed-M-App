import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/module/page.dart';
import 'package:e_fu/module/people_box.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter/material.dart';

class ExampleItem {
  final String title;

  ExampleItem({
    required this.title,
  });
}

class PeopleList extends StatefulWidget {
  const PeopleList({super.key, required this.function});
  final Function(int a) function;

  @override
  PeopleListState createState() => PeopleListState();
}

class PeopleListState extends State<PeopleList> {
  ERepo eRepo = ERepo();
  List<dynamic> peopleList = List.empty();
  var logger = Logger();

  Future<List<EPeople>> getData() async {
    List<EPeople> res = [];
    EasyLoading.show(status: "loading ...");
    try {
      Format a = await eRepo.getFus("11136008");

      if (a.D.runtimeType == String) return [];
      res = parseEpeople(jsonEncode(a.D));
    } catch (e) {
      logger.v(e);
    } finally {
      EasyLoading.dismiss();
    }
    return res;
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        peopleList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "查詢復健者",
      body: peopleList.isEmpty
          ? Container()
          : Column(
              children: <Widget>[
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search",
                          ),
                        ),
                      ),
                    ),
                  ] +
                  List.generate(
                    peopleList.length,
                    (index) => GestureDetector(
                      child: PeopleBox(
                        birthday: peopleList[index].birthday,
                        disease: peopleList[index].disease,
                        gender: peopleList[index].sex,
                        height: peopleList[index].height,
                        id: peopleList[index].id,
                        name: peopleList[index].name,
                        weight: '55',
                      ).box(),
                      onTap: () {
                        widget.function(2);
                      },
                    ),
                  ),
            ),
    );
  }
}
