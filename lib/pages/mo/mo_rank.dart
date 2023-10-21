import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/mo/moDetail.dart';
import 'package:flutter/material.dart';

import '../../module/cusbehiver.dart';

class MoRank extends StatefulWidget {
  static const routeName = '/newhome';
  final int first = 1;
  const MoRank({super.key});

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
  showInfo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Box.titleText("好友是什麼？",
                      gap: 10, fontSize: MySize.subtitleSize),
                  Text("曾一起運動的朋友。", style: myText(color: MyTheme.hintColor)),
                  Box.titleText("運動綜合評分如何計算？",
                      gap: 10, fontSize: MySize.subtitleSize),
                  Text("從運動者最後一次運動中，將各動作等級換算成數字，再以算術平均計算。",
                      style: myText(color: MyTheme.hintColor)),
                ],
              ),
            ),
          );
        });
  }

  List<Widget> rankTable(List<Rank> r) {
    return List.generate(
      r.length,
      (index) => Box.boxHasRadius(
        height: 50,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                r[index].rank.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                r[index].name,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                r[index].score.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Rank> rankList = [
      Rank(name: "Wang", score: 2.0, rank: 1),
      Rank(name: "王皓婷", score: 1.95, rank: 2),
      Rank(name: "Angle", score: 1.77, rank: 3),
      Rank(name: "zhen", score: 1.5, rank: 4),
      Rank(name: "Albert", score: 1.3, rank: 5),
      Rank(name: "Amy", score: 0.9, rank: 6),
    ];
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => showInfo(),
                    child: Box.boxHasRadius(
                        child: Icon(
                          Icons.question_mark_outlined,
                          size: 20,
                          color: MyTheme.color,
                        ),
                        color: MyTheme.backgroudColor,
                        border: Border.all(color: MyTheme.color, width: 1.5)),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "排名",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "姓名",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "分數",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ] +
              rankTable(rankList),
        ),
      ),
    );
  }
}
