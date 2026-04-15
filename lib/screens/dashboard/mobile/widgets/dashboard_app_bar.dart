import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:badges/badges.dart' as badges;
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/dashboard/mobile/dashboard.dart';
import 'package:puntgpt_nick/screens/dashboard/web/web_dashboard.dart'
    show indexOfWebTab;

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
          children: [
            _appLogo(),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Icon(Icons.home, color: AppColors.white),
            //     Text(
            //       "Home",
            //       style: regular(color: AppColors.white, fontSize: 12.sp),
            //     ),
            //   ],
            // ),
            _bannerAd(),
            _tipSlip(),
          ],
        ),
      ),
    );
  }

  void _navigateToAccountFromLogo() {
    if (kIsWeb) {
      indexOfWebTab.value = 3;
      WebRouter.indexedStackNavigationShell?.goBranch(3);
      return;
    }
    indexOfTab.value = 3;
    AppRouter.indexedStackNavigationShell?.goBranch(3);
  }

  Widget _appLogo() {
    // Previous: [PopupMenuButton] with PuntGPT Search Engine / Classic Form Guide / Account.
    // Logo tap now opens Account only (same as former "Account Management" item).
    //
    // return PopupMenuButton<int>(
    //   padding: EdgeInsets.zero,
    //   offset: Offset(-4.w, 8.w),
    //   color: AppColors.white,
    //   elevation: 6,
    //   shadowColor: AppColors.black.withValues(alpha: 0.2),
    //   shape: RoundedRectangleBorder(
    //     side: BorderSide(color: AppColors.black, width: 1),
    //     borderRadius: BorderRadius.circular(4.r),
    //   ),
    //   popUpAnimationStyle: AnimationStyle(
    //     duration: const Duration(milliseconds: 300),
    //     reverseDuration: const Duration(milliseconds: 220),
    //     curve: Curves.easeOutCubic,
    //     reverseCurve: Curves.easeInCubic,
    //   ),
    //   onSelected: (int value) { ... },
    //   itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[ ... ],
    //   child: Column(...),
    // );

    return Tooltip(
      message: 'Account',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToAccountFromLogo,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            child: Column(
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
                        "Pro",
                        style: regular(
                          height: 1,
                          fontSize: 14.sp,
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
                        fontFamily: AppFontFamily.secondary,
                        color: AppColors.premiumYellow,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tipSlip() {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        return Tooltip(
          message: 'Tip Slip',
          child: SizedBox(
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
          ),
        );
      },
    );
  }

  Widget _bannerAd() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          launchDabbleUrl();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Center(
            child: GifAssetPlayer(
              assetPath: AppAssets.dabbleGIF,
              fallback: ImageWidget(
                path: AppAssets.dabbleBanner,
                type: ImageType.asset,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}