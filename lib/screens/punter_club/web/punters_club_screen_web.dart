import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:badges/badges.dart' as badges;
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/subscription_gate_view_web.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/models/punt_club/notification_model.dart';
import 'package:puntgpt_nick/models/punt_club/user_invites_list.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/web/widgets/club_chat_screen_web.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import '../../home/search_engine/web/home_screen_web.dart';

class PunterClubScreenWebScreen extends StatelessWidget {
  const PunterClubScreenWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyWidth = context.isMobileWeb
        ? double.maxFinite
        : context.isTablet
        ? double.maxFinite
        : 1040.w;
    // final twentyResponsive = context.isDesktop
    //     ? 20.sp
    //     : context.isTablet
    //     ? 28.sp
    //     : context.isBrowserMobile
    //     ? 36.sp
    //     : 20.sp;

    // final fourteenResponsive = context.isDesktop
    //     ? 14.sp
    //     : context.isTablet
    //     ? 20.sp
    //     : context.isBrowserMobile
    //     ? 28.sp
    //     : 14.sp;
    // final sixteenResponsive = context.isDesktop
    //     ? 16.sp
    //     : context.isTablet
    //     ? 24.sp
    //     : (context.isBrowserMobile)
    //     ? 32.sp
    //     : 16.sp;
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: bodyWidth,
            child: Consumer2<PuntClubProvider, SubscriptionProvider>(
              builder: (context, provider, subProvider, child) {
                if (!subProvider.isSubscribed) {
                  return SubscriptionGateViewWeb(
                    featureTitle: "Subscribe to access Punter Club",
                    featureDescription:
                        "Create and join clubs, chat with members, and share tips.",
                    icon: Icons.groups_rounded,
                    subscribeButtonWidth: 380,
                  );
                }
                return Row(
                  children: [
                    //* ---------------> left panel
                    verticalDivider(),
                    SizedBox(
                      width: context.isDesktop ? 222 : 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* title
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.isDesktop ? 16 : 12,
                              vertical: context.isDesktop ? 16 : 12,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Club Chat",
                                  style: regular(
                                    fontSize: 16,
                                    fontFamily: AppFontFamily.secondary,
                                  ),
                                ),
                                Spacer(),
                                OnMouseTap(
                                  onTap: () {
                                    if (isGuest) {
                                      AppToast.info(
                                        context: context,
                                        message: AppStrings
                                            .guestNotificationsMessage,
                                      );
                                      return;
                                    }
                                    provider.getNotifications();
                                    if (context.isMobileView) {
                                      context.pushNamed(
                                        WebRoutes.askPuntGptScreen.name,
                                      );
                                      return;
                                    }
                                    isSheetOpen = true;
                                    showModalSideSheet(
                                      context: context,
                                      useRootNavigator: false,
                                      width: 450,

                                      // context.isDesktop
                                      //     ? 530.w
                                      //     : 590.w,
                                      withCloseControll: true,
                                      body: _notificationSideSheet(
                                        context: context,
                                        provider: provider,
                                        // sixteenResponsive: sixteenResponsive,
                                        // fourteenResponsive:
                                        //     fourteenResponsive,
                                      ),
                                    );
                                  },
                                  child: badges.Badge(
                                    showBadge:
                                        !isGuest &&
                                        (provider.notificationCount > 0),
                                    position: badges.BadgePosition.topEnd(
                                      top: -11,
                                      end: -6,
                                    ),
                                    badgeStyle: const badges.BadgeStyle(
                                      badgeColor: AppColors.primary,
                                      padding: EdgeInsets.all(5),
                                    ),
                                    badgeContent: Text(
                                      provider.notificationCount > 99
                                          ? '99+'
                                          : provider.notificationCount
                                                .toString(),
                                      style: semiBold(
                                        fontSize: 9,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    child: ImageWidget(
                                      path: AppAssets.notification,
                                      type: ImageType.svg,
                                      height: 22,
                                    ),
                                  ),
                                ),
                                OnMouseTap(
                                  onTap: () {
                                    provider.getUsersInviteList(
                                      groupId: provider.groupId,
                                    );
                                    _inviteUserDialogue(
                                      context: context,
                                      provider: provider,
                                    );

                                    // _createClubDialogue(
                                    //   context: context,
                                    //   provider: provider,
                                    // );
                                  },
                                  child: Container(
                                    color: AppColors.primary,
                                    height: 21,
                                    width: 23,
                                    margin: EdgeInsets.only(left: 12.w),
                                    child: ImageWidget(
                                      path: AppAssets.addIcon,
                                      type: ImageType.svg,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                          horizontalDivider(),

                          //*---------------> chat tabs
                          if (provider.chatGroupsList == null)
                            Expanded(child: LoadingIndicator())
                          else ...[
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final chatGroup =
                                      provider.chatGroupsList![index];
                                  return _chatTabs(
                                    title: chatGroup.name,
                                    onTap: () {
                                      provider.setSelectedChatGroupIndex =
                                          index;
                                    },
                                    context: context,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return horizontalDivider();
                                },
                                addRepaintBoundaries: true,
                                itemCount: provider.chatGroupsList!.length,
                              ),
                            ),
                            horizontalDivider(),
                          ],
                        ],
                      ),
                    ),
                    verticalDivider(),
                    //* ----------------> right panel
                    PunterClubChatSectionWeb(),
                    verticalDivider(),
                  ],
                );
              },
            ),
          ),
        ),
        Align(
          alignment: AlignmentGeometry.bottomRight,
          child: askPuntGPTButtonWeb(context: context),
        ),
      ],
    );
  }

  Widget _chatTabs({
    required String title,
    // required double fourteenResponsive,
    Color? color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return OnMouseTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(color: color),
        padding: EdgeInsets.symmetric(
          horizontal: context.isDesktop ? 24.w : 30.w,
          vertical: context.isDesktop ? 16.w : 22.w,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: bold(
                fontSize: 12, //fourteenResponsive,
                color: color == AppColors.primary ? AppColors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //* create club dialogue
  void _createClubDialogue({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    showDialog(
      context: context,

      builder: (dialogueCtx) {
        final fieldWidth = context.isDesktop ? 344.0 : 390.0;
        final isSubscribed = dialogueCtx
            .read<SubscriptionProvider>()
            .isSubscribed;
        return ZoomIn(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: AppColors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* -----------------> top bar of popup
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.isDesktop ? 24 : 30,
                    vertical: context.isDesktop ? 18 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              "Create Punters Club",
                              style: regular(
                                fontSize: 22,
                                fontFamily: AppFontFamily.secondary,
                              ),
                            ),
                          ),
                          OnMouseTap(
                            onTap: () {
                              context.pop();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                horizontalDivider(),
                //* -----------------> content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 22),
                      if (isGuest || !isSubscribed) ...[
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.06),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.12),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(
                                Icons.groups_rounded,
                                size: 34,
                                color: AppColors.primary.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isGuest
                                    ? AppStrings.guestCreateChatGroupMessage
                                    : AppStrings.nonSubscribedCreateClubMessage,
                                style: regular(
                                  fontSize: 14,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.75,
                                  ),
                                  height: 1.35,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppFilledButton(
                          width: fieldWidth,
                          text: "Subscribe to Pro",
                          margin: EdgeInsets.only(bottom: 24.w),
                          textStyle: semiBold(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                          onTap: () {
                            dialogueCtx.pop();
                            context.pushNamed(
                              WebRoutes.manageSubscriptionScreen.name,
                            );
                          },
                        ),
                      ] else ...[
                        SizedBox(
                          width: fieldWidth,
                          child: AppTextField(
                            controller: provider.clubNameCtr,
                            hintText: "Enter Club Name",
                            textInputAction: TextInputAction.done,
                            onSubmit: () => _handleCreateClub(
                              context: context,
                              dialogueCtx: dialogueCtx,
                              provider: provider,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Consumer<PuntClubProvider>(
                          builder: (context, p, child) {
                            return AppFilledButton(
                              width: fieldWidth,
                              text: "Create Club",
                              margin: EdgeInsets.only(bottom: 24.w),
                              textStyle: semiBold(
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                              onTap: () {
                                _handleCreateClub(
                                  context: context,
                                  dialogueCtx: dialogueCtx,
                                  provider: p,
                                );
                              },
                              child: p.isCreatingChatGroupLoading
                                  ? progressIndicator()
                                  : null,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleCreateClub({
    required BuildContext context,
    required BuildContext dialogueCtx,
    required PuntClubProvider provider,
  }) {
    final currentCtx = AppRouter.rootNavigatorKey.currentContext ?? context;
    final name = provider.clubNameCtr.text.trim();
    if (name.isEmpty) {
      AppToast.error(context: currentCtx, message: "Please enter club name");
      return;
    }

    provider.createChatGroup(
      onError: (error) {
        AppToast.error(context: currentCtx, message: error);
      },
      onSuccess: () {
        AppToast.success(
          context: currentCtx,
          message: "Chat group created successfully",
        );
        dialogueCtx.pop();
        provider.getUsersInviteList(groupId: provider.groupId);
        _inviteUserDialogue(context: currentCtx, provider: provider);
      },
    );
  }

  //* invite user dialogue
  void _inviteUserDialogue({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    showDialog(
      context: context,
      builder: (dialogueCtx) {
        final fieldWidth = context.screenWidth > 1100 ? 450.0 : 340.0;

        String normalizedStatus(String? status) {
          if (status == null || status.trim().toLowerCase() == 'null') {
            return '';
          }
          if (status == 'left') return 'left';
          return status;
        }

        bool canInviteCheck(String? status) {
          final s = normalizedStatus(status);
          return s == '' || s == 'left';
        }

        Widget userRow({
          required UserInvitesList user,
          required bool isSelected,
          required bool canInvite,
          required VoidCallback onTap,
        }) {
          final status = normalizedStatus(user.membershipStatus);
          final displayName = user.name.trim();

          final actionBg = canInvite && isSelected
              ? AppColors.green
              : canInvite
              ? AppColors.primary
              : AppColors.greyColor;
          final actionIcon = isSelected ? AppAssets.done : AppAssets.addUser;

          return OnMouseTap(
            onTap: canInvite ? onTap : null,
            child: Container(
              height: 48,
              width: fieldWidth,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.green.withValues(alpha: 0.5)
                      : AppColors.primary.withValues(alpha: 0.15),
                  width: isSelected ? 1.5 : 1,
                ),
                color: canInvite
                    ? AppColors.white
                    : AppColors.primary.withValues(alpha: 0.03),
              ),
              child: Row(
                children: [
                  //* ----------------> avatar
                  Container(
                    height: 48,
                    width: 48,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: AppColors.greyColor),
                    child: ImageWidget(
                      type: ImageType.svg,
                      path: AppAssets.userIcon,
                    ),
                  ),
                  const SizedBox(width: 12),
                  //* ----------------> username
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: semiBold(fontSize: 14),
                        ),
                        if (!canInvite && status.isNotEmpty)
                          Text(
                            status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: medium(
                              fontSize: 11,
                              color: AppColors.primary.withValues(alpha: 0.55),
                            ),
                          ),
                      ],
                    ),
                  ),

                  //* ----------------> action icon
                  Container(
                    height: 48,
                    width: 48,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: actionBg),
                    child: ImageWidget(
                      path: actionIcon,
                      type: ImageType.svg,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ZoomIn(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: AppColors.white,
            content: Consumer<PuntClubProvider>(
              builder: (context, p, child) {
                final list = p.userInvitesList;
                final selectedIds = p.selectedIds;
                final filtered = p.filteredUserList;
                final isSearching = p.searchNameCtr.text.trim().isNotEmpty;
                final hasSelection = selectedIds.isNotEmpty;
                p.searchNameCtr.clear();
                return Stack(
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* ---------------->  top bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 22,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Invite Users",
                                  style: regular(
                                    fontSize: 22,
                                    fontFamily: AppFontFamily.secondary,
                                  ),
                                ),
                                OnMouseTap(
                                  onTap: () {
                                    p.resetInviteState();
                                    dialogueCtx.pop();
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          horizontalDivider(),
                          const SizedBox(height: 18),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //* ----------------> search field
                                  AppTextField(
                                    controller: p.searchNameCtr,
                                    hintText: "Search by username",
                                    trailingIcon: AppAssets.searchIcon,

                                    suffixSize: 20,
                                  ),
                                  const SizedBox(height: 12),
                                  //* ----------------> user list
                                  Expanded(
                                    child: () {
                                      if (list == null) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primary,
                                            strokeWidth: 2,
                                            strokeCap: StrokeCap.round,
                                          ),
                                        );
                                      }
                                      if (list.isEmpty) {
                                        return const Center(
                                          child: Text("No users to invite"),
                                        );
                                      }
                                      if (filtered.isEmpty) {
                                        return Center(
                                          child: Text(
                                            isSearching
                                                ? 'No users found for "${p.searchNameCtr.text.trim()}"'
                                                : "Search the username to invite",
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: filtered.length,
                                        itemBuilder: (context, index) {
                                          final user = filtered[index];
                                          final isSelected = selectedIds
                                              .contains(user.id);
                                          final canInvite = canInviteCheck(
                                            user.membershipStatus,
                                          );
                                          return userRow(
                                            user: user,
                                            isSelected: isSelected,
                                            canInvite: canInvite,
                                            onTap: () => p.toggleUser(user.id),
                                          );
                                        },
                                      );
                                    }(),
                                  ),
                                  const SizedBox(height: 14),
                                  //* ----------------> send invite button
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: hasSelection
                                        ? AppFilledButton(
                                            key: ValueKey(selectedIds.length),
                                            width: fieldWidth,
                                            textStyle: semiBold(
                                              fontSize: 16,
                                              color: AppColors.white,
                                            ),
                                            text: selectedIds.length == 1
                                                ? "Send Invite"
                                                : "Send to All (${selectedIds.length})",
                                            onTap: () {
                                              final gid = (p.groupId.isEmpty)
                                                  ? p
                                                        .chatGroupsList![p
                                                            .selectedGroup]
                                                        .id
                                                        .toString()
                                                  : p.groupId;
                                              p.inviteUser(
                                                onSuccess: () {},
                                                groupId: gid,
                                                userIds: selectedIds
                                                    .map((id) => id.toString())
                                                    .toList(),
                                                context: dialogueCtx,
                                              );
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  AppOutlinedButton(
                                    width: fieldWidth,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    text: "Invite Later",
                                    onTap: () {
                                      p.resetInviteState();
                                      dialogueCtx.pop();
                                    },
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                    if (p.isInvitingUser) FullPageIndicator(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // NOTE: old static `_userBox` removed — web dialog now uses real API data.

  //* notification side sheet
  Widget _notificationSideSheet({
    required BuildContext context,
    required PuntClubProvider provider,
    // required double sixteenResponsive,
    // required double fourteenResponsive,
  }) {
    return ColoredBox(
      color: AppColors.white,
      child: Consumer<PuntClubProvider>(
        builder: (context, p, _) {
          final notifications = p.notificationList;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notifications (${p.notificationCount})",
                      style: regular(
                        fontSize: context.isDesktop ? 20 : 30,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 24),
                    horizontalDivider(),
                    const SizedBox(height: 16),
                    if (isGuest) ...[
                      Text(
                        AppStrings.guestNotificationsMessage,
                        style: medium(
                          fontSize: 14,
                          color: AppColors.primary.withValues(alpha: 0.7),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppFilledButton(
                        text: "Subscribe to Pro",
                        onTap: () {
                          context.pushNamed(
                            WebRoutes.manageSubscriptionScreen.name,
                          );
                        },
                      ),
                      const Spacer(),
                    ] else if (notifications == null) ...[
                      const Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary,strokeCap: StrokeCap.round),
                          ),
                        ),
                      ),
                    ] else if (notifications.isEmpty) ...[
                      Expanded(
                        child: Center(
                          child: Text(
                            "No notifications found!",
                            style: medium(
                              fontSize: 14,
                              color: AppColors.primary.withValues(alpha: 0.65),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 12),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final n = notifications[index];
                            return _notificationBox(
                              context: context,
                              provider: p,
                              notification: n,
                              index: index,
                            );
                          },
                        ),
                      ),
                      AppOutlinedButton(
                        margin: const EdgeInsets.only(bottom: 30, top: 10),
                        borderColor: AppColors.redButton,
                        textStyle: semiBold(
                          fontSize: 14,
                          color: AppColors.redButton,
                        ),
                        text: "Clear all",
                        onTap: () {
                          p.clearNotificationList();
                          p.deleteAllNotification();
                        },
                      ),
                    ],
                  ],
                ),
              ),
              // if (p.isAcceptingInvitation || p.isUserNameSetupLoading)
              //   FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }

  //* notification details box
  Widget _notificationBox({
    required BuildContext context,
    required PuntClubProvider provider,
    required NotificationModel notification,
    required int index,
    // required double sixteenResponsive,
    // required double fourteenResponsive,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: context.isDesktop ? 18 : 24,
      ),
      margin: const EdgeInsets.only(bottom: 8),
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
            child: Text(
              notification.message.split("Accept")[0].trim(),
              style: medium(fontSize: 14, fontFamily: AppFontFamily.primary),
            ),
          ),
          const SizedBox(width: 26),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (notification.hasInvite) ...[
                AppFilledButton(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  isExpand: false,
                  text: "Join",
                  textStyle: semiBold(fontSize: 12, color: AppColors.white),
                  onTap: () {
                    final inviteId = notification.inviteId!;
                    provider.acceptInvitation(
                      inviteId: inviteId,
                      onFailed: (error) {
                        AppToast.info(context: context, message: error);
                      },
                      onSuccess: () {
                        AppToast.success(
                          context: context,
                          message: "Invite accepted. Please create a username.",
                        );
                        _enterUserNameDialogue(
                          context: context,
                          provider: provider,
                        );
                      },
                    );
                  },
                ),
                AppOutlinedButton(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  isExpand: false,
                  textStyle: semiBold(fontSize: 12, color: AppColors.black),
                  text: "Decline",
                  onTap: () {
                    provider.rejectInvitation(
                      rejectId: notification.inviteId!,
                      onSuccess: () {
                        AppToast.success(
                          context: context,
                          message: "Invitation declined successfully",
                        );
                      },
                    );
                  },
                  margin: const EdgeInsets.only(left: 10),
                ),
              ],
              const SizedBox(width: 12),
              OnMouseTap(
                onTap: () {
                  provider.removeNotificationAt(index);
                  provider.deleteSingleNotification(
                    notificationId: notification.id.toString(),
                    onSuccess: () {},
                  );
                  AppToast.success(
                    context: context,
                    message: "Removed successfully",
                    duration: const Duration(seconds: 2),
                  );
                },
                child: const Icon(Icons.close_rounded, size: 16),
              ),
            ],
          ),
          // Expanded(
          //   child: Column(
          //     spacing: 10,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  //* enter user name dialogue
  void _enterUserNameDialogue({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    showDialog(
      context: context,
      builder: (dialogueCtx) {
        final fieldWidth = 300.00;
        return ZoomIn(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: AppColors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //todo top bar of popup
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 18.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Username",
                                style: regular(
                                  fontSize: 22.twentyTwoSp(context),
                                  fontFamily: AppFontFamily.secondary,
                                ),
                              ),
                              Text(
                                "Your username will be displayed to \nyour club members.",
                                style: semiBold(
                                  fontSize: 12.twelveSp(context),
                                  color: AppColors.primary.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          OnMouseTap(
                            onTap: () {
                              context.pop();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.primary,
                              size: 22.twentyTwoSp(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                horizontalDivider(),
                //todo Club Name Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 24.w,
                    children: [
                      Row(children: []),
                      SizedBox(
                        width: fieldWidth.toDouble(),
                        child: AppTextField(
                          controller: provider.clubNameCtr,
                          hintText: "Enter Username",
                        ),
                      ),
                      AppFilledButton(
                        width: fieldWidth.toDouble(),
                        text: "Create",
                        onTap: () {
                          // if (provider.clubNameCtr.text.isEmpty) {
                          //
                          // }
                          dialogueCtx.pop();
                          // _inviteUserDialogue(
                          //   context: context,
                          //   provider: provider,
                          // );
                        },
                        margin: EdgeInsets.only(bottom: 30.w),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
