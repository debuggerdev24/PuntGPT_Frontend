import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

extension BuildContextExtensions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;
  double get fullScreenWidth => web.window.screen.width.toDouble();
}
