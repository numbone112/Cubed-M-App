import 'dart:convert';

import 'package:e_fu/main.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/util.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/user/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';

import 'my_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sign extends StatefulWidget {
  static const routeName = '/sign';

  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  String account = "";
  String psw = "";
  TextEditingController accountInput = TextEditingController();
  TextEditingController pswInput = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController phoneInput = TextEditingController();
  TextEditingController sexInput = TextEditingController();
  TextEditingController nameInput = TextEditingController();
  
  String _selectSex = "";
  List<String> _sexChoice = <String>[
    '男',
    '女',
  ];
  final BorderRadius _borderRadius =
      const BorderRadius.all(Radius.circular(10));

  TextField inputBox(TextEditingController t, bool h, String hintText) {
    return (TextField(
      obscureText: h,
      controller: t,
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 25 * 4),
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          ///设置边框四个角的弧度
          borderRadius: _borderRadius,

          ///用来配置边框的样式
          borderSide: BorderSide(
            ///设置边框的颜色
            color: MyTheme.color,

            ///设置边框的粗细
            width: 2.0,
          ),
        ),

        ///设置输入框可编辑时的边框样式
        enabledBorder: OutlineInputBorder(
          ///设置边框四个角的弧度
          borderRadius: _borderRadius,

          ///用来配置边框的样式
          borderSide: BorderSide(
            ///设置边框的颜色
            color: MyTheme.color,

            ///设置边框的粗细
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          ///设置边框四个角的弧度
          borderRadius: _borderRadius,

          ///用来配置边框的样式
          borderSide: const BorderSide(
            ///设置边框的颜色
            color: Colors.red,

            ///设置边框的粗细
            width: 2.0,
          ),
        ),
      ),
    ));
  }

  Widget buttonCustom(String s, Function f) {
    return Box.boxHasRadius(
      color: MyTheme.buttonColor,
      child: GestureDetector(
        onTap: () => f.call(),
        child: Box.textRadiusBorder(s, border: MyTheme.buttonColor),
      ),
    );
  }

  var logger = Logger();
  // var userRepo = UserRepo();
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MyTheme.backgroudColor,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Image.asset(
                    'assets/images/logo.png',
                    scale: 3,
                  ),
                ),
                TextInput.radius('帳號', accountInput,
                    height: 50, color: MyTheme.color),

                const Padding(padding: EdgeInsets.only(top: 10)),
                TextInput.radius('密碼', pswInput,
                    height: 50,
                    color: MyTheme.color,
                    isHidden: _isHidden,
                    hasHidden: true,
                    hiddenState: _togglePasswordView),
                TextInput.radius('確認密碼', pswInput,
                    height: 50,
                    color: MyTheme.color,
                    isHidden: _isHidden,
                    hasHidden: true,
                    hiddenState: _togglePasswordView),
                TextInput.radius('', pswInput,
                    height: 50,
                    color: MyTheme.color,
                    textField: TextField(
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "出生年月日" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          dateinput.text = dateFormat.format(pickedDate);
                        } else {
                          logger.v("Date is not selected");
                        }
                      },
                    )),

                const Padding(padding: EdgeInsets.only(top: 10)),
                TextInput.radius('手機號碼', phoneInput,
                    height: 50, color: MyTheme.color),
                TextInput.radius(
                  "text",
                  sexInput,
                  textField: TextField(
                    decoration: const InputDecoration(labelText: "性別",border: InputBorder.none,),
                    controller: sexInput,
                    readOnly: true,
                    onTap: () {
                      logger.v("on tap sex");
                      _showDialog(
                        CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32,
                          // This sets the initial item.
                          scrollController: FixedExtentScrollController(
                            initialItem: 0,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              sexInput.text = _sexChoice[selectedItem];
                              _selectSex = _sexChoice[selectedItem];
                            });
                          },
                          children: List<Widget>.generate(_sexChoice.length,
                              (int index) {
                            return Center(child: Text(_sexChoice[index]));
                          }),
                        ),
                      );
                    },
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 30)),
                buttonCustom("註冊", () async {
                  final utf = utf8.encode(pswInput.text);
                  final encryptStr =
                      sha256.convert(utf).toString().toUpperCase();
                  // Format a = await userRepo.login(accountInput.text, encryptStr);
                  // if (a.message == "登入成功") {
                  //   prefs = await SharedPreferences.getInstance();
                  //   prefs.setString(Name.userID, accountInput.text);
                  //   if (context.mounted) {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute<void>(
                  //         builder: (BuildContext context) => const MyApp(),
                  //       ),
                  //     );
                  //   } else {
                  //     logger.v("context is not mounted");
                  //   }
                  // } else {
                  //   logger.v("is not login ok");
                  //   logger.v(a);
                  // }
                }),
                const Padding(padding: EdgeInsets.only(top: 30)),

              
              
              ],
            ),
          ),
        ));
  }
}
