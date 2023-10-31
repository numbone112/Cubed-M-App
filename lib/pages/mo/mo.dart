import 'package:e_fu/my_data.dart';
import 'package:e_fu/pages/mo/mo_list.dart';
import 'package:e_fu/pages/mo/mo_rank.dart';
import 'package:flutter/material.dart';

import '../../module/page.dart';

class Mo extends StatefulWidget {
  static const routeName = '/newhome';
  final int first = 1;
  const Mo({super.key, required this.userID});
  final String userID;

  @override
  State<Mo> createState() => _MoState();
}

class _MoState extends State<Mo> with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    // 建立 TabController，vsync 接受的型態是 TickerProvider
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      body: Column(children: [
        TabBar(
          indicatorColor: MyTheme.color,
          labelColor: MyTheme.color,
          unselectedLabelColor: MyTheme.hintColor,
          controller: tabController,
          tabs: const [
            Tab(
                child: Text("排行榜",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center)),
            Tab(
                child: Text("Mo 伴",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center)),
          ],
        ),
        Expanded(
          child: TabBarView(
              controller: tabController,
              children: [ MoRank(userID: widget.userID,), MoList(userID: widget.userID)]),
        ),
      ]),
    );
  }
}
