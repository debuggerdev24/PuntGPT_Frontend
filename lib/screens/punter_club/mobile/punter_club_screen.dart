import 'package:badges/badges.dart' as badge;
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/subscription_gate_view.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/create_chat_group_sheet.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/notification_sheet.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/punter_club_shimmers.dart';

class PunterClubScreen extends StatelessWidget {
  const PunterClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        AppRouter.indexedStackNavigationShell?.goBranch(0);
      },
      child: Consumer2<PuntClubProvider, SubscriptionProvider>(
        builder: (context, provider, subProvider, child) {
          if (!subProvider.isSubscribed || isGuest) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _topBar(context: context, provider: provider),
                horizontalDivider(),
                Expanded(
                  child: SubscriptionGateView(
                    featureTitle: "Subscribe to access Punter Club",
                    featureDescription:
                        "Create and join clubs, chat with members, and share tips.",
                    icon: Icons.groups_rounded,
                  ),
                ),
              ],
            );
          }
          if (provider.chatGroupsList == null) {
            return PunterClubShimmers.punterClubScreenShimmer(context: context);
          }

          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //* top bar
                  _topBar(context: context, provider: provider),
                  horizontalDivider(),
                  Expanded(
                    child: (provider.chatGroupsList!.isEmpty)
                        ? _buildEmptyStateCreateFirstGroup(
                            context: context,
                            provider: provider,
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: horizontalDivider(),
                            ),
                            shrinkWrap: true,
                            itemCount: provider.chatGroupsList!.length + 1,
                            padding: EdgeInsets.zero,

                            itemBuilder: (context, index) {
                              if (index == provider.chatGroupsList!.length) {
                                return const SizedBox.shrink();
                              }
                              final chatGroup = provider.chatGroupsList![index];
                              Logger.info('chat group id: ${chatGroup.id}');
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  provider.setSelectedChatGroupIndex = index;
                                  context.pushNamed(
                                    (context.isMobileView && kIsWeb)
                                        ? WebRoutes.punterClubChatScreen.name
                                        : AppRoutes.punterClubChatScreen.name,
                                    extra: chatGroup.name,
                                  );
                                  provider.getChatGroups();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25.w,
                                    vertical: 20.w,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                chatGroup.name,
                                                style: bold(
                                                  fontSize:
                                                      (context.isBrowserMobile)
                                                      ? 32.sp
                                                      : 16.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (chatGroup.unreadMessageCount >
                                                0) ...[
                                              8.w.horizontalSpace,
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                ),
                                                child: Text(
                                                  chatGroup.unreadMessageCount >
                                                          99
                                                      ? "99+"
                                                      : "${chatGroup.unreadMessageCount}",
                                                  style: semiBold(
                                                    fontSize:
                                                        (context
                                                            .isBrowserMobile)
                                                        ? 24.sp
                                                        : 12.sp,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (chatGroup.isAdmin)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.25),
                                            ),
                                          ),
                                          child: Text(
                                            "Admin",
                                            style: semiBold(
                                              fontSize:
                                                  (context.isBrowserMobile)
                                                  ? 22.sp
                                                  : 11.sp,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  horizontalDivider(),
                  // Spacer(),
                ],
              ),
              // Align(
              //   alignment: AlignmentGeometry.bottomRight,
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 25.w,
              //       vertical: 25.h,
              //     ),
              //     child: askPuntGPTButton(context),
              //   ),
              // ),
              if (provider.isCreatingChatGroupLoading ||
                  provider.isInvitingUser)
                FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }

  //* Top bar
  Widget _topBar({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (context.isBrowserMobile) ? 35.w : 25.w,
        vertical: 18.w,
      ),
      child: Row(
        children: [
          ImageWidget(
            path: AppAssets.groupIcon,
            type: ImageType.svg,
            height: (context.isBrowserMobile) ? 42.w : null,
          ),
          (context.isBrowserMobile)
              ? 60.w.horizontalSpace
              : 12.w.horizontalSpace,
          Text(
            "Your Punters Clubs:",
            style: regular(
              fontSize: (context.isBrowserMobile) ? 38.sp : 24.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
          Spacer(),
          //* Notification sheet button
          GestureDetector(
            onTap: () {
              provider.getNotifications();
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                showDragHandle: true,
                backgroundColor: AppColors.white,
                builder: (sheetContext) {
                  return NotificationSheetView(sheetContext: sheetContext);
                },
              );
            },
            behavior: HitTestBehavior.opaque,
            child: badge.Badge(
              showBadge: (provider.notificationCount) > 0,
              position: badge.BadgePosition.topStart(
                top: -10,
                start: context.isBrowserMobile ? 48.w : 20.w,
              ),
              badgeStyle: badge.BadgeStyle(badgeColor: AppColors.black),
              badgeContent: Text(
                provider.notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.isBrowserMobile ? 9 : 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: ImageWidget(
                path: AppAssets.notification,
                type: ImageType.svg,
                height: 28,
                width: 30,
              ),
            ),
          ),
          context.isBrowserMobile ? 14.w.horizontalSpace : 0.horizontalSpace,
          //* Create Punter Club Button
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.white,
                showDragHandle: true,
                useRootNavigator: true,
                builder: (sheetContext) {
                  return CreateChatGroupSheet(provider: provider);
                },
              );
            },
            child: Container(
              color: AppColors.primary,
              height: 28,
              width: 30,
              margin: EdgeInsets.only(left: 12.w),
              child: ImageWidget(
                width: 30.w,
                path: AppAssets.addIcon,
                type: ImageType.svg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCreateFirstGroup({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all((context.isBrowserMobile) ? 32.w : 24.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_circle_outline_rounded,
                size: (context.isBrowserMobile) ? 80.w : 56.w,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            24.h.verticalSpace,
            Text(
              "Create your first chat group",
              style: semiBold(
                fontSize: (context.isBrowserMobile) ? 28.sp : 20.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            12.h.verticalSpace,
            Text(
              "Start a club to chat with friends, share tips and discuss races.",
              style: regular(
                fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            28.h.verticalSpace,
            AppFilledButton(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.white,
                  showDragHandle: true,
                  useRootNavigator: true,
                  builder: (sheetContext) {
                    return CreateChatGroupSheet(provider: provider);
                  },
                );
              },
              text: "Create chat group",
              textStyle: semiBold(
                fontSize: (context.isBrowserMobile) ? 26.sp : 16.sp,
                color: AppColors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
            ),
          ],
        ),
      ),
    );
  }
}
