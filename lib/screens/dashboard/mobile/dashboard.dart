import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/utils/app_toast.dart';
import 'package:puntgpt_nick/core/widgets/image_widget.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/classic_form/classic_form_guide_provider.dart';
import 'package:puntgpt_nick/provider/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/dashboard/mobile/widgets/dashboard_app_bar.dart';
import 'package:puntgpt_nick/screens/offline/widget/offline_view.dart';
import 'package:puntgpt_nick/service/subscription/subscription_service.dart';

import '../../../core/router/app/app_router.dart';
import '../../../provider/subscription/subscription_provider.dart';

final GlobalKey<_DashboardState> dashboardKey = GlobalKey<_DashboardState>();
ValueNotifier<int> indexOfTab = ValueNotifier(0);

class Dashboard extends StatefulWidget {
  Dashboard({required this.navigationShell}) : super(key: dashboardKey);

  final StatefulNavigationShell navigationShell;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callInitAPIs(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      // extendBody: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            DashboardAppBar(navigationShell: widget.navigationShell),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: isNetworkConnected,
                builder: (context, value, child) {
                  if (value) {
                    return ValueListenableBuilder<int>(
                      valueListenable: indexOfTab,
                      builder: (context, value, child) => FadeInUp(
                        from: 2,
                        duration: Duration(milliseconds: 450),
                        key: ValueKey(value),
                        child: widget.navigationShell,
                      ),
                    );
                  }
                  return offlineView();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.screenWidth,
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(
              15,
              15,
              15,
              context.bottomPadding + 15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15.w,
              children: [
                _navItem(
                  onTap: () {
                    indexOfTab.value = 0;
                    AppRouter.indexedStackNavigationShell?.goBranch(0);
                  },
                  text: "Subscribe to\nPro Punter",
                  icon: AppAssets.trophy,
                  color: AppColors.premiumYellow,
                  index: 0,
                ),
                _navItem(
                  onTap: () {
                    indexOfTab.value = 1;
                    AppRouter.indexedStackNavigationShell?.goBranch(1);
                  },
                  text: "PuntGPT Punter Club",
                  icon: AppAssets.group,

                  hasLock: false,
                  index: 1,
                ),
                _navItem(
                  onTap: () {
                    indexOfTab.value = 2;
                    AppRouter.indexedStackNavigationShell?.goBranch(2);
                  },
                  text: "Bookies",
                  icon: AppAssets.bookings,
                  color: AppColors.green,
                  index: 2,
                ),
                _navItem(
                  onTap: () {
                    indexOfTab.value = 3;
                    AppRouter.indexedStackNavigationShell?.goBranch(3);
                  },
                  text: "Account",
                  icon: AppAssets.profile,
                  index: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _navItem({
    required VoidCallback onTap,
    required String text,
    required String icon,
    required int index,
    Color? color,
    bool hasLock = false,
  }) {
    // log(AppRouter.indexedStackNavigationShell!.currentIndex.toString());
    final currentIndex = AppRouter.indexedStackNavigationShell?.currentIndex;
    final opacity = 0.62;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                ImageWidget(
                  path: icon,
                  type: ImageType.svg,
                  color:
                      color?.withValues(
                        alpha: currentIndex == index ? 1 : opacity,
                      ) ??
                      AppColors.white.withValues(
                        alpha: currentIndex == index ? 1 : opacity,
                      ),
                  height: 32.w.flexClamp(28, 36),
                ),
                if (hasLock) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 32.w.flexClamp(28, 36),
                        width: 32.w.flexClamp(28, 36),
                      ),
                      ImageWidget(
                        path: AppAssets.lock,
                        type: ImageType.svg,
                        color:
                            color?.withValues(
                              alpha: currentIndex == index ? 1 : opacity,
                            ) ??
                            AppColors.white.withValues(
                              alpha: currentIndex == index ? 1 : opacity,
                            ),
                        height: 16.w.flexClamp(14, 18),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: medium(
                fontSize: 12.twelveSp(context),
                color:
                    color?.withValues(
                      alpha: currentIndex == index ? 1 : opacity,
                    ) ??
                    AppColors.white.withValues(
                      alpha: currentIndex == index ? 1 : opacity,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void callInitAPIs({required BuildContext context}) {
  final accountProvider = context.read<AccountProvider>();
  final searchEngineProvider = context.read<SearchEngineProvider>();
  final classicFormGuideProvider = context.read<ClassicFormGuideProvider>();
  Future.wait([
    accountProvider.getProfile(),
    accountProvider.getSubscriptionPlans(
      onFailed: (error) {
        AppToast.error(context: context, message: error);
      },
    ),
    searchEngineProvider.getTrackDetails(),
    searchEngineProvider.getDistanceDetails(),
    searchEngineProvider.getBarrierDetails(),
    classicFormGuideProvider.getClassicFormGuide(),
    classicFormGuideProvider.getNextToGo(),

    // classicFormGuideProvider.getPunterClub(),
    SubscriptionService.instance.initialize(
      provider: context.read<SubscriptionProvider>(),
      context: context,
    ),
  ]);
}
