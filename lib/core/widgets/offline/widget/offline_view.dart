import 'package:flutter/foundation.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/offline/mobile_offline_view.dart';

Widget offlineView() {
  if (!kIsWeb) {
    return const MobileOfflineView();
  }
  return Center(
    child: Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(CupertinoIcons.wifi_slash, color: AppColors.primary, size: 30),
        Text("No Internet Connection!", style: regular(fontSize: 20.sp)),
      ],
    ),
  );
}
