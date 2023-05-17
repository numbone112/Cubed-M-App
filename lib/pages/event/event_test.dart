
import 'package:e_fu/module/box_ui.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

List<Widget> timelineBox() {
  List<int> data = [0, 1, 2];
  return List.generate(
    data.length,
    (index) => BoxUI.boxHasRadius(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(25),
      child: TimelineTile(
        // hasIndicator: false,
        alignment: TimelineAlign.start,
        isFirst: index == 0,
        isLast: index == (data.length - 1),
        endChild: const Text("end"),
      ),
    ),
  );
}
