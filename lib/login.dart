import 'dart:convert';

import 'package:e_fu/main.dart';
import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/request/data.dart';
import 'package:e_fu/request/user/account.dart';
import 'package:e_fu/util/user_secure_storage.dart';
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
  var userRepo = UserRepo();
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  onLogin() async {
    final utf = utf8.encode(pswC.text);
    final encryptStr = sha256.convert(utf).toString().toUpperCase();
    Format response = await userRepo.login(accountC.text, encryptStr);
    if (response.message == "登入成功") {
      //儲存方式1
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Name.userID, accountC.text);
      //儲存方式2
      UserSecureStorage.saveLoginData(accountC.text, encryptStr);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const MyApp(),
          ),
        );
      } else {
        logger.v("系統發生錯誤");
      }
    } else {
      logger.v("使用者帳戶或密碼輸入錯誤");
    }
  }

  @override
  Widget build(BuildContext context) {
    // SharedPreferences prefs;
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
                TextInput.radius('帳號', accountC,
                    height: 50, color: MyTheme.color),
                const Padding(padding: EdgeInsets.only(top: 10)),
                TextInput.radius('密碼', pswC,
                    height: 50,
                    color: MyTheme.color,
                    isHidden: _isHidden,
                    hasHidden: true,
                    hiddenState: _togglePasswordView),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: MyTheme.color,
                        width: 1,
                      ))),
                      child: textWidget(
                        text: '忘記密碼',
                        type: TextType.content,
                        color: MyTheme.color,
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                buttonCustom("登入", () => onLogin()),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                      text: '還沒註冊帳號嗎?立即',
                      type: TextType.content,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: MyTheme.color,
                        width: 1,
                      ))),
                      child: textWidget(
                        text: '註冊',
                        type: TextType.content,
                        color: MyTheme.color,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                GestureDetector(
                  child: const Icon(Icons.g_mobiledata),
                )
                // buttonCustom("Ｇoogle 登入", () => {logger.v("test")}),
              ],
            ),
          ),
        ));
  }
}
