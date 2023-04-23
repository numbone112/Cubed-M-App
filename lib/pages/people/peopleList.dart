import 'dart:convert';

import 'package:e_fu/module/page.dart';
import 'package:e_fu/module/people_box.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/e/e.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter/material.dart';
import '../../myData.dart';

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

  Future<List<EPeople>> getData() async {
    Format a = await eRepo.getFus("11136008");
    print(a.D);
    if( a.D.runtimeType==String) return [];
    return parseEpeople(jsonEncode(a.D));
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
      floatButton: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 70),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: MyTheme.buttonColor,
          onPressed: () {},
          elevation: 0,
          label: const Text(
            "新增復健者",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
      body: peopleList.isEmpty
          ? const Text("wait")
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
