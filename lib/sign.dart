import 'dart:convert';

import 'package:e_fu/main.dart';
import 'package:e_fu/request/data.dart';
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';

import 'my_data.dart';
import 'request/user/account.dart';
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

  TextField te(TextEditingController t,bool h) {
    return (TextField(
      obscureText: h,
      controller: t,
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 25 * 4),
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          ///设置边框四个角的弧度
          borderRadius: BorderRadius.all(Radius.circular(10)),

          ///用来配置边框的样式
          borderSide: BorderSide(
            ///设置边框的颜色
            color: Color.fromRGBO(10, 112, 41, 1),

            ///设置边框的粗细
            width: 2.0,
          ),
        ),

        ///设置输入框可编辑时的边框样式
        enabledBorder: OutlineInputBorder(
          ///设置边框四个角的弧度
          borderRadius: BorderRadius.all(Radius.circular(10)),

          ///用来配置边框的样式
          borderSide: BorderSide(
            ///设置边框的颜色
            color: Color.fromRGBO(10, 112, 41, 1),

            ///设置边框的粗细
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          ///设置边框四个角的弧度
          borderRadius: BorderRadius.all(Radius.circular(10)),

          ///用来配置边框的样式
          borderSide: BorderSide(
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
          backgroundColor: const Color.fromRGBO(10, 112, 41, 1),
          foregroundColor: Colors.white),
      onPressed: () {
        f.call();
      },
      child: Text(s),
    ));
  }

  var logger = Logger();
  var accountRepo = AccountRepo();

  @override
  Widget build(BuildContext context) {
    TextField accountField = te(accountC,false);

    TextField passwordField = te(pswC,true);

    SharedPreferences prefs;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyTheme.backgroudColor,
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [Icon(Icons.people), Text("帳號")],
              ),
              accountField,
              Row(
                children: [Icon(Icons.password), Text("密碼")],
              ),
              passwordField,
              buttonCustom("登入", () async {
                logger.v("login button");
                final utf = utf8.encode(pswC.text);
                final digest = sha256.convert(utf);
                final encryptStr = digest.toString().toUpperCase();
                logger.v("encryptStr $encryptStr");
                logger.v("digest $digest");

                Format a = await accountRepo.login(accountC.text,encryptStr);
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
              buttonCustom("Ｇoogle 登入", () => {logger.v("test")}),
            ],
          ),
        )),
      ),
    );
  }
}
