import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/exerciseProcess.dart';
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
          //shape 可以改變形狀
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          title: const Text("設定運動組數"),

          content: Container(
            height: 300,
            width: 300,
            child: Column(
              children: items
                      .map((e) => Box.setsBox(e.item, e.textEditingController))
                      .toList() +
                  [Box.yesnoBox(yes ?? () {}, no ?? () {})],
            ),
          ),
        );
      });
}
