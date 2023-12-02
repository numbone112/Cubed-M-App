import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

alert(BuildContext context, String alertTitle, String alertTxt) async {
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text(alertTitle),
      content: Text(alertTxt),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('關閉', style: TextStyle(color: MyTheme.color)),
        ),
      ],
    ),
  );
}
