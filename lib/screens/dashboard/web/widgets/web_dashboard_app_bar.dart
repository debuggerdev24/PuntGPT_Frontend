import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/dashboard/web/web_dashboard.dart';

class WebDashboardAppBar extends StatefulWidget {
  const WebDashboardAppBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<WebDashboardAppBar> createState() => _WebDashboardAppBarState();
}

class _WebDashboardAppBarState extends State<WebDashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return Container(
        decoration: BoxDecoration(color: AppColors.primary),
        height: (context.screenWidth > 1010) ? 92.w : 102.w,
        width: double.maxFinite,
        alignment: AlignmentGeometry.center,
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 90.w, 0.h),
        child: ValueListenableBuilder(
          valueListenable: indexOfWebTab,
          builder: (context, value, child) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 45,
                        width: 130,
                        color: AppColors.white,
                        alignment: Alignment.center,
                        child: Text("Ads"),
                      ),
                      60.w.horizontalSpace,
                      //* -------------------------> Bookies tab
                      _navItem(
                        onTap: () {
                          indexOfWebTab.value = 0;
                          WebRouter.indexedStackNavigationShell!.goBranch(0);
                        },
                        isSelected: 0 == value,
                        text: "Bookies",
                        icon: AppAssets.bookings,
                        color: AppColors.green,
                      ),
                      30.w.horizontalSpace,
                      //* -------------------------> Punter Club tab
                      _navItem(
                        onTap: () {
                          indexOfWebTab.value = 1;
                          WebRouter.indexedStackNavigationShell!.goBranch(1);
                          context.read<PuntClubProvider>().getChatGroups();
                        },
                        isSelected: 1 == value,
                        text: "PuntGPT\nPunter Club",
                        icon: AppAssets.group,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentGeometry.center,
                  child: _appLogo(context),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    spacing: 30.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //* -------------------------> Subscribe to pro punter
                      _navItem(
                        onTap: () {
                          indexOfWebTab.value = 5;
                          context.read<AccountProvider>().setAccountTabIndex =
                              1;
                          WebRouter.indexedStackNavigationShell!.goBranch(4);
                        },
                        isSelected: 5 == value,
                        text: "Subscribe\nto Pro Punter",
                        icon: AppAssets.trophy,
                        color: AppColors.premiumYellow,
                      ),
                      //* -------------------------> Tip slip screen
                      _navItem(
                        onTap: () {
                          indexOfWebTab.value = 3;
                          WebRouter.indexedStackNavigationShell!.goBranch(3);
                        },
                        isSelected: 3 == value,
                        child: _tipSlip(context),
                      ),
                      //* -------------------------> Account
                      _navItem(
                        onTap: () {
                          indexOfWebTab.value = 4;
                          context.read<AccountProvider>().setAccountTabIndex =
                              0;

                          WebRouter.indexedStackNavigationShell!.goBranch(4);
                        },
                        isSelected: 4 == value,
                        text: "Account",
                        icon: AppAssets.profile,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
    //* menu bar for mobile
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.primary),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: (context.isMobileWeb) ? 40.w : 16.w,
                vertical: 8.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _menuIcon(context, provider),
                  _bannerAd(),
                  _tipSlip(context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _menuIcon(BuildContext context, SearchEngineProvider provider) {
    if (!context.isDesktop) {
      return OnMouseTap(
        onTap: () {
          provider.setIsMenuOpen = !provider.isMenuOpen;
        },
        child: Padding(
          padding: EdgeInsets.only(right: 0),
          child: Icon(
            provider.isMenuOpen ? Icons.close : Icons.menu,
            color: AppColors.white,
            size: (context.isTablet)
                ? 42.w
                : (context.isMobileWeb)
                ? 45.w
                : 33.w,
          ),
        ),
      );
    }
    return SizedBox();
  }

  Widget _appLogo(BuildContext context) {
    return OnMouseTap(
      onTap: () {
        WebRouter.indexedStackNavigationShell!.goBranch(2);
        indexOfWebTab.value = 2;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.w,
        children: [
          ImageWidget(
            type: ImageType.asset,
            path: AppAssets.webLogo,
            color: AppColors.white,
            height: 52.w,
          ),
          Text(
            "PuntGPT",
            style: regular(
              color: AppColors.white,
              fontSize: 22.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipSlip(BuildContext context) {
    return OnMouseTap(
      onTap: () {
        indexOfWebTab.value = 3;
        WebRouter.indexedStackNavigationShell!.goBranch(3);
      },
      child: SizedBox(
        height: (20.sp.flexClamp(18, 22) * 1.2) + 25,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "Tip Slip",
                style: bold(
                  height: 1.2,
                  fontSize: 18.sp.flexClamp(16, 20),
                  color: AppColors.white,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "10",
                  style: semiBold(
                    fontSize: 12.sp.clamp(10, 12),
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerAd() {
    return Container(
      height: 55.h,
      width: context.isTablet
          ? 650.w
          : context.isMobileWeb
          ? 700.w
          : 200.w,
      // margin: EdgeInsets.symmetric(horizontal: (context.isMobileView) ? 200.w : 25.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        "Ad",
        style: regular(fontSize: (context.isMobileWeb) ? 30.sp : 16.sp),
      ),
    );
  }

  _navItem({
    VoidCallback? onTap,
    String? text,
    String? icon,
    bool? isSelected,
    Widget? child,
    Color? color,
  }) {
    return IntrinsicWidth(
      child: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          Center(
            child: OnMouseTap(
              onTap: onTap,
              child:
                  child ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      if (icon != null)
                        ImageWidget(
                          path: icon,
                          type: ImageType.svg,
                          color: color ?? AppColors.white,
                          height: 32.w.flexClamp(28, 36),
                        ),
                      Text(
                        text!,
                        textAlign: TextAlign.left,
                        style: medium(
                          fontSize: 13,
                          height: 1.5,
                          color: color ?? AppColors.white,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          (isSelected ?? false)
              ? Container(
                  color: color == AppColors.green
                      ? AppColors.green
                      : color == AppColors.premiumYellow
                      ? AppColors.premiumYellow
                      : Colors.white,
                  height: 4,
                  width: double.infinity,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
