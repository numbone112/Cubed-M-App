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
  @override
  Widget build(BuildContext context) {
    return (CustomPage(
      body: ListView(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text("小明明"),
                Text('男 66'),
              ],
            ),
            Column(
              children: [
                const Text("評分"),
                BoxUI.textRadiusBorder('4.1',
                    font: Colors.white, filling: MyTheme.lightColor)
              ],
            )
          ],
        ),
        //各運動項目
        Row(
          children: [
            BoxUI.textRadiusBorder("左手",
                font: Colors.white, filling: MyTheme.buttonColor),
            BoxUI.textRadiusBorder("右手",
                font: MyTheme.buttonColor,
                filling: Colors.white,
                border: MyTheme.buttonColor),
            BoxUI.textRadiusBorder("椅子坐立",
                width: 75,
                font: MyTheme.buttonColor,
                filling: Colors.white,
                border: MyTheme.buttonColor)
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 300,
          child: ListView(
            children: [
              BoxUI.boxHasRadius(
                height: 50,
                margin: EdgeInsets.only(top: 15,bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,  
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Text("1"), Text("25次"), Text("好")],
                ),
              ),
              BoxUI.boxHasRadius(
                height: 50,
                margin: EdgeInsets.only(top: 15,bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,  
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Text("2"), Text("25次"), Text("好")],
                ),
              ),
            ],
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
