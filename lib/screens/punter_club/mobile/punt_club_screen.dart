import 'package:badges/badges.dart' as badge;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/core/router/web/web_routes.dart';
import 'package:puntgpt_nick/core/utils/app_toast.dart';
import 'package:puntgpt_nick/core/utils/custom_loader.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/core/widgets/app_outlined_button.dart';
import 'package:puntgpt_nick/core/widgets/image_widget.dart';
import 'package:puntgpt_nick/models/punt_club/notification_model.dart';
import 'package:puntgpt_nick/models/punt_club/user_invites_list.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/punter_club_shimmers.dart';

import '../../../core/widgets/app_filed_button.dart';
import '../../../core/widgets/app_text_field.dart';

class PunterClubScreen extends StatelessWidget {
  const PunterClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PuntClubProvider>(
      builder: (context, provider, child) {
        if (provider.chatGroupsList == null) {
          return PunterClubShimmers.punterClubScreenShimmer(context: context);
        }
        if (provider.chatGroupsList!.isEmpty) {
          return Center(child: Text("No chat groups found"));
        }
        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //* top bar
                topBar(context: context, provider: provider),
                horizontalDivider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.chatGroupsList!.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final chatGroup = provider.chatGroupsList![index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        provider.selectedGroup = index;
                        context.pushNamed(
                          (context.isMobileView && kIsWeb)
                              ? WebRoutes.punterClubChatScreen.name
                              : AppRoutes.punterClubChatScreen.name,
                          extra: chatGroup.name,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: (index % 2 == 0) ? null : AppColors.primary,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.w,
                          vertical: 20.h,
                        ),

                        child: Text(
                          chatGroup.name,
                          style: bold(
                            fontSize: (context.isBrowserMobile) ? 32.sp : 16.sp,
                            color: (index % 2 == 0) ? null : AppColors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                horizontalDivider(),
                Spacer(),
                Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 25.h,
                    ),
                    child: askPuntGPTButton(context),
                  ),
                ),
              ],
            ),

            if (provider.isCreatingChatGroupLoading) FullPageIndicator(),
          ],
        );
      },
    );
  }

  //* Top bar
  Widget topBar({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (context.isBrowserMobile) ? 35.w : 25.w,
        vertical: 22.w,
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
              provider.getNotificationList();
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                showDragHandle: true,
                backgroundColor: AppColors.white,
                builder: (sheetContext) {
                  return const NotificationSheetView();
                },
              );
            },
            behavior: HitTestBehavior.opaque,
            child: badge.Badge(
              position: badge.BadgePosition.topStart(
                top: -10,
                start: context.isBrowserMobile ? 48.w : 20.w,
              ),
              badgeStyle: badge.BadgeStyle(badgeColor: AppColors.black),
              badgeContent: Text(
                '5',
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
                  return createChatGroupSheet(provider, sheetContext, context);
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

  Widget createChatGroupSheet(
    PuntClubProvider provider,
    BuildContext sheetContext,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: Container(
        height: 310.h,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            Text(
              "Create Punter Club",
              style: regular(
                fontSize: 24.sp,
                fontFamily: AppFontFamily.secondary,
              ),
            ),
            16.h.verticalSpace,
            horizontalDivider(),
            24.h.verticalSpace,
            AppTextField(
              controller: provider.clubNameCtr,
              hintText: "Enter Club Name",
            ),
            AppFilledButton(
              margin: EdgeInsets.only(top: 24.h),
              text: "Invite Users",
              onTap: () {
                sheetContext.pop();
                if (provider.clubNameCtr.text.trim().isEmpty) {
                  AppToast.error(
                    context: context,
                    message: "Please enter club name",
                  );
                  return;
                }
                //* Create chat group
                provider.createChatGroup(
                  onSuccess: () {
                    AppToast.success(
                      context: context,
                      message: "Chat group created successfully",
                    );
                    // if(provider.) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      useRootNavigator: true,
                      backgroundColor: AppColors.white,
                      builder: (_) {
                        return InviteUserSheet(showInviteLater: true);
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
}

class InviteUserSheet extends StatelessWidget {
  const InviteUserSheet({super.key, this.showInviteLater = false});
  final bool? showInviteLater;

  @override
  Widget build(BuildContext context) {
    return Consumer<PuntClubProvider>(
      builder: (context, provider, child) {
        //* Show shimmer while user list is loading (userInvitesList not yet set)
        if (provider.userInvitesList == null) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SizedBox(
              height: context.screenHeight - 0.15.sh,
              child: PunterClubShimmers.inviteUserSheetShimmer(
                context: context,
              ),
            ),
          );
        }
        if (provider.userInvitesList!.isEmpty) {
          return const Center(child: Text("No users to invite"));
        }

        final list = provider.userInvitesList!;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SizedBox(
            height: context.screenHeight - 0.15.sh,
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.w, 5, 25.w, 25.w),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Text(
                        "Invite Users",
                        style: regular(
                          fontSize: 24.twentyFourSp(context),
                          fontFamily: AppFontFamily.secondary,
                        ),
                      ),
                      20.h.verticalSpace,
                      horizontalDivider(),
                      20.h.verticalSpace,
                      AppTextField(
                        controller: provider.searchNameCtr,
                        hintText: "Search by username",
                        trailingIcon: AppAssets.searchIcon,
                      ),
                      8.w.verticalSpace,
                      Expanded(
                        child: list.isEmpty
                            ? const Center(child: Text("No users to invite"))
                            : ListView.builder(
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return userBox(
                                    context: context,
                                    user: list[index],
                                  );
                                },
                              ),
                      ),
                      if (showInviteLater == true)
                        AppOutlinedButton(
                          margin: EdgeInsets.only(top: 8.w),
                          text: "Invite Later",
                          onTap: () {
                            context.pop();
                          },
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18.eighteenSp(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget userBox({
    required BuildContext context,
    required UserInvitesList user,
  }) {
    final height = (context.isBrowserMobile) ? 96.w : 48.w;
    final width = (context.isBrowserMobile) ? 68.w : 48.w;
    return Container(
      margin: EdgeInsets.only(top: 8.w),
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            height: height,
            width: width,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: AppColors.greyColor2),
            child: ImageWidget(type: ImageType.svg, path: AppAssets.userIcon),
          ),
          (context.isBrowserMobile)
              ? 80.w.horizontalSpace
              : 15.w.horizontalSpace,
          Text(user.name, style: semiBold(fontSize: 16.sixteenSp(context))),
          Spacer(),
          Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.w),
            decoration: BoxDecoration(color: AppColors.primary),
            child: ImageWidget(
              path: AppAssets.addMember,
              type: ImageType.asset,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

//* Notification sheet view
class NotificationSheetView extends StatelessWidget {
  const NotificationSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PuntClubProvider>(
      builder: (context, provider, _) {
        final notifications = provider.notificationList;

        if (notifications == null) {
          return PunterClubShimmers.notificationSheetShimmer(context: context);
        }
        if (notifications.isEmpty) {
          return const Center(
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none_outlined, size: 24),
                Text("No notifications found!"),
              ],
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
              16.h.verticalSpace,
              horizontalDivider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      19.h.verticalSpace,
                      for (final n in notifications)
                        notificationBox(context: context, notification: n),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: AppOutlinedButton(
                  borderColor: AppColors.redButton,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  textStyle: semiBold(
                    fontSize: 16.sp,
                    color: AppColors.redButton,
                  ),
                  text: "Clear all",
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget notificationBox({
    required BuildContext context,
    required NotificationModel notification,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ImageWidget(type: ImageType.svg, path: AppAssets.groupIcon),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "You’ve been invited to join Punter Club",
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

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppFilledButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 9.h,
                      ),
                      isExpand: false,
                      text: "Join",
                      textStyle: semiBold(
                        fontSize: 14.sp,
                        color: AppColors.white,
                      ),
                      onTap: () {
                        context.pop();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.white,
                          showDragHandle: true,
                          useRootNavigator: true,
                          builder: (sheetContext) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.viewInsetsOf(
                                  sheetContext,
                                ).bottom,
                              ),
                              child: Container(
                                height: 370.h,
                                padding: EdgeInsets.symmetric(horizontal: 25.w),
                                child: Column(
                                  children: [
                                    Text(
                                      "Create Username",
                                      style: regular(
                                        fontSize: 24.sp,
                                        fontFamily: AppFontFamily.secondary,
                                      ),
                                    ),
                                    10.h.verticalSpace,
                                    Text(
                                      "Your username will be displayed to your club members.",
                                      style: semiBold(
                                        fontSize: 14.sp,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    22.w.verticalSpace,
                                    horizontalDivider(),
                                    24.w.verticalSpace,
                                    AppTextField(
                                      controller: TextEditingController(),
                                      hintText: "Enter username",
                                    ),
                                    AppFilledButton(
                                      margin: EdgeInsets.only(top: 24.w),
                                      text: "Save",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    AppOutlinedButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 8.h,
                      ),
                      isExpand: false,
                      textStyle: semiBold(
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),

                      text: "Decline",
                      onTap: () {},
                      margin: EdgeInsets.only(left: 10.w),
                    ),
                    Spacer(),
                    Icon(Icons.close_rounded, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
