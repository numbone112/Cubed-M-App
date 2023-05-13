
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
      this.rightButton});
  Widget body;
  BuildContext? buildContext;
  String title;
  Widget? floatButton;
  Function? change;
  GestureDetector? rightButton;

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
        child: Column(
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
                      style: const TextStyle(fontSize: 25),
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
            widget.body
          ],
        ),
      ),
    ));
  }
}
