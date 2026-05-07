import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/models/punt_club/notification_model.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/dialogue_sheets.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/punter_club_shimmers.dart';


//* Notification sheet view
class NotificationSheetView extends StatelessWidget {
  const NotificationSheetView({super.key, required this.sheetContext});
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return _GuestNotificationView(sheetContext: sheetContext);
    }
    return Consumer<PuntClubProvider>(
      builder: (context, provider, _) {
        final notifications = provider.notificationList;
        if (notifications == null) {

          return PunterClubShimmers.notificationSheetShimmer(context: context);
        }
        if (notifications.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 48.h),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    size: context.isMobileWeb ? 64.w : 48.w,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  16.h.verticalSpace,
                  Text(
                    "No notifications found!",
                    style: medium(
                      fontSize: context.isMobileWeb ? 28.sp : 16.sp,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              Text(
                "Notifications",
                style: regular(
                  fontSize: 24.sp,
                  fontFamily: AppFontFamily.secondary,
                ),
              ),
              16.w.verticalSpace,
              horizontalDivider(),
              18.w.verticalSpace,
              Expanded(
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    Logger.info('notification id: ${notification.inviteId}');

                    return _notificationBox(
                      context: context,
                      notification: notification,
                      onReject: () {
                        final rootNav = Navigator.of(
                          context,
                          rootNavigator: true,
                        );
                        provider.rejectInvitation(
                          rejectId: notification.inviteId!,
                          onSuccess: () {
                            AppToast.success(
                              context: rootNav.context,
                              message: "Invitation declined successfully",
                            );
                          },
                        );
                      },
                      onAccept: () {
                       final rootNav = Navigator.of(
                          context,
                          rootNavigator: true,
                        );
                        rootNav.pop();

                        provider.acceptInvitation(
                          inviteId: notification.inviteId!,
                          onFailed: (error) {
                            AppToast.info(
                              context: rootNav.context,
                              message: error,
                            );
                          },
                          onSuccess: () {
                          AppToast.success(
                              context: rootNav.context,
                              message:
                                  "Invite accepted. Please create a username.",
                            );
                            showModalBottomSheet(
                              context: rootNav.context,
                              isScrollControlled: true,
                              enableDrag: false,
                              backgroundColor: AppColors.white,
                              showDragHandle: true,
                              useRootNavigator: true,
                              builder: (sheetContext) {
                                return CreateUserNameSheet(
                                  
                                  provider: provider,
                                  onSubmit: () {
                                    sheetContext.pop();
                                    provider.userNameSetup(
                                      onSuccess: () {
                                        
                                        AppToast.success(
                                          context: rootNav.context,
                                          message:
                                              "Username created successfully",
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      onDelete: () {
                        final rootNav = Navigator.of(
                          context,
                          rootNavigator: true,
                        );
                        provider.removeNotificationAt(index);
                        AppToast.success(
                          context: rootNav.context,
                          message: "Removed successfully",
                          duration: const Duration(seconds: 2),
                        );
                        provider.deleteSingleNotification(
                          notificationId: notification.id.toString(),
                          onSuccess: () {},
                        );
                      },
                    );
                  },
                ),
              ),
              SafeArea(
                child: AppOutlinedButton(
                  borderColor: AppColors.redButton,
                  margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 15.w),
                  textStyle: semiBold(
                    fontSize: 16.sp,
                    color: AppColors.redButton,
                  ),
                  text: "Clear all",
                  onTap: () {
                    provider.clearNotificationList();
                    provider.deleteAllNotification();
                    // AppToast.success(
                    //   context: context,
                    //   message: "All notifications deleted successfully",
                    // );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationBox({
    required BuildContext context,
    required NotificationModel notification,
    required VoidCallback onReject,
    required VoidCallback onAccept,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Slidable(
        key: ValueKey(notification.id),
        endActionPane: ActionPane(
          motion: BehindMotion(),
          extentRatio: 0.28,
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppColors.redButton,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ImageWidget(
                  type: ImageType.svg,
                  path: AppAssets.groupIcon,
                ),
              ),
              10.w.horizontalSpace,
              Expanded(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: notification.message,
                            style: medium(
                              fontSize: 16.sp,
                              fontFamily: AppFontFamily.primary,
                            ),
                          ),
                          TextSpan(
                            text: "PuntGPT Legends",
                            style: semiBold(
                              fontSize: 16.sp,
                              fontFamily: AppFontFamily.primary,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormatter.formatWithTime(
                        DateTime.parse(notification.createdAt).toLocal(),
                      ),
                      style: regular(
                        fontSize: 12.sp,
                        fontFamily: AppFontFamily.primary,
                      ),
                    ),
                    if (notification.inviteId != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppFilledButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 28.w,
                              vertical: 8.w,
                            ),
                            isExpand: false,
                            text: "Join",
                            textStyle: semiBold(
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                            onTap: onAccept,
                          ),
                          AppOutlinedButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 28.w,
                              vertical: 8.w,
                            ),
                            isExpand: false,
                            textStyle: semiBold(
                              fontSize: 14.sp,
                              color: AppColors.black,
                            ),
                            text: "Decline",
                            onTap: onReject,
                            margin: EdgeInsets.only(left: 10.w),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestNotificationView extends StatelessWidget {
  const _GuestNotificationView({required this.sheetContext});
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: ImageWidget(
              type: ImageType.svg,
              path: AppAssets.groupIcon,
              width: 40.w,
            ),
          ),
          24.w.verticalSpace,
          Text(
            "Unlock your notifications",
            style: semiBold(
              fontSize: 20.sp,
              fontFamily: AppFontFamily.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          12.w.verticalSpace,
          Text(
            AppStrings.guestNotificationsMessage,
            style: regular(
              fontSize: 15.sp,
              color: AppColors.primary.withValues(alpha: 0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          32.w.verticalSpace,
          AppFilledButton(
            text: "Subscribe to Pro",
            onTap: () {
              sheetContext.pop();
              context.pushNamed(
                kIsWeb ? WebRoutes.manageSubscriptionScreen.name : AppRoutes.manageSubscriptionScreen.name,
              );
            },
          ),
          // 16.w.verticalSpace,
          // OnMouseTap(
          //   onTap: () {
          //     sheetContext.pop();
          //     context.pushNamed(
          //       kIsWeb ? WebRoutes.logInScreen.name : AppRoutes.loginScreen.name,
          //     );
          //   },
          //   child: Text(
          //     "Already have an account? Sign in",
          //     style: medium(
          //       fontSize: 14.sp,
          //       color: AppColors.primary,
          //       decoration: TextDecoration.underline,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}