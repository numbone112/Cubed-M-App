// import 'package:e_fu/module/box_ui.dart';
// import 'package:e_fu/module/page.dart';
// import 'package:e_fu/my_data.dart';

// import 'package:e_fu/pages/profile/profile_update.dart';
// import 'package:e_fu/request/user/get_user_data.dart';
// import 'package:flutter/material.dart';

// class ProfileGoal extends StatefulWidget {
//   static const routeName = '/profile/goal';
//   final String userName;
//   const ProfileGoal({super.key, required this.userName});

//   @override
//   ProfileGoalState createState() => ProfileGoalState();
// }

// class ProfileGoalState extends State<ProfileGoal> {
//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)!.settings.arguments as GetUser;

//     return CustomPage(
//       body: ListView(children: [
//         // Box.twoinfo("運動目標", args),
//         Box.twoinfo("運動組數", args.sport_info.target_sets.toString()),
       
//         Box.twoinfo("", "", widget: [
//           GestureDetector(
//             child: const Text("編輯運動目標",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             onTap: () => Navigator.pushNamed(context, ProfileUpdate.routeName,
//                ),
//           )
//         ]),
//       ]),
//       title: "管理運動目標",
//       headColor: MyTheme.lightColor,
//       prevColor: Colors.white,
//       headTextColor: Colors.white,
//       buildContext: context,
//     );
//   }
// }
