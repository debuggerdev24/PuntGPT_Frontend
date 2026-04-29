import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:puntgpt_nick/core/widgets/subscription_gate_view_web.dart';
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
                    featureDescription: "Create and join clubs, chat with members, and share tips.",
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
                                      width: 530,
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
                                  child: ImageWidget(
                                    path: AppAssets.webNotification,
                                    type: ImageType.svg,
                                  ),
                                ),
                                OnMouseTap(
                                  onTap: () => _createClubDialogue(
                                    context: context,
                                    provider: provider,
                                  ),
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
                          4.w.verticalSpace,
                          horizontalDivider(),

                          //* chat tabs
                          _chatTabs(
                            title: "‘Top Punters’",
                            // fourteenResponsive: fourteenResponsive,
                            color: (provider.selectedPunterWeb == 0)
                                ? AppColors.primary
                                : null,
                            onTap: () {
                              provider.setPunterIndex = 0;
                            },
                            context: context,
                          ),
                          horizontalDivider(),
                          _chatTabs(
                            title: "‘PuntGPT Legends’",
                            // fourteenResponsive: fourteenResponsive,
                            color: (provider.selectedPunterWeb == 1)
                                ? AppColors.primary
                                : null,
                            onTap: () {
                              provider.setPunterIndex = 1;
                            },
                            context: context,
                          ),
                          horizontalDivider(),
                          _chatTabs(
                            title: "‘Mug Punters Crew’",
                            // fourteenResponsive: fourteenResponsive,
                            color: (provider.selectedPunterWeb == 2)
                                ? AppColors.primary
                                : null,
                            onTap: () {
                              provider.setPunterIndex = 2;
                            },
                            context: context,
                          ),
                          horizontalDivider(),
                          Spacer(),
                          AppOutlinedButton(
                            margin: EdgeInsets.all(24.w),
                            textStyle: semiBold(
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                            text: "Create New Club",
                            onTap: () {},
                          ),
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
        final fieldWidth = context.isDesktop ? 344.w : 390.w;
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
                    horizontal: context.isDesktop ? 24.w : 30.w,
                    vertical: context.isDesktop ? 18.w : 24.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              "Create Punters Club",
                              style: regular(
                                fontSize: 22.twentyTwoSp(context),
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
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 24.w,
                    children: [
                      Row(children: []),
                      SizedBox(
                        width: fieldWidth,
                        child: AppTextField(
                          controller: provider.clubNameCtr,
                          hintText: "Search by username",
                        ),
                      ),
                      AppFilledButton(
                        width: fieldWidth,
                        text: "Invite User",
                        margin: EdgeInsets.only(bottom: 24.w),
                        textStyle: semiBold(
                          fontSize: 14.fourteenSp(context),
                          color: AppColors.white,
                        ),
                        onTap: () {
                          // if (provider.clubNameCtr.text.isEmpty) {
                          //
                          // }
                          dialogueCtx.pop();
                          _inviteUserDialogue(
                            context: context,
                            provider: provider,
                          );
                        },
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

  //todo invite user dialogue
  void _inviteUserDialogue({
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
                    vertical: 22.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              "Invite Users",
                              style: regular(
                                fontSize: 22.twentyTwoSp(context),
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
                              size: 22.twentyTwoSp(context),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   "Your username will be displayed to your club members.",
                      //   style: semiBold(
                      //     fontSize: 12.sp,
                      //     color: AppColors.primary.withValues(alpha: 0.6),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                horizontalDivider(),
                //todo Search User field
                24.w.verticalSpace,
                Row(children: []),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(
                        width: fieldWidth,
                        child: AppTextField(
                          controller: provider.clubNameCtr,
                          hintText: "Enter Club Name",
                          trailingIcon: AppAssets.searchIcon,
                          validator: (value) =>
                              FieldValidators().required(value, "Club Name"),
                        ),
                      ),
                      24.w.verticalSpace,
                      _userBox(fieldWidth: fieldWidth, context: dialogueCtx),
                      _userBox(fieldWidth: fieldWidth, context: dialogueCtx),
                      AppOutlinedButton(
                        width: fieldWidth,
                        text: "Invite User",
                        textStyle: semiBold(fontSize: 14.fourteenSp(context)),
                        onTap: () {
                          // if (provider.clubNameCtr.text.isEmpty) {
                          //
                          // }
                          dialogueCtx.pop();
                          _inviteUserDialogue(
                            provider: provider,
                            context: context,
                          );
                        },
                        margin: EdgeInsets.only(bottom: 30.w, top: 40.w),
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

  //* user name box
  Widget _userBox({required double fieldWidth, required BuildContext context}) {
    final boxSize = context.isDesktop ? 48.w : 70.w;
    return Container(
      height: boxSize,
      width: fieldWidth,
      margin: EdgeInsets.only(bottom: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            height: boxSize,
            width: boxSize,
            padding: EdgeInsets.all(context.isDesktop ? 12.w : 18.w),
            decoration: BoxDecoration(color: AppColors.greyColor),
            child: ImageWidget(type: ImageType.svg, path: AppAssets.userIcon),
          ),
          15.w.horizontalSpace,
          Text(
            "@otherpropunter_1",
            style: semiBold(fontSize: 16.sixteenSp(context)),
          ),
          Spacer(),
          Container(
            height: boxSize,
            width: boxSize,
            padding: EdgeInsets.all(context.isDesktop ? 12.w : 18.w),
            decoration: BoxDecoration(color: AppColors.primary),
            child: ImageWidget(path: AppAssets.addUser, type: ImageType.svg),
          ),
        ],
      ),
    );
  }

  //* notification side sheet
  Widget _notificationSideSheet({
    required BuildContext context,
    required PuntClubProvider provider,
    // required double sixteenResponsive,
    // required double fourteenResponsive,
  }) {
    return ColoredBox(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notification(2)",
              style: regular(
                fontSize: context.isDesktop ? 20.sp : 30.sp,
                fontFamily: AppFontFamily.secondary,
                height: 1.35,
              ),
            ),
            24.w.verticalSpace,
            horizontalDivider(),
            24.w.verticalSpace,
            horizontalDivider(),
            _notificationBox(
              // fourteenResponsive: fourteenResponsive,
              // sixteenResponsive: sixteenResponsive,
              context: context,
              provider: provider,
            ),
            _notificationBox(
              // fourteenResponsive: fourteenResponsive,
              // sixteenResponsive: sixteenResponsive,
              context: context,
              provider: provider,
            ),
            Spacer(),
            AppOutlinedButton(
              margin: EdgeInsets.only(bottom: 30.w),
              borderColor: AppColors.redButton,
              textStyle: semiBold(
                fontSize: 14.fSize,
                color: AppColors.redButton,
              ),
              text: "Clear all",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  //todo notification details box
  Widget _notificationBox({
    required BuildContext context,
    required PuntClubProvider provider,
    // required double sixteenResponsive,
    // required double fourteenResponsive,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: context.isDesktop ? 18.w : 24.w,
      ),
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
          10.horizontalSpace,
          Expanded(
            child: RichText(
              maxLines: 4,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "You’ve been invited to join Punter Club",
                    style: medium(
                      fontSize: 14,
                      fontFamily: AppFontFamily.primary,
                    ),
                  ),
                  TextSpan(
                    text: " PuntGPT Legends",
                    style: bold(
                      fontSize: 14,
                      fontFamily: AppFontFamily.primary,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          26.horizontalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppFilledButton(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
                isExpand: false,
                text: "Join",
                textStyle: semiBold(fontSize: 12, color: AppColors.white),
                onTap: () {
                  context.pop();
                  _enterUserNameDialogue(context: context, provider: provider);
                },
              ),
              AppOutlinedButton(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                isExpand: false,
                textStyle: semiBold(
                  fontSize: 14.fourteenSp(context),
                  color: AppColors.black,
                ),
                text: "Decline",
                onTap: () {},
                margin: EdgeInsets.only(left: 10.w),
              ),
              12.w.horizontalSpace,
              Icon(Icons.close_rounded, size: 16),
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

  //todo enter user name dialogue
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
