import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/dashboard/mobile/widgets/dashboard_app_bar.dart';
import 'package:puntgpt_nick/core/widgets/offline/widget/offline_view.dart';
import 'package:puntgpt_nick/services/app_startup/app_startup_coordinator.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: library_private_types_in_public_api
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppStartupCoordinator.startup(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      // extendBody: false,
      body: Column(
        children: [
          // 30.w.verticalSpace,
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
      bottomNavigationBar: ColoredBox(
        color: AppColors.primary,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.screenWidth,
                color: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 15.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _navItem(
                      onTap: () {
                        indexOfTab.value = 0;
                        AppRouter.indexedStackNavigationShell?.goBranch(0);
                      },

                      text: "Home",

                      icon: AppAssets.homeIcon,
                      hasLock: false,
                      index: 0,
                    ),
                    Consumer<SubscriptionProvider>(
                      builder: (context, subscriptionProvider, child) {
                        return _navItem(
                          onTap: () {
                            launchUrl(
                              Uri.parse("https://www.instagram.com/puntgpt/"),
                            );
                          },
                          text: "Instagram",
                          icon: AppAssets.instagramLogo,
                          color: AppColors.white,
                          index: -1,
                        );
                        // return _navItem(
                        //   onTap: () {
                        //     // indexOfTab.value = 0;
                        //     // AppRouter.indexedStackNavigationShell?.goBranch(0);
                        //   },
                        //   text: subscriptionProvider.isSubscribed
                        //       ? "Home"
                        //       : "Upgrade to\nPro Punter",
                        //   icon: AppAssets.trophy,
                        //   color: AppColors.premiumYellow,
                        //   index: 0,
                        // );
                      },
                    ),
                    _navItem(
                      onTap: () {
                        indexOfTab.value = 1;
                        AppRouter.indexedStackNavigationShell?.goBranch(1);
                        if (isGuest) return;
                        final provider = context.read<PuntClubProvider>();
                        provider.getChatGroups();
                        provider.getNotifications();
                      },

                      text: "PuntGPT Punters Club",
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
                        AppToast.info(context: context, message: 'Coming soon');
                      },
                      text: "News, Tips & Content",
                      icon: AppAssets.news,
                      index: -2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    String? tooltipMessage,
  }) {
    final currentIndex = AppRouter.indexedStackNavigationShell?.currentIndex;
    final opacity = 0.62;
    final bool isSvg = icon.contains(".svg");
    final Color inactiveColor =
        color?.withValues(alpha: currentIndex == index ? 1 : opacity) ??
        AppColors.white.withValues(alpha: currentIndex == index ? 1 : opacity);
    return Expanded(
      child: Tooltip(
        message: tooltipMessage ?? text,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(
            spacing: isSvg ? 2.w : 5.w,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageWidget(
                path: icon,
                type: isSvg ? ImageType.svg : ImageType.asset,
                color: inactiveColor,
                height: isSvg ? 28.w : 24.w,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: medium(
                  fontSize: 12.sp,
                  height: 1.11,
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
      ),
    );
  }
}
