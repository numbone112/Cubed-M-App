import 'package:e_fu/module/people_box.dart';
import 'package:flutter/material.dart';
import '../../myData.dart';

class ExampleItem {
  final String title;

  ExampleItem({
    required this.title,
  });
}

class People extends StatefulWidget {
  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyTheme.backgroudColor,
      body: Column(children: [
        const Text(
          "復健者",
          style: TextStyle(fontSize: 30),
        ),
        Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search",
                ),
              ),
            )),
        PeopleBox(
                id: "id",
                name: "王小明",
                height: "166",
                weight: "77",
                disease: [0, 1],
                gender: "男",
                birthday: DateTime(1988,1,2))
            .box(),
              PeopleBox(
                id: "id",
                name: "wang shi",
                height: "187",
                weight: "93",
                disease: [0, 1],
                gender: "男",birthday: DateTime(1978,3,2))
            .box()
      ]),
      floatingActionButton: Container(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
