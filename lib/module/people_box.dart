import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';
import 'package:age_calculator/age_calculator.dart';

class PeopleBox {
  String name;
  double height;
  String weight;
  String gender;
  DateTime birthday;
  List<String> disease;

  PeopleBox(
      {
        
      required this.name,
      required this.height,
      required this.weight,
      required this.gender,
      required this.disease,
      required this.birthday});

  Widget box() {
    TextStyle wText = textStyle();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Box.boxHasRadius(
            padding: const EdgeInsets.fromLTRB(100, 8, 8, 8),
            height: 100,
            width: 600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("年齡 : ${AgeCalculator.age(birthday).years}"),
                    Text("身高 : $height"),
                    Text("體重 : $weight"),
                  ],
                ),
                Column(
                  children: <Widget>[const Text("疾病")]+List.generate(disease.length, (index) => Text(disease[index])),
                ),
              ],
            ),
          ),
          Box.boxHasRadius(
              height: 100,
              width: 100,
              color: MyTheme.lightColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: wText,
                  ),
                  Text(
                    gender,
                    style: wText,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
