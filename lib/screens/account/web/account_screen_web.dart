import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/guest_create_account_sheet.dart';
import 'package:puntgpt_nick/main.dart';

import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/account/web/change_password_section_web.dart';
import 'package:puntgpt_nick/screens/account/web/current_plan_section_web.dart';
import 'package:puntgpt_nick/screens/account/web/manage_subscription_section_web.dart';
import 'package:puntgpt_nick/screens/account/web/personal_details_section_web.dart';
import 'package:puntgpt_nick/screens/account/web/selected_plan_section_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';

class AccountScreenWeb extends StatefulWidget {
  const AccountScreenWeb({super.key});

  @override
  State<AccountScreenWeb> createState() => _AccountScreenWebState();
}

class _AccountScreenWebState extends State<AccountScreenWeb> {
  @override
  Widget build(BuildContext context) {
    final bodyWidth = context.isBrowserMobile
        ? double.maxFinite
        : context.isTablet
        ? 1240.w
        : 1040.w;
    final twentyResponsive = context.isDesktop
        ? 20.sp
        : context.isTablet
        ? 28.sp
        : (context.isBrowserMobile)
        ? 36.sp
        : 20.sp;
    final twentyTwoResponsive = context.isDesktop
        ? 22.sp
        : context.isTablet
        ? 30.sp
        : (context.isBrowserMobile)
        ? 38.sp
        : 22.sp;
    final sixteenResponsive = context.isDesktop
        ? 16.sp
        : context.isTablet
        ? 24.sp
        : (context.isBrowserMobile)
        ? 32.sp
        : 16.sp;
    // final twelveResponsive = context.isDesktop
    //     ? 12.sp
    //     : context.isTablet
    //     ? 20.sp
    //     : (kIsWeb)
    //     ? 28.sp
    //     : 12.sp;
    final fourteenResponsive = context.isDesktop
        ? 14.sp
        : context.isTablet
        ? 20.sp
        : context.isBrowserMobile
        ? 28.sp
        : 14.sp;
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: bodyWidth,
              child: Consumer<AccountProvider>(
                builder: (context, provider, child) {
                  return Row(
                    children: [
                      //todo ---------------> left panel
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
                            //todo title
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.isDesktop ? 26.w : 20.w,

                                vertical: context.isDesktop ? 26.w : 20.w,
                              ),
                              child: Text(
                                "My Account",
                                style: regular(
                                  fontSize: twentyResponsive,
                                  fontFamily: AppFontFamily.secondary,
                                ),
                              ),
                            ),
                            4.h.verticalSpace,
                            horizontalDivider(),

                            //todo 1st tab
                            accountTabs(
                              title: "Personal Details",
                              fourteenResponsive: fourteenResponsive,
                              color: (provider.selectedAccountTabWeb == 0)
                                  ? AppColors.primary
                                  : null,
                              onTap: () {
                                if (isGuest) {
                                  showGuestCreateAccountSheet(
                                    context,
                                    message: AppStrings.guestPersonalDetailsMessage,
                                  );
                                  return;
                                }
                                provider.setAccountTabIndex = 0;
                              },
                              context: context,
                            ),
                            accountTabs(
                              title: "Manage Subscription",
                              fourteenResponsive: fourteenResponsive,
                              color: (provider.selectedAccountTabWeb == 1)
                                  ? AppColors.primary
                                  : null,

                              onTap: () {
                                provider.setAccountTabIndex = 1;
                              },
                              context: context,
                            ),
                            horizontalDivider(),
                            Spacer(),
                            horizontalDivider(),
                            if (!isGuest)
                              accountTabs(
                                title: "Log Out",
                                fourteenResponsive: sixteenResponsive,
                                onTap: () {
                                  showLogOutConfirmationDialog(
                                    context: context,
                                    responsiveTitle: twentyTwoResponsive,
                                    responsiveButton: twentyResponsive,
                                  );
                                },
                                context: context,
                              ),
                          ],
                        ),
                      ),
                      verticalDivider(),
                      //todo ----------------> right panel
                      if (provider.selectedAccountTabWeb == 0)
                        if (provider.showChangePassword)
                          //todo change password section
                          ChangePasswordSectionWeb()
                        else
                          //todo change password section
                          PersonalDetailsSectionWeb()
                      else if (provider.showSelectedPlan)
                        //todo selected plan section
                        SelectedPlanSectionWeb()
                      else if (provider.showCurrentPlan)
                        //todo current plan section
                        CurrentPlanSectionWeb()
                      else
                        //todo all plans section
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
        ],
      ),
    );
  }

  Widget accountTabs({
    required String title,
    required double fourteenResponsive,
    Color? color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return OnMouseTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(color: color),
        padding: EdgeInsets.symmetric(
          horizontal: context.isDesktop ? 24.w : 30.w,
          vertical: context.isDesktop ? 20.w : 26.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: bold(
                fontSize: fourteenResponsive,
                color: (title == "Log Out")
                    ? AppColors.red
                    : color == AppColors.primary
                    ? AppColors.white
                    : null,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: fourteenResponsive,
              color: (title == "Log Out")
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

  void showLogOutConfirmationDialog({
    required BuildContext context,
    required double responsiveTitle,
    required double responsiveButton,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            title: Text(
              "Are you sure you want to Log Out?",
              style: regular(color: AppColors.black, fontSize: responsiveTitle),
            ),
            actions: [
              myActionButtonTheme(
                onPressed: () async {
                  context.pop(dialogContext);
                  await context.read<AuthProvider>().logout(
                    onSuccess: () {
                      AppToast.success(
                        context: context,
                        message: "Log Out Successfully",
                      );

                      context.go(WebRoutes.onBoardingScreen.name);
                    },
                    onFailed: (error) {
                      AppToast.error(context: context, message: error);
                    },
                  );
                },
                title: "Yes",
                responsiveButton: responsiveButton,
              ),
              myActionButtonTheme(
                onPressed: () {
                  context.pop();
                },
                title: "Cancel",
                responsiveButton: responsiveButton,
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
    required double responsiveButton,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: regular(
          color: (title == "Yes") ? AppColors.red : AppColors.black,
          fontSize: responsiveButton,
        ),
      ),
    );
  }
}
