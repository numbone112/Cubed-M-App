import 'dart:convert';

import 'package:e_fu/main.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/user/account.dart';
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';

import 'my_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String account = "";
  String psw = "";
  TextEditingController accountC = TextEditingController();
  TextEditingController pswC = TextEditingController();
  final BorderRadius _borderRadius = const BorderRadius.all(Radius.circular(10));

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
    return (TextButton(
      style: TextButton.styleFrom(
          backgroundColor: MyTheme.color, foregroundColor: Colors.white),
      onPressed: () {
        f.call();
      },
      child: Text(s),
    ));
  }

  var logger = Logger();
  var userRepo = UserRepo();

  @override
  Widget build(BuildContext context) {
    TextField accountField = inputBox(accountC, false, "帳號");

    TextField passwordField = inputBox(pswC, true, '密碼');

    SharedPreferences prefs;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyTheme.backgroudColor,
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                scale: 1,
              ),
              accountField,
              const Padding(padding: EdgeInsets.only(top: 30)),
              passwordField,
              const Padding(padding: EdgeInsets.only(top: 30)),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    child: const Text(
                  "忘記密碼",
                  style: TextStyle(color: Colors.grey),
                )),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              buttonCustom("登入", () async {
                final utf = utf8.encode(pswC.text);
                final encryptStr = sha256.convert(utf).toString().toUpperCase();
                Format a = await userRepo.login(accountC.text, encryptStr);
                if (a.message == "登入成功") {
                  prefs = await SharedPreferences.getInstance();
                  prefs.setString(Name.userName, accountC.text);
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const MyApp(),
                      ),
                    );
                  }
                } else {
                  logger.v(a);
                }
              }),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("還沒註冊帳號嗎?立即"),
                  GestureDetector(
                    child: Text(
                      "註冊",
                      style: TextStyle(color: MyTheme.color),
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              GestureDetector(
                child: const Icon(Icons.g_mobiledata),
              )
              // buttonCustom("Ｇoogle 登入", () => {logger.v("test")}),
            ],
          ),
        )),
      ),
    );
  }
}
