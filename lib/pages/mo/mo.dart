import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

class Mo extends StatefulWidget {
  static const routeName = '/newhome';
  int i = 1;
  Mo({super.key});
  // final String userName;

  @override
  State<Mo> createState() => _MoState();
}

class Rank {
  Rank({required this.name, required this.rank, required this.score});
  String name;
  double score;
  int rank;
}

class _MoState extends State<Mo> {
  @override
  Widget build(BuildContext context) {
    List<Rank> rankList = [
      Rank(name: "王細明", score: 20, rank: 1),
      Rank(name: "王小明", score: 19.5, rank: 2),
      Rank(name: "羅針明", score: 17.7, rank: 3),
      Rank(name: "郭會明", score: 15, rank: 4),
      Rank(name: "林哲明", score: 13, rank: 5),
      Rank(name: "邱家明", score: 9, rank: 6),
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: (Column(
        children: [
          BoxUI.titleText("運動排行榜", 5),
          BoxUI.boxHasRadius(
            child: DataTable(
                columns: [
                  DataColumn(label: Text("排名")),
                  DataColumn(label: Text("姓名")),
                  DataColumn(label: Text("分數"))
                ],
                rows: List.generate(rankList.length, (index) {
                  Rank r = rankList[index];
                  return DataRow(
                      color: index == widget.i
                          ? MaterialStateProperty.all(MyTheme.lightColor)
                          : null,
                      cells: [
                        DataCell(Text(r.rank.toString())),
                        DataCell(Text(r.name)),
                        DataCell(Text(r.score.toString()))
                      ]);
                })),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.8,
          //   height: 300,
          //   child: BoxUI.boxHasRadius(
          //       child: ListView.builder(
          //           itemBuilder: (content, index) {
          //             if (index == 0) {
          //               return const Row(
          //                 children: [
          //                   Expanded(child: Text("排名")),
          //                   Expanded(child: Text("姓名")),
          //                   Expanded(child: Text("分數"))
          //                 ],
          //               );
          //             } else {
          //               Rank r = rankList[index - 1];
          //               return Row(
          //                 children: [
          //                   Expanded(child: Text(r.rank.toString())),
          //                   Expanded(child: Text(r.name)),
          //                   Expanded(child: Text(r.score.toString()))
          //                 ],
          //               );
          //             }
          //           },
          //           itemCount: rankList.length + 1)),
          // ),
          BoxUI.titleText("Mo伴是什麼？", 5),
          const Text("曾一起運動的朋友。"),
          BoxUI.titleText("運動綜合評分如何計算？", 5),
          const Text("從運動者最後一次運動中，將各動作等級換算成數字，再以算術平均計算。"),
        ],
      )),
    );
  }
}
