
import 'package:e_fu/module/box_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'my_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePsw extends StatefulWidget {
  static const routeName = '/change/psw';
  final String userID;

  const UpdatePsw({super.key, required this.userID});

  @override
  State<UpdatePsw> createState() => _UpdatePswState();
}

class _UpdatePswState extends State<UpdatePsw> {
  String account = "";
  String psw = "";
  // TextEditingController accountInput = TextEditingController();
  TextEditingController pswInput = TextEditingController();
  TextEditingController confirmPswInput = TextEditingController();
  
  

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
              

                const Padding(padding: EdgeInsets.only(top: 10)),
                TextInput.radius('舊密碼', pswInput,
                    height: 50,
                    color: MyTheme.color,
                    isHidden: _isHidden,
                    hasHidden: true,
                    hiddenState: _togglePasswordView),
                 TextInput.radius('新密碼', pswInput,
                    height: 50,
                    color: MyTheme.color,
                    isHidden: _isHidden,
                    hasHidden: true,
                    hiddenState: _togglePasswordView),
                TextInput.radius('確認新密碼', pswInput,
                    height: 50,
                    color: MyTheme.color,
                    isHidden: _isHidden,
                    hasHidden: true,
                    hiddenState: _togglePasswordView),
                    Box.yesnoBox(context,() => null, () => null)
               
                

              

              
              
              ],
            ),
          ),
        ));
  }
}
