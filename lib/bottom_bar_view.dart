import 'my_data.dart';

import 'package:flutter/material.dart';
import 'module/tab_icon_data.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({Key? key, required this.tabIconsList, this.changeIndex})
      : super(key: key);

  final Function(int index)? changeIndex;
  final List<TabIconData> tabIconsList;
  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController?.forward();
    super.initState();
    setRemoveAllSelection(widget.tabIconsList[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(MySize.circularSize),
                        topRight: Radius.circular(MySize.circularSize)),
                    //设置四周边框
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: SizedBox(
                    height: 62,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                      child: Row(
                        children: 
                        List.generate(widget.tabIconsList.length, (index) {
                           return(Expanded( child: TabIcons(
                                tabIconData: widget.tabIconsList[index],
                                removeAllSelect: () {
                                  setRemoveAllSelection(
                                      widget.tabIconsList[index]);
                                  widget.changeIndex!(index);
                                }),));
                        })
                        // <Widget>[
                          
                        //   Expanded(
                        //     child: Column(
                        //       children: [
                        //         Expanded(
                        //           child: TabIcons(
                        //               tabIconData: widget.tabIconsList?[0],
                        //               removeAllSelect: () {
                        //                 setRemoveAllSelection(
                        //                     widget.tabIconsList?[0]);
                        //                 widget.changeIndex!(0);
                        //               }),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        //   Expanded(
                        //     child: TabIcons(
                        //         tabIconData: widget.tabIconsList?[1],
                        //         removeAllSelect: () {
                        //           setRemoveAllSelection(
                        //               widget.tabIconsList?[1]);
                        //           widget.changeIndex!(1);
                        //         }),
                        //   ),
                        //   Expanded(
                        //     child: TabIcons(
                        //         tabIconData: widget.tabIconsList?[2],
                        //         removeAllSelect: () {
                        //           setRemoveAllSelection(
                        //               widget.tabIconsList?[2]);
                        //           widget.changeIndex!(2);
                        //         }),
                        //   ),
                        //     Expanded(
                        //     child: TabIcons(
                        //         tabIconData: widget.tabIconsList?[3],
                        //         removeAllSelect: () {
                        //           setRemoveAllSelection(
                        //               widget.tabIconsList?[3]);
                        //           widget.changeIndex!(3);
                        //         }),
                        //   ),
                        // ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            );
          },
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (!mounted) return;
    setState(() {
      for (var tab in widget.tabIconsList) {
        tab.isSelected = false;
        if (tabIconData!.index == tab.index) {
          tab.isSelected = true;
        }
      }
    });
  }
}

class TabIcons extends StatefulWidget {
  const TabIcons({Key? key, this.tabIconData, this.removeAllSelect})
      : super(key: key);

  final TabIconData? tabIconData;
  final Function()? removeAllSelect;
  @override
  State<TabIcons> createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData?.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect!();
          widget.tabIconData?.animationController?.reverse();
        }
      });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData?.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData!.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.tabIconData!.animationController!,
                          curve: const Interval(0.1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          widget.tabIconData!.isSelected
                              ? widget.tabIconData!.selectedImagePath
                              : widget.tabIconData!.imagePath,
                          width: MySize.iconSize,
                          height: MySize.iconSize,
                        ),
                      ),
                      Text(widget.tabIconData!.title,
                          style: TextStyle(color: MyTheme.color))
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 6,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.2, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: MyTheme.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6,
                  bottom: 8,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.5, 0.8,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: MyTheme.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.5, 0.6,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: MyTheme.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
