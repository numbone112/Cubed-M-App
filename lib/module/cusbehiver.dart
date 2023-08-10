
import 'dart:io';

import 'package:flutter/material.dart';

class CusBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) return child;
    return buildViewportChrome(context, child, axisDirection);
  }
}