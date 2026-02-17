import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/chat_section.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../../core/widgets/app_devider.dart';

class AskPuntGptScreen extends StatelessWidget {
  const AskPuntGptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!context.isMobileView) {
      context.pop();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topBar(context),
        Expanded(
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [ChatSection(), ChatSection()],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      horizontalDivider(),
                      TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,

                          prefix: SizedBox(width: 25.w),
                          hintText: "Type your message...",
                          hintStyle: medium(
                            fontStyle: FontStyle.italic,
                            fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
                            color: AppColors.greyColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 12.h, 25.w, 12.h),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,

                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ask @PuntGPT",

                    style: regular(
                      fontFamily: AppFontFamily.secondary,
                      fontSize: context.isBrowserMobile ? 40.sp : 20,
                      height: 1.35,
                      // fontSize: (kIsWeb) ? 38.sp : null,
                    ),
                  ),
                  Text(
                    "Chat with AI",
                    style: medium(
                      fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
                      color: AppColors.greyColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}
