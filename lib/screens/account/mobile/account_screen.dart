import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/guest_create_account_sheet.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final showAppleEulaLink =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
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
              if (LocaleStorageService.loggedInUserEmail ==
                      AppStrings.adminEmail &&
                  !isGuest) ...[
                accountItem(
                  context: context,
                  title: "Lifetime Members",
                  onTap: () {
                    context.read<SubscriptionProvider>().getLifetimeMembers();
                    context.pushNamed(AppRoutes.lifeTimeMembersScreen.name);
                  },
                ),
                horizontalDivider(),
              ],
              if (!isGuest) ...[
                accountItem(
                  context: context,
                  title: "Log Out",
                  onTap: () {
                    showLogOutConfirmationDialog(context: context);
                  },
                ),
                horizontalDivider(),
                accountItem(
                  context: context,
                  title: "Delete Account",
                  destructive: true,
                  onTap: () {
                    showDeleteAccountConfirmationDialog(context: context);
                  },
                ),
                horizontalDivider(),
              ],

              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OnMouseTap(
                      onTap: () {
                        launchUrl(
                          Uri.parse(AppStrings.termsAndConditionsUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        "Terms & Conditions",
                        style: bold(
                          fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    verticlaDiv(),
                    OnMouseTap(
                      onTap: () {
                        launchUrl(
                          Uri.parse(AppStrings.aiDisclaimerUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        "AI disclaimer",
                        style: bold(
                          decoration: TextDecoration.underline,

                          fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                        ),
                      ),
                    ),
                    verticlaDiv(),
                    OnMouseTap(
                      onTap: () {
                        launchUrl(
                          Uri.parse(AppStrings.privacyPolicyUrl),
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
                    if (showAppleEulaLink) ...[
                      verticlaDiv(),
                      OnMouseTap(
                        onTap: () {
                          launchUrl(
                            Uri.parse(AppStrings.appleStandardEulaUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Text(
                          "Apple EULA",
                          style: bold(
                            fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
            
              ),
              15.w.verticalSpace,
            ],
          ),
          if (context.watch<AuthProvider>().isLogOutLoading ||
              context.watch<AuthProvider>().isDeleteAccountLoading)
            FullPageIndicator(),
        ],
      ),
    );
  }

  Container verticlaDiv() {
    return Container(
      width: 1,
      height: 12,
      color: AppColors.primary,
      margin: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  void showDeleteAccountConfirmationDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            titlePadding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 8.w),
            contentPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.w),
            actionsPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
            title: Text(
              AppStrings.deleteAccountConfirmTitle,
              style: semiBold(
                color: AppColors.black,
                fontSize: context.isBrowserMobile ? 22.sp : 18.sp,
              ),
            ),
            content: Text(
              AppStrings.deleteAccountConfirmBody,
              style: regular(
                color: AppColors.primary.withValues(alpha: 0.85),
                fontSize: context.isBrowserMobile ? 18.sp : 14.sp,
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
                        message: "Your account has been deleted successfully.",
                      );
                      context.read<SubscriptionProvider>().activeSubscriptions
                          .clear();
                      context.goNamed(AppRoutes.signUpScreen.name);//commenting the onboardingScreen to avoid the login flow.
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
              borderRadius: BorderRadius.circular(12.r),
            ),
            titlePadding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 8.w),
            contentPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.w),
            actionsPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
            title: Text(
              AppStrings.logOutConfirmTitle,
              style: semiBold(
                color: AppColors.black,
                fontSize: context.isBrowserMobile ? 22.sp : 18.sp,
              ),
            ),
            content: Text(
              AppStrings.logOutConfirmBody,
              style: regular(
                color: AppColors.primary.withValues(alpha: 0.85),
                fontSize: context.isBrowserMobile ? 18.sp : 14.sp,
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
                      context.read<SubscriptionProvider>().activeSubscriptions
                          .clear();
                      context.goNamed(AppRoutes.signUpScreen.name);//commenting the onboardingScreen to avoid the login flow.
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
    final isRed = destructive;
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: regular(
          color: isRed ? AppColors.red : AppColors.black,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget accountItem({
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
    bool destructive = false,
  }) {
    final red = destructive || title == "Log Out";
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
                color: red ? AppColors.red : null,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: red ? AppColors.red : null,
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
