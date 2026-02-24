import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/router/app/app_router.dart';
import 'package:puntgpt_nick/core/utils/custom_loader.dart';
import 'package:puntgpt_nick/core/widgets/image_widget.dart';
import 'package:puntgpt_nick/core/widgets/on_button_tap.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/punter_club_screen.dart';
import '../../../core/constants/text_style.dart';
import '../../../core/widgets/app_devider.dart';
import '../../home/search_engine/mobile/widgets/chat_section.dart';

class PuntClubChatScreen extends StatelessWidget {
  const PuntClubChatScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    if (!context.isMobileView) {
      context.pop();
    }
    return Consumer<PuntClubProvider>(
      builder: (context, provider, child) => Column(
        children: [
          topBar(context: context, provider: provider),
          Expanded(
            child: Stack(
              children: [
                ListView(children: [ChatSection(), ChatSection()]),
                Padding(
                  padding: EdgeInsets.only(bottom: 25.h, right: 25.w),
                  child: Align(
                    alignment: AlignmentGeometry.bottomRight,
                    child: (context.isBrowserMobile)
                        ? askPuntGPTButtonWeb(context: context)
                        : askPuntGPTButton(context),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              horizontalDivider(),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefix: SizedBox(
                    width: (context.isBrowserMobile) ? 35.w : 25.w,
                  ),
                  hintText: "Type your message...",
                  hintStyle: medium(
                    fontStyle: FontStyle.italic,
                    fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
                    color: AppColors.greyColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget topBar({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 12.h, 25.w, 16.h),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 16.h.flexClamp(16, 24),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      //* getting current location
                      // final ctx = AppRouter.rootNavigatorKey.currentContext;
                      // if (ctx != null) {
                      //   final router = GoRouter.of(ctx);
                      //   final location = router.state.name; // path
                      //   Logger.info('Current route location: $location');
                      // }
                      provider.getUsersInviteList(groupId: provider.groupId);
                    },
                    child: Text(
                      title,
                      style: regular(
                        fontSize: (context.isBrowserMobile) ? 50.sp : 24.sp,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                  Text(
                    "11 Member",
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                      color: AppColors.greyColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              Spacer(),

              OnMouseTap(
                onTap: () {
                  final grp = provider.chatGroupsList![provider.selectedGroup];
                  provider.getUsersInviteList(
                    groupId: grp.id.toString(),
                    // grpName: grp.name,
                  );
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    showDragHandle: true,
                    backgroundColor: AppColors.white,
                    builder: (context) {
                      return InviteUserSheet();
                    },
                  );
                },
                child: ImageWidget(
                  width: (context.isBrowserMobile) ? 60.w : 28.w,
                  path: AppAssets.addClubMember,
                  type: ImageType.svg,
                  color: AppColors.primary,
                ),
              ),
              (context.isBrowserMobile)
                  ? 40.w.horizontalSpace
                  : 20.w.horizontalSpace,
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    showDragHandle: true,
                    backgroundColor: AppColors.white,
                    builder: (context) {
                      return OptionsSheetView();
                    },
                  );
                },
                child: ImageWidget(
                  width: (context.isBrowserMobile) ? 60.w : 28.w,
                  path: AppAssets.option,
                  type: ImageType.svg,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}

class OptionsSheetView extends StatelessWidget {
  const OptionsSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = (context.isBrowserMobile)
        ? 40.w.verticalSpace
        : 24.w.verticalSpace;
    return SizedBox(
      // height:0.89.sh,
      height: context.screenHeight - 0.15.sh,
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 25.h),
        child: Column(
          children: [
            Text(
              "Option",
              style: regular(
                fontSize: 24.twentyFourSp(context),
                fontFamily: AppFontFamily.secondary,
              ),
            ),
            18.h.verticalSpace,
            horizontalDivider(),
            spacing,
            optionItem(title: "View Members", context: context),
            spacing,
            horizontalDivider(),
            spacing,
            optionItem(title: "Change Name", context: context),
            spacing,
            horizontalDivider(),
          ],
        ),
      ),
    );
  }

  Widget optionItem({required String title, required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 11.w,
      children: [
        Text(title, style: semiBold(fontSize: 16.sixteenSp(context))),

        Icon(Icons.arrow_forward_ios_rounded, size: 12),
      ],
    );
  }
}
