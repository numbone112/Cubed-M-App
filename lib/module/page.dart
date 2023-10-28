import 'package:e_fu/module/cusbehiver.dart';
import 'package:e_fu/my_data.dart';
import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  const CustomPage(
      {super.key,
      required this.body,
      this.buildContext,
      this.title,
      this.headHeight,
      this.headTexttype,
      this.floatButton,
      this.change,
      this.rightButton,
      this.headColor,
      this.headTextColor,
      this.prevColor,
      this.width,
      this.titWidget,
      this.safeAreaColor});
  final Widget body;
  final BuildContext? buildContext;
  final String? title;
  final double? headHeight;
  final int? headTexttype;
  final Widget? floatButton;
  final Function? change;
  final GestureDetector? rightButton;
  final Color? headColor;
  final Color? headTextColor;
  final Color? prevColor;
  final double? width;
  final Widget? titWidget;
  final Color? safeAreaColor;

  @override
  State<StatefulWidget> createState() => CustomPageState();
}

class CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: widget.safeAreaColor ?? MyTheme.backgroudColor,
      resizeToAvoidBottomInset: true,
      floatingActionButton: widget.floatButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: widget.headColor ?? MyTheme.backgroudColor,
        child: SafeArea(
          bottom: false,
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: Container(
              color: MyTheme.backgroudColor,
              child: Column(
                children: [
                  widget.title != null
                      ? Container(
                          color: widget.headColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: (widget.buildContext != null)
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.arrow_back_ios,
                                                size: 15,
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
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: widget.headHeight ??
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                          child: widget.titWidget ??
                                              textWidget(
                                                  text: widget.title ?? "",
                                                  type: widget.headTexttype ??
                                                      TextType.fun,
                                                  color: widget.headTextColor,
                                                  textAlign: TextAlign.center)),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: widget.rightButton,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: SizedBox(
                      width: widget.width ??
                          MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: widget.body,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
