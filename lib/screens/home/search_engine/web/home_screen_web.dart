import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/race_table.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/ask_puntgpt_screen_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/classic_form_guide_view_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_screen_tab_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/race_start_timing_option_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/search_section_web.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  bool _keyboardVisible = false;
  final ScrollController _webBodyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _webBodyScrollController.addListener(_onWebBodyScroll);
  }

  @override
  void dispose() {
    _webBodyScrollController.removeListener(_onWebBodyScroll);
    _webBodyScrollController.dispose();
    super.dispose();
  }

  void _onWebBodyScroll() {
    if (!mounted || !_webBodyScrollController.hasClients) return;
    final provider = context.read<SearchEngineProvider>();
    if (provider.selectedTab != 0 ||
        !provider.isSearched ||
        provider.runnersList == null) {
      return;
    }
    if (!provider.hasMoreRunners || provider.isLoadingMoreRunners) return;
    final pos = _webBodyScrollController.position;
    if (pos.maxScrollExtent > 0 && pos.pixels >= pos.maxScrollExtent - 200) {
      provider.loadNextRunners();
    }
  }

  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0.0;
    if (isVisible != _keyboardVisible) {
      setState(() => _keyboardVisible = isVisible);
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    if (context.isMobileWeb && isSheetOpen) {
      context.pop();
      isSheetOpen = false;
    }

    return PopScope(
      canPop: context.watch<SearchEngineProvider>().isSearched ? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (context.read<SearchEngineProvider>().isSearched) {
          context.read<SearchEngineProvider>().setIsSearched(value: false);
        }
      },
      child: Consumer<SearchEngineProvider>(
        builder:
            (
              BuildContext context,
              SearchEngineProvider provider,
              Widget? child,
            ) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!context.isMobileView)
                    SizedBox(height: 60)
                  else
                    SizedBox(height: 16),
                  Expanded(
                    child: webView(provider: provider, formKey: formKey),
                    //  (context.isMobileView)
                    //     ? mobileView(provider: provider, formKey: formKey)
                    //     : webView(provider: provider, formKey: formKey),
                  ),
                ],
              );
            },
      ),
    );
  }

  Widget mobileView({
    required SearchEngineProvider provider,
    required GlobalKey<FormState> formKey,
  }) {
    return FadeInUp(
      from: 1,
      key: ValueKey(provider.selectedTab),
      child: (provider.selectedTab == 0)
          ? Column(
              spacing: 16,
              children: [
                //* timing buttons
                RaceStartTimingOptionsWeb(),
                // Expanded(
                // child: SearchFields(providerh: provider),
                // (provider.isSearched)
                //     ? RunnersListWeb(runnersList: provider.runnersList!)
                //     : SearchFields(providerh: provider),
                // ),
                Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: (provider.isSearched)
                      ? GestureDetector(
                          onTap: () {
                            // context.pushNamed(AppRoutes.searchFilter.name);
                          },
                          child: IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(color: AppColors.white),
                              alignment: AlignmentDirectional.bottomCenter,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageWidget(
                                    type: ImageType.svg,
                                    path: AppAssets.filter,
                                    height: 20.w.flexClamp(18, 22),
                                  ),
                                  Text(
                                    "Filter",
                                    style: medium(fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              askPuntGPTButton(context: context),
                              10.verticalSpace,
                              IntrinsicWidth(
                                child: AppFilledButton(
                                  text: "Search",
                                  textStyle: semiBold(
                                    color: AppColors.white,
                                    fontSize: (context.isMobileWeb)
                                        ? 42.sp
                                        : 20.sp,
                                  ),
                                  onTap: () {
                                    // formKey.currentState!.validate();
                                    provider.setIsSearched(value: true);
                                  },
                                ),
                              ),
                              10.verticalSpace,
                            ],
                          ),
                        ),
                ),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Next to go",
                    //   style: bold(
                    //     fontSize: 20,
                    //   ),
                    // ),
                    10.h.verticalSpace,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8.w,
                        children: [
                          raceItem(context: context),
                          raceItem(context: context),
                        ],
                      ),
                    ),
                    RaceTable(),
                    Align(
                      alignment: AlignmentGeometry.bottomRight,
                      child: askPuntGPTButton(context: context),
                    ),
                    25.h.verticalSpace,
                  ],
                ),
              ),
            ),
    );
  }

  Widget webView({
    required SearchEngineProvider provider,
    required GlobalKey<FormState> formKey,
  }) {
    final bodyWidth = context.isMobileWeb
        ? 1.6.sw
        : context.isTablet
        ? 1300.w
        : 1100.w;
    // final sixteenResponsive = context.isDesktop
    //     ? 16.sp
    //     : context.isTablet
    //     ? 24.sp
    //     : (context.isMobileWeb)
    //     ? 32.sp
    //     : 16.sp;
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _webBodyScrollController,
          child: FadeInUp(
            curve: Curves.easeInOut,
            from: 4,
            key: ValueKey(provider.selectedTab),
            child: Column(
              children: [
                HomeScreenTabWeb(selectedIndex: provider.selectedTab),
                SizedBox(height: 16),
                (provider.selectedTab == 0)
                    ? Column(
                        spacing: 16,
                        children: [
                          //* timing buttons
                          RaceStartTimingOptionsWeb(),
                          //* search section mobile
                          SearchSectionWeb(formKey: formKey),
                        ],
                      )
                    : ClassicFormGuideViewWeb(bodyWidth: bodyWidth),
              ],
            ),
          ),
        ),
        //* ask punt gpt button web
        Align(
          alignment: Alignment.bottomRight,
          child: askPuntGPTButtonWeb(context: context),
        ),
      ],
    );
  }

  Widget raceItem({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Morphettville",
            style: semiBold(fontSize: (context.isMobileWeb) ? 32.sp : 16.sp),
          ),
          6.h.verticalSpace,
          Row(
            spacing: 85.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Race 1",
                style: semiBold(
                  fontSize: (context.isMobileWeb) ? 28.sp : 14.sp,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
              Text(
                "13:15",
                style: semiBold(
                  fontSize: (context.isMobileWeb) ? 28.sp : 14.sp,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

bool isSheetOpen = false;

Widget askPuntGPTButtonWeb({required BuildContext context}) {
  return OnMouseTap(
    onTap: () {
      if (context.isMobileView) {
        context.pushNamed(
          (!kIsWeb)
              ? WebRoutes.askPuntGptScreen.name
              : AppRoutes.askPuntGpt.name,
        );
        return;
      }
      isSheetOpen = true;
      showModalSideSheet(
        context: context,
        useRootNavigator: false,
        width: context.isDesktop ? 370 : 325,
        withCloseControll: true,

        body: const AskPuntGptScreenWeb(),
      );
    },
    child: Container(
      margin: EdgeInsets.only(
        bottom: 55,
        right: context.isMobileView ? 25.w : 100.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            offset: Offset(0, 6),
            blurRadius: 15,
          ),
        ],
        color: AppColors.white,
        border: Border.all(color: AppColors.primary),
      ),

      child: Row(
        spacing: 10.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(
            path: AppAssets.horse,
            height: context.isDesktop
                ? 34.w
                : context.isTablet
                ? 28.w
                : (context.isMobileWeb)
                ? 40.w
                : 30.w,
          ),
          // Image.asset(
          //   AppAssets.webNotification,
          //   color: Colors.black,
          //   height: context.isDesktop
          //       ? 34.w
          //       : context.isTablet
          //       ? 28.w
          //       : (context.isBrowserMobile)
          //       ? 40.w
          //       : 30.w,
          // ),
          Text(
            "Ask @ PuntGPT",
            textAlign: TextAlign.center,
            style: regular(
              fontSize: context.isDesktop
                  ? 18.sp
                  : context.isTablet
                  ? 25.sp
                  : (context.isMobileWeb)
                  ? 35.sp
                  : 20.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
        ],
      ),
    ),
  );
}
