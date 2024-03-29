import 'dart:convert';

import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/toast.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/mo/mo_detail.dart';
import 'package:e_fu/request/mo/mo.dart';
import 'package:e_fu/request/user/get_user_data.dart';
import 'package:flutter/material.dart';

import '../../module/cusbehiver.dart';

class MoRank extends StatefulWidget {
  final String userID;
  final int first = 1;
  const MoRank({super.key, required this.userID});

  @override
  State<MoRank> createState() => _MoState();
}

class Rank {
  Rank({required this.name, required this.rank, required this.score});
  String name;
  double score;
  int rank;
}

class _MoState extends State<MoRank> {


  List<Widget> rankTable(List<GetUser> r) {
    return List.generate(
      r.length,
      (index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MoDetail(
              userID: widget.userID,
              friend: r[index],
            ),
          ),
        ),
        child: Box.boxHasRadius(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: textWidget(
                    text: (index + 1).toString(),
                    textAlign: TextAlign.center,
                    type: TextType.content),
              ),
              Expanded(
                flex: 1,
                child: textWidget(
                  text:r[index].name,
                  textAlign: TextAlign.center,
                  type: TextType.content
                ),
              ),
              Expanded(
                flex: 1,
                child: textWidget(
                  text:r[index].score.toString(),
                  textAlign: TextAlign.center,
                  type: TextType.content
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<GetUser> getuserList = [];
  MoRepo moRepo = MoRepo();
  final labels = ["排名", "姓名", "分數"];
  @override
  Widget build(BuildContext context) {
    if (getuserList.isEmpty) {
      moRepo.rank(widget.userID).then((value) {
        setState(() {
          getuserList = parseGetUserList(jsonEncode(value.D));
        });
      });
    }

    return getuserList.isEmpty
        ? Container()
        : ScrollConfiguration(
            behavior: CusBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => showMoInfo(context),
                          child: Box.boxHasRadius(
                              child: Icon(
                                Icons.question_mark_outlined,
                                size: 20,
                                color: MyTheme.color,
                              ),
                              color: MyTheme.backgroudColor,
                              border:
                                  Border.all(color: MyTheme.color, width: 1.5)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: List.generate(
                            labels.length,
                            (index) => Expanded(
                              flex: 1,
                              child: textWidget(
                                  text: labels[index],
                                  textAlign: TextAlign.center,
                                  type: TextType.content),
                            ),
                          ),
                        ),
                      ),
                    ] +
                    rankTable(getuserList),
              ),
            ),
          );
  }
}
