import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/guest_create_account_sheet.dart';
import 'package:puntgpt_nick/main.dart';

import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/account/web/web_change_password_section.dart';
import 'package:puntgpt_nick/screens/account/web/web_current_plan_section.dart';
import 'package:puntgpt_nick/screens/account/web/web_manage_subscription_section.dart';
import 'package:puntgpt_nick/screens/account/web/web_personal_details_section.dart';
import 'package:puntgpt_nick/screens/account/web/web_selected_plan_section.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';

class AccountScreenWeb extends StatefulWidget {
  const AccountScreenWeb({super.key});

  @override
  State<AccountScreenWeb> createState() => _AccountScreenWebState();
}

class _AccountScreenWebState extends State<AccountScreenWeb> {
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
    //     : (context.isBrowserMobile)
    //     ? 36.sp
    //     : 20.sp;
    // final twentyTwoResponsive = context.isDesktop
    //     ? 22.sp
    //     : context.isTablet
    //     ? 30.sp
    //     : (context.isBrowserMobile)
    //     ? 38.sp
    //     : 22.sp;
    // final sixteenResponsive = context.isDesktop
    //     ? 16.sp
    //     : context.isTablet
    //     ? 24.sp
    //     : (context.isBrowserMobile)
    //     ? 32.sp
    //     : 16.sp;
    // final twelveResponsive = context.isDesktop
    //     ? 12.sp
    //     : context.isTablet
    //     ? 20.sp
    //     : (kIsWeb)
    //     ? 28.sp
    //     : 12.sp;
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: bodyWidth,
              child: Consumer2<AccountProvider, SubscriptionProvider>(
                builder:
                    (context, accountProvider, subscriptionProvider, child) {
                      final provider = accountProvider;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* ---------------> left panel
                          verticalDivider(),
                          SizedBox(
                            width: context.isDesktop
                                ? 312.w
                                : context.isTablet
                                ? 370.w
                                : 512.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //* title
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        16, //context.isDesktop ? 26.w : 20.w,
                                    vertical:
                                        16, //context.isDesktop ? 26.w : 20.w,
                                  ),
                                  child: Text(
                                    "My Account",

                                    style: regular(
                                      fontSize: 20,
                                      height: 1,
                                      fontFamily: AppFontFamily.secondary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                horizontalDivider(),

                                //* 1st tab
                                accountTabs(
                                  title: "Personal Details",
                                  // fourteenResponsive: fourteenResponsive,
                                  color: (provider.selectedAccountTabWeb == 0)
                                      ? AppColors.primary
                                      : null,
                                  onTap: () {
                                    if (isGuest) {
                                      showGuestCreateAccountSheet(
                                        context,
                                        message: AppStrings
                                            .guestPersonalDetailsMessage,
                                      );
                                      return;
                                    }
                                    provider.setAccountTabIndex = 0;
                                  },
                                  context: context,
                                ),
                                accountTabs(
                                  title: "Manage Subscription",
                                  // sixteenResponsive: fourteenResponsive,
                                  color: (provider.selectedAccountTabWeb == 1)
                                      ? AppColors.primary
                                      : null,

                                  onTap: () {
                                    provider.setAccountTabIndex = 1;
                                    context
                                        .read<SubscriptionProvider>()
                                        .getSubscriptionPlans();
                                  },
                                  context: context,
                                ),
                                horizontalDivider(),
                                Spacer(),
                                horizontalDivider(),
                                if (!isGuest) ...[
                                  accountTabs(
                                    title: "Log Out",
                                    onTap: () {
                                      showLogOutConfirmationDialog(
                                        context: context,
                                      );
                                    },
                                    context: context,
                                  ),
                                  horizontalDivider(),
                                  accountTabs(
                                    title: "Delete Account",
                                    destructive: true,
                                    onTap: () {
                                      showDeleteAccountConfirmationDialog(
                                        context: context,
                                      );
                                    },
                                    context: context,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          verticalDivider(),
                          //* ----------------> right side panel
                          if (provider.selectedAccountTabWeb == 0)
                            if (provider.showChangePassword)
                              //* change password section
                              ChangePasswordSectionWeb()
                            else
                              //* change password section
                              PersonalDetailsSectionWeb()
                          else if (subscriptionProvider.showSelectedPlan)
                            SelectedPlanSectionWeb()
                          else if (subscriptionProvider.showCurrentPlan)
                            CurrentPlanSectionWeb()
                          else
                            ManageSubscriptionSectionWeb(),
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
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.isLogOutLoading || auth.isDeleteAccountLoading) {
                return const FullPageIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget accountTabs({
    required String title,
    Color? color,
    bool destructive = false,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return OnMouseTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(color: color),
        padding: EdgeInsets.symmetric(
          horizontal: 16, //context.isDesktop ? 24.w : 30.w,
          vertical: 12, //context.isDesktop ? 20.w : 26.w,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: bold(
                  fontSize: 13,
                  color: (title == "Log Out" || destructive)
                      ? AppColors.red
                      : color == AppColors.primary
                      ? AppColors.white
                      : null,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,

              color: (title == "Log Out" || destructive)
                  ? AppColors.red
                  : color == AppColors.primary
                  ? AppColors.white
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteAccountConfirmationDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              title: Text(
                AppStrings.deleteAccountConfirmTitle,
                style: semiBold(color: AppColors.black, fontSize: 20),
              ),
              content: Text(
                "This will permanently delete your PuntGPT account\nand associated data."
                "You will not be able to\nrecover it. Are you sure?",
                style: regular(
                  color: AppColors.primary.withValues(alpha: 0.85),
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              actions: [
                myActionButtonTheme(
                  onPressed: () => context.pop(),
                  title: "Cancel",
                ),
                myActionButtonTheme(
                  onPressed: () async {
                    context.pop(dialogContext);
                    await context.read<AuthProvider>().deleteAccount(
                      onSuccess: () {
                        AppToast.success(
                          context: context,
                          message: "Your account has been deleted",
                        );
                        context
                            .read<SubscriptionProvider>()
                            .activeSubscriptions
                            .clear();
                        context.goNamed(WebRoutes.onBoardingScreen.name);
                      },
                      onFailed: (error) {
                        AppToast.error(context: context, message: error);
                      },
                    );
                  },
                  title: "Delete account",
                  destructive: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showLogOutConfirmationDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            title: Text(
              AppStrings.logOutConfirmTitle,
              style: semiBold(color: AppColors.black, fontSize: 20),
            ),
            content: Text(
              "You will be signed out on this device.\nYou can sign in again at any time.",
              style: regular(
                color: AppColors.primary.withValues(alpha: 0.85),
                fontSize: 15,
                height: 1.35,
              ),
            ),
            actions: [
              myActionButtonTheme(
                onPressed: () => context.pop(),
                title: "Cancel",
              ),
              myActionButtonTheme(
                onPressed: () async {
                  context.pop(dialogContext);
                  await context.read<AuthProvider>().logout(
                    onSuccess: () {
                      AppToast.success(
                        context: context,
                        message: "Signed out successfully",
                      );
                      context
                          .read<SubscriptionProvider>()
                          .activeSubscriptions
                          .clear();
                      context.goNamed(WebRoutes.onBoardingScreen.name);
                    },
                    onFailed: (error) {
                      AppToast.error(context: context, message: error);
                    },
                  );
                },
                title: "Log out",
                destructive: true,
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
    bool destructive = false,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: regular(
          color: (destructive || title == "Yes")
              ? AppColors.red
              : AppColors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
