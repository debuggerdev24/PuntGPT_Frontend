import 'package:puntgpt_nick/core/app_imports.dart';

Widget offlineView() {
  return Center(
    child: Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(CupertinoIcons.wifi_slash, color: AppColors.primary, size: 30),
        Text("No Internet Connection!", style: regular(fontSize: 20.sp)),
        // Container(
        //   decoration: BoxDecoration(
        //     color: AppColors.whiteColor,
        //     borderRadius: BorderRadius.circular(5).r,
        //   ),
        //   padding: EdgeInsets.all(12).r,
        //   child: CupertinoActivityIndicator(
        //     radius: 18.h,
        //     color: AppColors.bgColor,
        //   ),
        // ),
      ],
    ),
  );
}
