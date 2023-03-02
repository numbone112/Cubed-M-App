import 'package:e_fu/module/arrange.dart';
import 'package:e_fu/pages/event/event.dart';
import 'package:e_fu/pages/event/eventList.dart';
import 'package:flutter/material.dart';
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
          child: Column(children: [
            SizedBox(
              
              height: 300,
              child: ListView.builder(
                    itemCount: selected_arrange?.peopleNumber,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.people),
                        title: Text('${selected_arrange?.people?[index].id}'),
                        subtitle: TextButton(
                          child: Text("連接"),
                          onPressed: () {},
                        ),
                      );
                    },
                  ),
            ),
            TextButton(onPressed: (){}, child: Text("全部開始"))
          ],)
          
                  
        );
      } else {
        setState(() {
          _page = 0;
        });
        return Container();
      }
    }
  }
}
