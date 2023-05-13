
import 'package:e_fu/pages/people/people_list.dart';
import 'package:e_fu/pages/people/people_detail.dart';
import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  // int page = 1;

  const PeoplePage({super.key});

  @override
  PeoplePageState createState() => PeoplePageState();
}

class PeoplePageState extends State<PeoplePage> {
  int page=1;
  void toChange(int target) {
    setState(() {
      page = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (page == 1)
          ? PeopleList(function: toChange)
          : (page == 2)
              ? PeopleDetail(
                  function: toChange,
                )
              : Container(),
    );
  }
}
