import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/guest_create_account_sheet.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/auth/auth_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        AppRouter.indexedStackNavigationShell?.goBranch(0);
      },
      child: Stack(
        children: [
          Column(
            children: [
              topBar(context),
              accountItem(
                context: context,
                title: "Personal Details",
                onTap: () {
                  if (isGuest) {
                    showGuestCreateAccountSheet(
                      context,
                      message: AppStrings.guestPersonalDetailsMessage,
                    );
                    return;
                  }
                  if (context.isMobileView && kIsWeb) {
                    context.pushNamed(WebRoutes.personalDetailsScreen.name);
                    return;
                  }
                  context.pushNamed(AppRoutes.personalDetailsScreen.name);
                },
              ),
              horizontalDivider(),
              accountItem(
                context: context,
                title: "Manage Subscription",
                onTap: () {
                  if (context.isMobileView && kIsWeb) {
                    context.pushNamed(WebRoutes.manageSubscriptionScreen.name);
                    return;
                  }
                  context.pushNamed(AppRoutes.manageSubscriptionScreen.name);
                },
              ),
              horizontalDivider(),
              if (!isGuest)
                accountItem(
                  context: context,
                  title: "Log Out",
                  onTap: () {
                    showLogOutConfirmationDialog(context: context);
                  },
                ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: bold(
                        fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 12,
                      color: AppColors.primary,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Text(
                      "AI disclaimer",
                      style: bold(
                        fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 12,
                      color: AppColors.primary,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    OnMouseTap(
                      onTap: () {
                        launchUrl(
                          Uri.parse(kPrivacyPolicyUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        "Privacy Policy",
                        style: bold(
                          fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Text("Terms & Conditions", style: bold(fontSize: 14.sp)),
                //     Text(" | ", style: bold(fontSize: 14.sp)),
                //     Text("AI Disclaimer", style: bold(fontSize: 14.sp)),
                //     Text(" | ", style: bold(fontSize: 14.sp)),
                //     Text("Terms & Conditions", style: bold(fontSize: 14.sp)),
                //   ],
                // ),
              ),
              26.h.verticalSpace,
            ],
          ),
          if (context.watch<AuthProvider>().isLogOutLoading)
            FullPageIndicator(),
        ],
      ),
    );
  }

  void showLogOutConfirmationDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              "Are you sure you want to Log Out?",
              style: regular(
                color: AppColors.black,
                fontSize: context.isBrowserMobile ? 65.sp : 19.sp,
              ),
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
                      final subscriptionProvider = context
                          .read<SubscriptionProvider>();
                      subscriptionProvider.activeSubscriptions.clear();
                      context.goNamed(AppRoutes.onboardingScreen.name);
                    },
                    onFailed: (error) {
                      AppToast.error(context: context, message: error);
                    },
                  );
                },
                title: "Yes",
              ),
              myActionButtonTheme(
                onPressed: () {
                  context.pop();
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

  Widget accountItem({
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return OnMouseTap(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (context.isBrowserMobile) ? 38.w : 25.w,
          vertical: 18.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: semiBold(
                fontSize: (context.isBrowserMobile) ? 32.sp : 18.sp,
                color: (title == "Log Out") ? AppColors.red : null,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: (title == "Log Out") ? AppColors.red : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget topBar(BuildContext context) {
    return AppScreenTopBar(
      title: "Account",
      slogan: "Manage your PuntGPT Account",
      onBack: () {
        if (context.isMobileView && kIsWeb) {
          WebRouter.indexedStackNavigationShell!.goBranch(2);
          return;
        }
        AppRouter.indexedStackNavigationShell!.goBranch(0);
      },
    );
    // return Column(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.fromLTRB(4.w, 5.w, 25.w, 6.w),

    //       //padding: EdgeInsets.fromLTRB(5.w, 8.w, 25.w, 10.w),
    //       child: Row(
    //         children: [
    //           IconButton(
    //             padding: EdgeInsets.zero,
    //             onPressed: () {
    //               if (context.isMobileView && kIsWeb) {
    //                 WebRouter.indexedStackNavigationShell!.goBranch(2);
    //                 return;
    //               }
    //               AppRouter.indexedStackNavigationShell!.goBranch(0);
    //             },
    //             icon: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
    //           ),
    //           // GestureDetector(
    //           //   onTap: () {
    //           //     context.pop();
    //           //   },
    //           //   child: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
    //           // ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Account",
    //                 style: regular(
    //                   fontSize: (context.isBrowserMobile) ? 40.sp : 24.sp,
    //                   fontFamily: AppFontFamily.secondary,
    //                   height: 1.15,
    //                 ),
    //               ),
    //               Text(
    //                 "Manage your PuntGPT Account",
    //                 style: semiBold(
    //                   fontSize: (context.isBrowserMobile) ? 26.sp : 14.sp,
    //                   color: AppColors.primary.withValues(alpha: 0.6),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //     horizontalDivider(),
    //   ],
    // );
  }
}
