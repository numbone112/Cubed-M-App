import 'dart:convert';

import 'package:e_fu/module/page.dart';
import 'package:e_fu/request/mo/mo_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:e_fu/request/mo/get_hind_mo_list_model.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/mo/mo.dart';

class HindMoList extends StatefulWidget {
  static const routeName = '/mo/hind';
  final String userName;
  const HindMoList({super.key, required this.userName});

  @override
  HindMoListState createState() => HindMoListState();
}

class HindMoListState extends State<HindMoList> {
  MoRepo moRepo = MoRepo();
  List<Mo>? hindMoList;
  var logger = Logger();
  List<Widget> hindMoListWidget = [];

  @override
  void initState() {
    super.initState();
    hindMoListWidget = [];
  }

  getHindMoList() {
    try {
      moRepo.getHindMoList(widget.userName).then((value) {
        setState(() {
          hindMoList = parseMo(jsonEncode(value.D));
          hindMoListWidget = [];
          for (int i = 0; i < hindMoList!.length; i++) {
            hindMoListWidget.add(hindMoWiget(i));
          }
        });
      });
    } catch (e) {
      logger.v(e);
    }
  }

  Widget hindMoWiget(int i) {
    return Box.boxHasRadius(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
      height: 80,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID:${hindMoList![i].id}",
                  style: TextStyle(
                      color: MyTheme.black,
                      fontWeight: FontWeight.w400,
                      fontSize: MySize.body)),
              const SizedBox(height: 5),
              Text(hindMoList![i].name,
                  style: TextStyle(
                      color: MyTheme.black,
                      fontWeight: FontWeight.bold,
                      fontSize: MySize.subtitleSize))
            ],
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: const Alignment(0, 0),
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:Box.normamBorderRadius,
                border: Border.all(width: 1, color: MyTheme.pink),
              ),
              child: Text("取消", style: TextStyle(color: MyTheme.pink)),
            ),
            onTap: () {
              showMo(hindMoList![i].id);
              getHindMoList();
            },
          ),
        ],
      ),
    );
  }

  showMo(String id) {
    moRepo.showMo(widget.userName, id).then((value) {
      if (value.message == "已取消隱藏") {
        toast(context, "已取消隱藏");
      } else {
        logger.v(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hindMoList == null) {
      getHindMoList();
    }

    return CustomPage(
      body: (hindMoList == null)
          ? Container(
              color: MyTheme.backgroudColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 64),
              child: Center(
                  child: CircularProgressIndicator(
                color: MyTheme.lightColor,
              )),
            )
          : ListView(
              children: hindMoListWidget,
            ),
      title: "隱藏Mo伴",
      headColor: MyTheme.lightColor,
      buildContext: context,
      headTextColor: Colors.white,
      prevColor: Colors.white,
    );
  }
}
