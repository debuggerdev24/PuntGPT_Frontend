import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/router/web/web_router.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/dashboard/web/widgets/web_dashboard_app_bar.dart';
import 'package:puntgpt_nick/screens/offline/widget/offline_view.dart';

import '../../../core/constants/text_style.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/on_button_tap.dart';
import '../../../provider/account/account_provider.dart';
import '../../../provider/home/search_engine/search_engine_provider.dart';
import '../mobile/dashboard.dart';

ValueNotifier<int> indexOfWebTab = ValueNotifier<int>(2);

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callInitAPIs(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger.info(
      "is Physical Mobile ${context.isPhysicalMobile} ${context.screenWidth}",
    );
    Logger.info(
      "is Browser Mobile  ${context.isBrowserMobile} ${context.screenWidth}",
    );
    Logger.info("is Tablet ${context.isTablet} ${context.screenWidth}");
    Logger.info("is Desktop ${context.isDesktop} ${context.screenWidth}");
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder<bool>(
          valueListenable: isNetworkConnected,
          builder: (context, value, child) {
            if (value) {
              return Consumer<SearchEngineProvider>(
                builder: (context, provider, child) {
                  // Logger.info(
                  //   "panel status : ${provider.isMenuOpen.toString()}",
                  // );
                  return Column(
                    children: [
                      WebDashboardAppBar(
                        navigationShell: widget.navigationShell,
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            ValueListenableBuilder<int>(
                              valueListenable: indexOfWebTab,
                              builder: (context, value, child) {
                                return FadeInUp(
                                  from: 10,
                                  key: ValueKey(value),
                                  child: widget.navigationShell,
                                );
                              },
                            ),
                            //todo menu bar
                            if (provider.isMenuOpen && !context.isDesktop)
                              _buildMenuPanel(context, provider),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return offlineView();
          },
        ),
      ),
    );
  }

  // Widget _appLogo(BuildContext context) {
  //   return OnMouseTap(
  //     onTap: () {
  //       WebRouter.indexedStackNavigationShell!.goBranch(2);
  //       indexOfWebTab.value = 2;
  //     },
  //     child: _appLogoContent(context),
  //   );
  // }

  Widget _appLogoContent(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.isTablet ? 20.w : 28.w,
      children: [
        ImageWidget(
          type: ImageType.svg,
          path: AppAssets.webLogo,
          color: AppColors.white,
          height: context.isTablet
              ? 42.w
              : (context.isBrowserMobile)
              ? 58.w
              : 30.w,
        ),
        Text(
          "Dashboard",
          style: regular(
            color: AppColors.white,
            fontSize: context.isTablet
                ? 22.sp
                : (context.isBrowserMobile)
                ? 35.sp
                : 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuPanel(BuildContext context, SearchEngineProvider provider) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.primary,

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: context.isTablet
            ? 24.w
            : (context.isBrowserMobile)
            ? 30.w
            : 6.5.h,
        children: [
          _menuItem(
            onTap: () {
              Logger.info("Before: ${provider.isMenuOpen}");
              indexOfWebTab.value = 2;
              WebRouter.indexedStackNavigationShell!.goBranch(2);
              provider.setIsMenuOpen = false;
              Logger.info("After: ${provider.isMenuOpen}");
            },
            child: _appLogoContent(context),
            text: "Subscribe to Pro Punter",
            icon: AppAssets.trophy,
            index: 2,
            context: context,
          ),
          _menuItem(
            onTap: () {
              indexOfWebTab.value = 5;
              context.read<AccountProvider>().setAccountTabIndex = 1;
              WebRouter.indexedStackNavigationShell!.goBranch(4);
              provider.setIsMenuOpen = false;
            },
            text: "Subscribe to Pro Punter",
            icon: AppAssets.trophy,
            color: AppColors.premiumYellow,
            index: 5,
            context: context,
          ),
          _menuItem(
            onTap: () {
              indexOfWebTab.value = 1;
              WebRouter.indexedStackNavigationShell?.goBranch(1);
              provider.setIsMenuOpen = false;
            },
            text: "PuntGPT Punter Club",
            icon: AppAssets.group,
            index: 1,
            context: context,
          ),
          _menuItem(
            onTap: () {
              indexOfWebTab.value = 0;
              WebRouter.indexedStackNavigationShell!.goBranch(0);
              provider.setIsMenuOpen = false;
            },
            text: "Bookies",
            icon: AppAssets.bookings,
            color: AppColors.green,
            index: 0,
            context: context,
          ),
          _menuItem(
            onTap: () {
              indexOfWebTab.value = 4;
              context.read<AccountProvider>().setAccountTabIndex = 0;

              WebRouter.indexedStackNavigationShell!.goBranch(4);
              provider.setIsMenuOpen = false;
            },
            text: "Account",
            icon: AppAssets.profile,
            index: 4,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required VoidCallback onTap,
    required String text,
    required String icon,
    required int index,
    required BuildContext context,
    Widget? child,
    Color? color,
  }) {
    final currentIndex = WebRouter.indexedStackNavigationShell?.currentIndex;
    final isSelected = currentIndex == index;

    return OnMouseTap(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppColors.white).withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            child ??
            Row(
              spacing: context.isTablet ? 20.w : 28.w,
              children: [
                ImageWidget(
                  path: icon,
                  type: ImageType.svg,
                  color: color ?? AppColors.white,
                  height: context.isTablet
                      ? 42.w
                      : (context.isBrowserMobile)
                      ? 58.w
                      : 32.w,
                ),
                Expanded(
                  child: Text(
                    text,
                    style: medium(
                      fontSize: context.isTablet
                          ? 22.sp
                          : (context.isBrowserMobile)
                          ? 35.sp
                          : 18.sp,
                      color: color ?? AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
