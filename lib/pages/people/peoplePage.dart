import 'package:e_fu/module/page.dart';

import 'package:e_fu/pages/people/peopleList.dart';
import 'package:e_fu/pages/people/people_detail.dart';
import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  int page = 1;

  @override
  PeoplePageState createState() => PeoplePageState();
}

class PeoplePageState extends State<PeoplePage> {
  void toChange(int target) {
    setState(() {
      widget.page = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (widget.page == 1)
          ? PeopleList(function: toChange)
          : (widget.page == 2)
              ? PeopleDetail(
                  function: toChange,
                )
              : Container(),
    );
  }
}
