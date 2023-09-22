import 'package:e_fu/module/box_ui.dart';
import 'package:e_fu/module/page.dart';
import 'package:e_fu/my_data.dart';
import 'package:e_fu/request/invite/invite_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SingleEvent extends StatefulWidget {
  static const routeName = 'single/event';

  const SingleEvent({super.key, required this.userName});
  final String userName;

  @override
  State<StatefulWidget> createState() => SingleEventState();
}

class SingleEventState extends State<SingleEvent> {
  var logger = Logger();
  bool isHost = true;
  bool ready = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// Positioned BuildCircleIndicator() {
//   return Positioned(
//     //底部对齐
//     bottom: 0.0, left: 0.0,right: 0.0,
//     child: new Container(
//       color: Colors.yellow,
//       padding: const EdgeInsets.all(20.0),
//       child: new Center(
//         //自定义的圆点切换指示器
//         child: buildCircleIndicator(),
//       ),
//     ),
//   );
// }

  // PageView BuildPageView() {
  //   return PageView.builder(
  //     //设置滑动模式
  //     physics: new AlwaysScrollableScrollPhysics(),
  //     //控制器
  //     controller: _pageController2,
  //     //构建每一屏的视图 UI 显示的效果
  //     itemBuilder: (BuildContext context, int index) {
  //       return buildItemWidget(index);
  //     },
  //     //PageView item 个数
  //     itemCount: spll.length,
  //   );
  // }

  // Widget buildItemWidget(int index) {
  //   return new ConstrainedBox(
  //     constraints: const BoxConstraints.expand(),

  //     ///网络图片
  //     child: Image.network(
  //       ///图片地址
  //       spll[index],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final invite =ModalRoute.of(context)!.settings.arguments as Invite;
    Invite invite = Invite(
        name: "name",
        time: DateTime.now().toIso8601String(),
        m_id: "m_id",
        remark: "remark",
        );
    return (CustomPage(
      width: MediaQuery.of(context).size.width * 0.8,
      body: Column(children: [
        Box.connect(context),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          child: ListView(
            children: [
              //         Stack(
              //   children: <Widget>[
              //     //底层显示的PageView
              //     BuildPageView(),
              //     //表层的圆点指示器
              //     BuildCircleIndicator(),
              //   ],
              // ),
            ],
          ),
        ),
        Box.boxHasRadius(
          
          child: ExpansionTile(
            collapsedShape: Border.all(color: MyTheme.backgroudColor),
            
            title: Text("運動分級表"),
            children: [Text("運動分級表詳細資料")],
          ),
        )
      ]),
      title: "肌力測試",
      buildContext: context,
    ));
  }
}
