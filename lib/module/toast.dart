import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/exercise_process.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toast(BuildContext context, String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black45,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16);
}

setTarget(BuildContext context, List<ItemWithField> items,
    {Function()? yes, Function()? no}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          title: textWidget(
              text: '設定運動組數', type: TextType.fun, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: ListView(
                      children: items
                          .map((e) =>
                              Box.setsBox(e.item, e.textEditingController))
                          .toList(),
                    ),
                  ),
                  Expanded(
                      child:
                          Box.yesnoBox(yes ?? () {}, no ?? () {}, width: 100.0))
                ],
              ),
            ),
          ),
        );
      });
}
