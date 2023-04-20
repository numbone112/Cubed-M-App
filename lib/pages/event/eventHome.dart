
import 'package:e_fu/module/arrange.dart';
import 'package:e_fu/request/record/record.dart';
import 'package:e_fu/myData.dart';
import 'package:flutter/material.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<StatefulWidget> createState() => EventHomeState();
}

class EventHomeState extends State<EventHome> {
  List<Arrange> _list = [];

  @override
  void initState() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        ),
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
                margin: const EdgeInsets.all(10),
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
                      children: [Text('${_list[index].time}')],
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: MyTheme.buttonColor),
                      child: Text(
                        '${_list[index].peopleNumber}',
                        style: whiteText(),
                      ),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit_square))
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, "/event");
              },
            );
          },
        ),
      );
    }
  }
}
