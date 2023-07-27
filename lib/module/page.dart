import 'package:e_fu/module/cusbehiver.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  CustomPage(
      {super.key,
      required this.body,
      this.buildContext,
      required this.title,
      this.floatButton,
      this.change,
      this.rightButton,
      this.headColor,
      this.headTextColor});
  Widget body;
  BuildContext? buildContext;
  String title;
  Widget? floatButton;
  Function? change;
  GestureDetector? rightButton;
  Color? headColor;
  Color? headTextColor;

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
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CusBehavior(),
          child: ListView(
            children: [
              Container(
                color: widget.headColor,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
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
                              style: TextStyle(
                                  fontSize: 25, color: widget.headTextColor),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: widget.rightButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              widget.body
            ],
          ),
        ),
      ),
    ));
  }
}
