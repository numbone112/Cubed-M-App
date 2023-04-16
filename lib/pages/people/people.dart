
import 'package:flutter/material.dart';
import '../../myData.dart';

class People extends StatelessWidget {
  const People({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: [
        const Text("各種復健者",style: TextStyle(fontSize: 30),),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: MyTheme.backgroudColor),
            onPressed: () {
             
            },
            child: const Text("哈囉一號"))
      ]),
    );
  }
}
