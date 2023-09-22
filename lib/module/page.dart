import 'package:e_fu/module/cusbehiver.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  const CustomPage(
      {super.key,
      required this.body,
      this.buildContext,
      this.title,
      this.floatButton,
      this.change,
      this.rightButton,
      this.headColor,
      this.headTextColor,
      this.prevColor,
      this.width,
      this.titWidget});
  final Widget body;
  final BuildContext? buildContext;
  final String? title;
  final Widget? floatButton;
  final Function? change;
  final GestureDetector? rightButton;
  final Color? headColor;
  final Color? headTextColor;
  final Color? prevColor;
  final double? width;
  final Widget? titWidget;

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
          child: Column(
            children: [
              widget.title != null
                  ? Container(
                      color: widget.headColor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: (widget.buildContext != null)
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: widget.prevColor,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(
                                                  widget.buildContext!);
                                            },
                                          )
                                        : (widget.change != null)
                                            ? IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_back_ios),
                                                onPressed: () =>
                                                    widget.change!.call(),
                                              )
                                            : Container(),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: widget.titWidget??
                                      Text(
                                        widget.title ?? "",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: widget.headTextColor),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      ),),
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
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                width: widget.width ?? MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: widget.body,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
