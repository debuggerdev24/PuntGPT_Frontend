import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:badges/badges.dart' as badges;
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';

class DashboardAppBar extends StatefulWidget {
  const DashboardAppBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primary),
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(
        (context.isBrowserMobile) ? 40.w : 16.w,

        5,
        (context.isBrowserMobile) ? 40.w : 16.w,
        8,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_appLogo(), _bannerAd(), _tipSlip()],
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageWidget(
          path: AppAssets.horse,
          width: context.isTablet
              ? 55.sp
              : (context.isBrowserMobile)
              ? 62.w
              : 32.w,
          color: AppColors.white,
        ),
        1.5.verticalSpace,
        Text(
          "PuntGPT",
          style: regular(
            fontSize: context.isTablet
                ? 32.sp
                : (context.isBrowserMobile)
                ? 48.sp
                : 14.sp,
            height: 1,
            fontFamily: AppFontFamily.secondary,
            color: AppColors.white,
          ),
        ),
        Consumer<SubscriptionProvider>(
          builder: (context, subscriptionProvider, child) {
            if (subscriptionProvider.isSubscribed) {
              return Text(
                textAlign: TextAlign.center,
                "Pro", // : "Upgrade to\nPro Punter",
                style: regular(
                  height: 1,
                  fontSize: 14.sp,
                  // context.isTablet
                  //     ? 32.sp
                  //     : (context.isBrowserMobile)
                  //     ? 48.sp
                  //     : 14.sp,
                  fontFamily: AppFontFamily.secondary,
                  color: AppColors.premiumYellow,
                ),
              );
            }
            return Text(
              textAlign: TextAlign.center,
              "Upgrade to\nPro Punter",
              style: regular(
                height: 1,
                fontSize: 12.sp,

                // context.isTablet
                //     ? 32.sp
                //     : (context.isBrowserMobile)
                //     ? 48.sp
                //     : 14.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.premiumYellow,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _tipSlip() {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          // height: (12.w.flexClamp(18, 22) * 1.2) + 20,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              provider.getAllTipSlips();
              if (kIsWeb) {
                WebRouter.indexedStackNavigationShell!.goBranch(3);
                return;
              }
              context.pushNamed(AppRoutes.tipSlipScreen.name);
            },
            child: badges.Badge(
              showBadge: provider.tipSlips?.isNotEmpty ?? false,
              position: badges.BadgePosition.topEnd(
                top: -11,
                end: context.isBrowserMobile ? -14.w : -5,
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: AppColors.white,
                borderRadius: BorderRadius.circular(2),
                elevation: 0,
              ),
              badgeContent: Text(
                provider.tipSlips?.length.toString() ?? "0",
                style: semiBold(
                  fontSize: context.isTablet
                      ? 18.sp
                      : (context.isBrowserMobile)
                      ? 24.sp
                      : 12.sp,
                  color: AppColors.black,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: Text(
                  "Tip Slip",
                  style: bold(
                    height: 1.2,
                    fontSize: context.isTablet
                        ? 32.sp
                        : (context.isBrowserMobile)
                        ? 40.sp
                        : 18.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bannerAd() {
    return Expanded(
      child: Container(
        height: 55.w,
        width: context.screenWidth - 50,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          "Ad",
          style: regular(fontSize: (context.isBrowserMobile) ? 30.sp : 16.sp),
        ),
      ),
    );
  }
}
