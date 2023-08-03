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
