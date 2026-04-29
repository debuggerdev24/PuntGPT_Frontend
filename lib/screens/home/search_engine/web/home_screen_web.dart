import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/race_table.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_section.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/chat_section_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_screen_tab_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/race_start_timing_option_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/race_table_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/runners_list_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/search_section_web.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
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

    if (isSearchDialogOpen && context.isMobileWeb) {
      context.pop();
      isSearchDialogOpen = false;
    }
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
                Expanded(
                  child: (provider.isSearched)
                      ? RunnersListWeb(runnersList: provider.runnersList!)
                      : SearchFields(providerh: provider),
                ),
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
                    : Center(
                        child: SizedBox(
                          width: bodyWidth,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Next to go", style: bold(fontSize: 16)),
                                SizedBox(height: 10,),

                                //* race list
                                ScrollConfiguration(
                                  behavior: const MaterialScrollBehavior().copyWith(
                                    dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                      PointerDeviceKind.trackpad,
                                      PointerDeviceKind.stylus,
                                      PointerDeviceKind.unknown,
                                    },
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        raceItemWeb(context: context),
                                        raceItemWeb(context: context),
                                        raceItemWeb(context: context),
                                        raceItemWeb(context: context),
                                        raceItemWeb(context: context),
                                        raceItemWeb(context: context),
                                        raceItemWeb(context: context),
                                        raceItemWeb(context: context),
                                      ],
                                    ),
                                  ),
                                ),
                                //* race table
                                RaceTableWeb(tableWidth: bodyWidth),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        //todo ask punt gpt button web
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

  Widget raceItemWeb({required BuildContext context}) {
    // final sixteenFontSize = context.isDesktop
    //     ? 16.sp
    //     : context.isTablet
    //     ? 24.sp
    //     : (context.isMobileWeb)
    //     ? 32.sp
    //     : 16.sp;
    // final fourteenFontSize = context.isDesktop
    //     ? 14.sp
    //     : context.isTablet
    //     ? 22.sp
    //     : (context.isMobileWeb)
    //     ? 30.sp
    //     : 14.sp;
    return Container(
      padding: EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Morphettville", style: semiBold(fontSize: 14)),
          SizedBox(height: 5),
          Row(
            spacing: 55,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Race 1",
                style: semiBold(
                  fontSize: 14    ,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
              Text(
                "13:15",
                style: semiBold(
                  fontSize: 14,
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
        width: context.isDesktop ? 450.w : 600.w,
        withCloseControll: true,
        body: askPuntGPTSheetView(context),
      );
    },
    child: Container(
      margin: EdgeInsets.only(
        bottom: 80.w,
        right: context.isMobileView ? 25.w : 100.w,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        //  context.isDesktop
        //     ? 10.w
        //     : context.isTablet
        //     ? 11.w
        //     : (context.isBrowserMobile)
        //     ? 16.w
        //     : 14.w,
        horizontal: 18,
        // context.isDesktop
        //     ? 18.w
        //     : context.isTablet
        //     ? 20.w
        //     : (context.isBrowserMobile)
        //     ? 22.w
        //     : 16.w,
      ),
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

Widget askPuntGPTSheetView(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 24.w, top: 12.w, bottom: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ask @PuntGPT",
              style: regular(
                fontSize: context.isDesktop ? 20.sp : 30.sp,
                fontFamily: AppFontFamily.secondary,
                height: 1.35,
              ),
            ),
            Text(
              "Chat with AI",
              style: medium(
                fontSize: context.isDesktop ? 12.sp : 22.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      horizontalDivider(),
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [ChatBubbleWeb(), ChatBubbleWeb()],
        ),
      ),
      horizontalDivider(),
      TextField(
        expands: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefix: SizedBox(width: 25.w),

          hintText: "Type your message...",
          hintStyle: medium(
            fontStyle: FontStyle.italic,
            fontSize: context.isDesktop ? 16.sp : 22.sp,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    ],
  );
}
