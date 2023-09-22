import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/mo/moDetail.dart';
import 'package:e_fu/pages/mo/mo_list.dart';
import 'package:e_fu/pages/mo/mo_rank.dart';
import 'package:flutter/material.dart';

import '../../module/cusbehiver.dart';

class Mo extends StatefulWidget {
  static const routeName = '/newhome';
  final int first = 1;
  const Mo({super.key, required this.userName});
  final String userName;

  @override
  State<Mo> createState() => _MoState();
}

class _MoState extends State<Mo> with SingleTickerProviderStateMixin {
  late TabController tabController;
  void initState() {
    // 建立 TabController，vsync 接受的型態是 TickerProvider
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: SingleChildScrollView(
        child: Column(children: [
          TabBar(
            indicatorColor: MyTheme.buttonColor,
            labelStyle: TextStyle(color: MyTheme.buttonColor),
            unselectedLabelStyle: const TextStyle(color: Colors.black12),
            labelColor: MyTheme.buttonColor,
            controller: tabController,
            tabs: [
              Tab(
                child: Box.titleText("排行榜", alignment: Alignment.center),
              ),
              Tab(
                child: Box.titleText("Mo伴", alignment: Alignment.center),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            child: TabBarView(controller: tabController, children: [
              MoRank(),
              MoList(userName: widget.userName)
            ]),
          )
        ]),
      ),
    );
  }
}
