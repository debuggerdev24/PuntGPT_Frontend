import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/punter_club_screen.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/dialogue_sheets.dart';
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
      builder: (context, provider, child) => Stack(
        children: [
          Column(
            children: [
              topBar(context: context, provider: provider),
              Expanded(
                child: Stack(
                  children: [
                    ListView(children: [
                      // ChatSection(), ChatSection()
                    ]),
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
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (provider.isLeavingGroup || provider.isUserNameSetupLoading) FullPageIndicator(),
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
          padding: EdgeInsets.fromLTRB(4.w, 10.w, 25.w, 14.w),
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
                      color: AppColors.primary.withValues(alpha: 0.6),
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
                    builder: (sheetContext) {
                      return OptionsSheetView(
                        provider: provider,
                        sheetContext: sheetContext,
                      );
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
  const OptionsSheetView({
    super.key,
    required this.provider,
    required this.sheetContext,
  });
  final PuntClubProvider provider;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    final spacing = (context.isBrowserMobile)
        ? 40.w.verticalSpace
        : 24.w.verticalSpace;
    return SizedBox(
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
            optionItem(
              title: "View Members",
              onTap: () {
                context.pop();
                provider.getGroupMembersList(
                  groupId: provider.chatGroupsList![provider.selectedGroup].id
                      .toString(),
                );
                context.pushNamed(AppRoutes.groupMembersScreen.name);
              },
            ),
            spacing,
            horizontalDivider(),
            spacing,
            optionItem(
              title: "Change Name",
              onTap: () {
                context.pop();
                // final currentCtx = AppRouter.rootNavigatorKey.currentContext;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  showDragHandle: true,
                  backgroundColor: AppColors.white,
                  builder: (sheetContext) {
                    return createUserNameSheet(
                      context: sheetContext,
                      provider: provider,
                      onSubmit: () {
                        sheetContext.pop();

                        provider.userNameSetup(
                          onSuccess: () {
                            final currentCtx =
                                AppRouter.rootNavigatorKey.currentContext;
                            AppToast.success(
                              context: currentCtx!,
                              message: "Name updated successfully",
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            spacing,
            horizontalDivider(),
            Spacer(),
            AppOutlinedButton(
              borderColor: AppColors.red,
              textStyle: semiBold(fontSize: 18.sp, color: AppColors.red),
              text: "Leave Group",
              onTap: () {
                context.pop();
                final cuttentCtx = AppRouter.rootNavigatorKey.currentContext;
                showLeaveGroupConfirmation(
                  context: cuttentCtx!,
                  onLeaveGroup: () {
                    provider.leaveGroup(
                      onSuccess: () {
                        final cuttentCtx =
                            AppRouter.rootNavigatorKey.currentContext;
                        if (cuttentCtx != null && cuttentCtx.mounted) {
                          AppToast.success(
                            context: cuttentCtx,
                            message: "Group left successfully",
                          );
                          cuttentCtx.pop();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget optionItem({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 11.w,
        children: [
          Text(title, style: semiBold(fontSize: 16.sp)),

          Icon(Icons.arrow_forward_ios_rounded, size: 12),
        ],
      ),
    );
  }

  void showLeaveGroupConfirmation({
    required BuildContext context,
    required VoidCallback onLeaveGroup,
  }) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              "Are you sure you want to Quit Group?",
              style: regular(
                color: AppColors.black,
                fontSize: context.isBrowserMobile ? 65.sp : 19.sp,
              ),
            ),
            actions: [
              myActionButtonTheme(
                onPressed: () async {
                  dialogContext.pop();
                  onLeaveGroup.call();
                },
                title: "Yes",
              ),
              myActionButtonTheme(
                onPressed: () {
                  dialogContext.pop();
                },
                title: "Cancel",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget myActionButtonTheme({
    required VoidCallback onPressed,
    required String title,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: regular(
          color: (title == "Yes") ? AppColors.red : AppColors.black,
          fontSize: 16.5,
        ),
      ),
    );
  }
}
