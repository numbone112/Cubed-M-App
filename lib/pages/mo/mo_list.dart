import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/cusbehiver.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/mo/mo.dart';
import 'package:flutter/material.dart';

class MoList extends StatefulWidget {
  static const routeName = '/mo';
  String userName;
  MoList({super.key, required this.userName});

  @override
  MoListPageState createState() => MoListPageState();
}

class MoListPageState extends State<MoList> {
  MoRepo moRepo = MoRepo();

  //@override
  // Future initState() async {
  //   moRepo.getMo(widget.userName);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("管理Mo伴"),
          backgroundColor: MyTheme.lightColor,
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          color: MyTheme.backgroudColor,
          child: Column(
            children: [
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("隱藏名單",
                        style: TextStyle(
                            color: MyTheme.black, fontSize: MySize.body)),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        'assets/images/hind.png',
                        scale: 2,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: const Alignment(0, 0),
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/search.png',
                      scale: 1.5,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                  child: ListView(
                    children: [
                      BoxUI.boxHasRadius(
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
                                Text("ID:12444",
                                    style: TextStyle(
                                        color: MyTheme.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: MySize.body)),
                                const SizedBox(height: 5),
                                Text("王曉明",
                                    style: TextStyle(
                                        color: MyTheme.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MySize.subtitleSize))
                              ],
                            ),
                            GestureDetector(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                alignment: const Alignment(0, 0),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                      width: 1, color: MyTheme.lightColor),
                                ),
                                child: Text("隱藏",
                                    style:
                                        TextStyle(color: MyTheme.lightColor)),
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      )
                    ],
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
