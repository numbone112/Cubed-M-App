import 'dart:convert';

import 'package:e_fu/pages/mo/mo_detail.dart';
import 'package:e_fu/request/mo/mo_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/pages/mo/hide_mo_list.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/cusbehiver.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/mo/get_mo_list_model.dart';
import 'package:e_fu/request/mo/mo.dart';

class MoList extends StatefulWidget {
  static const routeName = '/mo';
  final String userName;
  const MoList({super.key, required this.userName});

  @override
  MoListPageState createState() => MoListPageState();
}

class MoListPageState extends State<MoList> {
  MoRepo moRepo = MoRepo();
  List<Mo>? moList;
  var logger = Logger();
  List<Widget> moListWidget = [];

  @override
  void initState() {
    super.initState();
    moListWidget = [];
  }

  getMoList() {
    try {
      moRepo.getMoList(widget.userName).then((value) {
        setState(() {
          
          moList = parseMo(jsonEncode(value.D));
          moListWidget = [];
          for (int i = 0; i < moList!.length; i++) {
            moListWidget.add(moWiget(i));
          }
        });
      });
    } catch (e) {
      logger.v(e);
    }
  }

  Widget moWiget(int i) {
    return Box.boxHasRadius(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
      height: 80,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.pushNamed(context, MoDetail.routeName),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID:${moList![i].id}",
                    style: TextStyle(
                        color: MyTheme.black,
                        fontWeight: FontWeight.w400,
                        fontSize: MySize.body)),
                const SizedBox(height: 5),
                Text(moList![i].name,
                    style: TextStyle(
                        color: MyTheme.black,
                        fontWeight: FontWeight.bold,
                        fontSize: MySize.subtitleSize))
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: const Alignment(0, 0),
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Box.normamBorderRadius,
                border: Border.all(width: 1, color: MyTheme.lightColor),
              ),
              child: Text("隱藏", style: TextStyle(color: MyTheme.lightColor)),
            ),
            onTap: () {
              hindMo(moList![i].id);
              getMoList();
            },
          ),
        ],
      ),
    );
  }

  hindMo(String id) {
    moRepo.hindMo(Mo(id: id), widget.userName).then((value) {
      if (value.message == "已隱藏") {
        toast(context, "已隱藏");
      } else {
        logger.v(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (moList == null) {
      getMoList();
    }

    return Column(
      children: [
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("隱藏名單",
                  style:
                      TextStyle(color: MyTheme.black, fontSize: MySize.body)),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  'assets/images/hind.png',
                  scale: 2,
                ),
              ),
            ],
          ),
          onTap: () => Navigator.pushNamed(context, HindMoList.routeName,
              arguments: widget.userName),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          alignment: const Alignment(0, 0),
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: Box.normamBorderRadius,
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/search.png',
                scale: 1.5,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: TextField(
                    cursorColor: MyTheme.lightColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "搜尋",
                      hintStyle: TextStyle(color: MyTheme.hintColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: (moList == null)
                ? Container(
                    color: MyTheme.backgroudColor,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 64),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: MyTheme.lightColor,
                      ),
                    ),
                  )
                : ListView(children: moListWidget),
          ),
        ),
      ],
    );
  }
}
