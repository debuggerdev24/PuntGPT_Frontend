import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewSelector extends StatelessWidget {

  const ViewSelector({super.key, required this.mobile, required this.web});
  final Widget mobile;
  final Widget web;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return web;
    }
    return mobile;
  }
}
