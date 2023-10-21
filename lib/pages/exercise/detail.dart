// import 'dart:js_interop';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/exercise/history_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';

import '../../module/page.dart';

class HistoryDetailPerson extends StatefulWidget {
  final String userName;
  // final History history;

  const HistoryDetailPerson({super.key, required this.userName});
  static const routeName = '/history/detail/person';

  @override
  State<StatefulWidget> createState() => HistoryDetailPersonstate();
}

class HistoryDetailPersonstate extends State<HistoryDetailPerson> {
  int select = 0;
  List<DoneItem> dones = [];
  static final List<String> level_table = ["很差", "差", "普通", "好", "很好"];
  static final List<String> type = ["左手", "右手", '椅子坐立'];

  changeSelect(int s, List<DoneItem> origin) {
    setState(() {
      dones = origin.where((element) => element.type_id == s).toList();
      select = s;
    });
  }

  List<Widget> label(List<DoneItem> d) {
    List<Widget> result = [];
    for (var i = 0; i < type.length; i++) {
      result.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => changeSelect(i, d),
          child: Box.textRadiusBorder(type[i],
              font: select == i ? Colors.white : MyTheme.buttonColor,
              filling: select == i ? MyTheme.buttonColor : Colors.white,
              border: MyTheme.buttonColor,
              width: 75),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HistoryDeep;
    return (CustomPage(
      body: ListView(children: [
        Padding(padding: EdgeInsets.all(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(args.name),
                Text('男 66'),
              ],
            ),
            Column(
              children: [
                const Text("評分"),
                Box.textRadiusBorder(args.score.toString(),
                    font: Colors.white, filling: MyTheme.lightColor)
              ],
            )
          ],
        ),
        //各運動項目
        Row(
          children: label(args.done),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 300,
          child: ListView.builder(
            itemCount: dones.length,
            itemBuilder: (context, index) {
              return Box.boxHasRadius(
                height: 50,
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(index.toString()),
                    Text(dones[index].times.toString()),
                    Text(level_table[dones[index].level])
                  ],
                ),
              );
            },
            // children: [

            // ],
          ),
        )
      ]),
      title: '運動明細',
      headColor: MyTheme.lightColor,
      headTextColor: Colors.white,
      prevColor: Colors.white,
      buildContext: context,
    ));
  }
}
