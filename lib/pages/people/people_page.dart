
import 'package:e_fu/pages/people/people_list.dart';
import 'package:e_fu/pages/people/people_detail.dart';
import 'package:e_fu/request/e/e_data.dart';
import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  // int page = 1;

  const PeoplePage({super.key});

  @override
  PeoplePageState createState() => PeoplePageState();
}

class PeoplePageState extends State<PeoplePage> {
  int page=1;
  EPeople? _ePeople;
  void toChange(int target) {
    setState(() {
      page = target;
    });
  }
  void toDetail(EPeople ePeople){
    setState(() {
      page=2;
      _ePeople=ePeople;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (page == 1)
          ? PeopleList(function: toDetail)
          : (page == 2)
              ? PeopleDetail(
                  function: toChange,
                  ePeople: _ePeople!,
                )
              : Container(),
    );
  }
}
