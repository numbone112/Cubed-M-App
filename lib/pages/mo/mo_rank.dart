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
            content: Container(
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

  @override
  Widget build(BuildContext context) {
    List<Rank> rankList = [
      Rank(name: "Wang", score: 20, rank: 1),
      Rank(name: "王皓婷", score: 19.5, rank: 2),
      Rank(name: "Angle", score: 17.7, rank: 3),
      Rank(name: "zhen", score: 15, rank: 4),
      Rank(name: "Albert", score: 13, rank: 5),
      Rank(name: "Amy", score: 9, rank: 6),
    ];
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Box.titleText("運動排行榜", gap: 10, fontSize: MySize.titleSize),
                  GestureDetector(
                    onTap: () => showInfo(),
                    child: Box.boxHasRadius(
                      child: Icon(
                        Icons.question_mark_outlined,
                        color: Colors.white,
                      ),
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              Center(
                child: Box.boxHasRadius(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("排名")),
                      DataColumn(label: Text("姓名")),
                      DataColumn(label: Text("分數"))
                    ],
                    rows: List.generate(rankList.length, (index) {
                      Rank r = rankList[index];
                      return DataRow(
                        onLongPress: () =>
                            Navigator.pushNamed(context, MoDetail.routeName),
                        color: index == widget.first
                            ? MaterialStateProperty.all(MyTheme.lightColor)
                            : null,
                        cells: [
                          DataCell(Text(r.rank.toString())),
                          DataCell(Text(r.name)),
                          DataCell(Text(r.score.toString()))
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
