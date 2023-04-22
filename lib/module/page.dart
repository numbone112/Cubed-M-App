import 'dart:ui';

import 'package:e_fu/myData.dart';
import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  CustomPage(
      {super.key,
      required this.body,
      this.buildContext,
      required this.title,
      this.floatButton,
      this.change});
  Widget body;
  BuildContext? buildContext;
  String title;
  Widget? floatButton;
  Function? change;

  @override
  State<StatefulWidget> createState() => CustomPageState();
}

class CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: MyTheme.backgroudColor,
      resizeToAvoidBottomInset: true,
      floatingActionButton: widget.floatButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: (widget.buildContext != null)
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(widget.buildContext!);
                        },
                      )
                    : (widget.change != null)
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () => widget.change!.call(),
                          )
                        : Container(),
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
          this.widget.body
        ],
      ),
    ));
  }
}
