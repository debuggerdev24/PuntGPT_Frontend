import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/next_race_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_screen_tab.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/race_start_timing_options.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
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
    return PopScope(
      canPop: context.watch<SearchEngineProvider>().isSearched ? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (context.read<SearchEngineProvider>().isSearched) {
          context.read<SearchEngineProvider>().setIsSearched(value: false);
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        body: Consumer<SearchEngineProvider>(
          builder: (context, provider, child) {
            if (provider.trackDetails == null ||
                provider.distanceDetails == null) {
              return HomeSectionShimmers.homeScreenShimmer(context: context);
            }
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 16.w, 25.w, 0),
                  child: HomeScreenTab(selectedIndex: provider.selectedTab),
                ),
                16.w.verticalSpace,
                Expanded(
                  child: FadeInUp(
                    from: 1,
                    key: ValueKey(provider.selectedTab),
                    child: (provider.selectedTab == 0)
                        ? Stack(
                            children: [
                              puntGptSearchEngineView(
                                provider: provider,
                                formKey: formKey,
                                context: context,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: askPuntGPTButton(
                                  context: context,
                                  margin: EdgeInsets.only(
                                    right: 18.w,
                                    bottom: 18.w,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Consumer<ClassicFormProvider>(
                            builder: (context, provider, child) =>
                                provider.classicFormGuide == null
                                ? HomeSectionShimmers.classicFormGuideShimmer(
                                    context: context,
                                  )
                                : Stack(
                                    children: [
                                      classicFormGuideView(
                                        context: context,
                                        provider: provider,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: askPuntGPTButton(
                                          context: context,
                                          margin: EdgeInsets.only(
                                            right: 18.w,
                                            bottom: 18.w,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget classicFormGuideView({
    required BuildContext context,
    required ClassicFormProvider provider,
  }) {
    final nextRaces = provider.nextRaceList;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Next to go", style: bold(fontSize: 16.sp)),
          10.w.verticalSpace,

          //* Next to go list
          nextRaces.isEmpty
              ? _buildNextToGoEmptyState(context: context)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8.w,
                      children: List.generate(
                        nextRaces.length,
                        (index) => nextToGoItem(nextRace: nextRaces[index]),
                      ),
                    ),
                  ),
                ),
          //* Days list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(provider.days.length, (index) {
                return GestureDetector(
                  onTap: () {
                    provider.changeSelectedDay = index;
                  },
                  child: AnimatedContainer(
                    duration: 400.milliseconds,
                    margin: EdgeInsets.only(
                      top: 24.w,
                      bottom: 16.w,
                      right: 8.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.w,
                      horizontal: 18.w,
                    ),
                    decoration: BoxDecoration(
                      color: (provider.selectedDay == index)
                          ? AppColors.primary
                          : null,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      provider.days[index].value,
                      style: semiBold(
                        fontSize: 16.sp,
                        color: (provider.selectedDay == index)
                            ? AppColors.white
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          //* Race table
          provider.classicFormGuide!.isEmpty
              ? _buildRaceTableEmptyState(
                  context: context,
                  provider: provider,
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 1.4.sw,
                    margin: EdgeInsets.only(bottom: 55.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      columnWidths: {
                        0: FlexColumnWidth(3.w),
                        // 1: FlexColumnWidth(1.w),
                        1: FlexColumnWidth(2.w),
                        2: FlexColumnWidth(2.w),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: List.generate(provider.classicFormGuide!.length, (
                        index,
                      ) {
                        final classicForm = provider.classicFormGuide![index];
                        return _buildRow(
                          col1: classicForm.meetingName,
                          // col2: "",
                          col3: classicForm.meetingDate,
                          col4: classicForm.meetingAustralianTime,
                          onTap: () {
                            provider.getMeetingRaceList(
                              meetingId: classicForm.meetingId.toString(),
                            );
                            provider.getRaceFieldDetail(
                              id: classicForm
                                  .races[provider.selectedRace].raceId
                                  .toString(),
                            );
                            context.pushNamed(AppRoutes.selectedRace.name);
                          },
                        );
                      }),
                //   _buildRow(
                //     col1: "Flemington",
                //     col2: "R2. Race Sponsor",
                //     col3: "2025-09-28",
                //     col4: "14:35",
                //     onTap: () {
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //     },
                //   ),
                //   _buildRow(
                //     col1: "Morphettville",
                //     col2: "R3. Race Sponsor",
                //     col3: "2025-09-28",
                //     col4: "14:35",
                //     onTap: () {
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //     },
                //   ),
                //   _buildRow(
                //     col1: "Doomben",
                //     col2: "R4. Race Sponsor",
                //     col3: "2025-09-28",
                //     col4: "14:35",
                //     onTap: () {
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //     },
                //   ),
                //   _buildRow(
                //     col1: "Gold Coast",
                //     col2: "R5. Race Sponsor",
                //     col3: "2025-09-28",
                //     col4: "14:35",
                //     onTap: () {
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //     },
                //   ),
                //   _buildRow(
                //     col1: "Ascot",
                //     col2: "R6. Race Sponsor",
                //     col3: "2025-09-28",
                //     col4: "14:35",
                //     onTap: () {
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //     },
                //   ),
                //   _buildRow(
                //     col1: "Newcastle",
                //     col2: "R7. Race Sponsor",
                //     col3: "2025-09-28",
                //     col4: "14:35",
                //     onTap: () {
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //     },
                //   ),
                //   _buildRow(
                //     col1: "etc...",
                //     col2: "etc...",
                //     col3: "etc...",
                //     col4: "etc...",
                //     onTap: () {
                //       context.pushNamed(AppRoutes.selectedRace.name);
                //     },
                //   ),
                // ],
              ),
            ),
          ),

          25.w.verticalSpace,
        ],
      ),
    );
  }

  Widget puntGptSearchEngineView({
    required SearchEngineProvider provider,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) {
    return Column(
      spacing: 16,
      children: [
        //* timing buttons
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.w),
            child: Column(
              children: [
                // if (provider.isSearched)
                //   RunnersListScreen(runnerData: provider.runnerData)
                // else
                // ...[
                RaceStartTimingOptions(),
                SearchFields(providerh: provider),
                // ],
                20.w.verticalSpace,
                IntrinsicWidth(
                  child: AppFilledButton(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    text: "Search",
                    textStyle: semiBold(
                      fontSize: 16.sixteenSp(context),
                      color: AppColors.white,
                    ),

                    onTap: () {
                      context.pushNamed(AppRoutes.runnersScreen.name);
                      provider.getSearchEngine(
                        onSuccess: () {
                          // AppToast.success(context: context, message: "Search successful");
                        },
                      );
                      // provider.createSaveSearch(
                      //   onError: (error) {
                      //     AppToast.error(context: context, message: error);
                      //   },
                      //   onSuccess: () {
                      //     AppToast.success(
                      //       context: context,
                      //       message: "Search saved successfully",
                      //     );
                      //   },
                      // );
                    },
                  ),
                ),
                // if (!provider.isSearched) ...[

                // ],
              ],
            ),
          ),
        ),
        // if (provider.isSearched)
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 20),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [],
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  TableRow _buildRow({
    required String col1,
    // required String col2,
    required String col3,
    required String col4,
    required VoidCallback onTap,
  }) {
    return TableRow(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
            child: Text(col1, style: semiBold(fontSize: 16.sp)),
          ),
        ),
        // GestureDetector(
        //   onTap: onTap,
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),

        //     child: Text(col2, style: semiBold(fontSize: 16.sp)),
        //   ),
        // ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
            child: Text(col3, style: semiBold(fontSize: 16.sp)),
          ),
        ),

        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
            child: Text(col4, style: semiBold(fontSize: 16.sp)),
          ),
        ),
      ],
    );
  }

  Widget _buildNextToGoEmptyState({required BuildContext context}) {
    return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 4.w),
          padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.03),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flag_outlined,
                size: 22.sp,
                color: AppColors.primary.withValues(alpha: 0.45),
              ),
              10.w.horizontalSpace,
              Text(
                "NO races found",
                style: semiBold(
                  fontSize: 15.sp,
                  fontFamily: AppFontFamily.secondary,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  /// Shown when the classic form guide has no meetings for the selected day.
  Widget _buildRaceTableEmptyState({
    required BuildContext context,
    required ClassicFormProvider provider,
  }) {
    final dayLabel =
        provider.days[provider.selectedDay].value.toLowerCase();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 55.w),
      padding: EdgeInsets.symmetric(vertical: 28.w, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.03),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.green.withValues(alpha: 0.22),
              ),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 30.sp,
              color: AppColors.primary.withValues(alpha: 0.55),
            ),
          ),
          14.w.verticalSpace,
          Text(
            "No races for $dayLabel",
            style: semiBold(
              fontSize: 16.sp,
              fontFamily: AppFontFamily.secondary,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms)
        .slideY(
          begin: 0.04,
          end: 0,
          duration: 350.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget nextToGoItem({required NextRaceModel nextRace}) {
    return Container(
      width: 240.w,
      padding: EdgeInsets.fromLTRB(16.w, 12.w, 14.w, 14.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nextRace.trackName, style: semiBold(fontSize: 16.sp)),
          6.w.verticalSpace,
          Row(
            // spacing: 85.w,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  nextRace.raceName,
                  style: semiBold(
                    fontSize: 14.sp,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Text(
                "13:15",
                style: semiBold(
                  fontSize: 14.sp,
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

Widget askPuntGPTButton({
  required BuildContext context,
  EdgeInsets? margin,
}) {
  return GestureDetector(
    onTap: () {
      // if(){
      context.pushNamed(
        // kIsWeb &&
        (kIsWeb) ? WebRoutes.askPuntGptScreen.name : AppRoutes.askPuntGpt.name,
      );
      // }
    },
    child: Container(
      margin: margin,
      padding: EdgeInsets.symmetric(
        vertical: 12.r.flexClamp(12, 15),
        horizontal: 15.r.flexClamp(15, 18),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            offset: Offset(0, 6),
            blurRadius: 8,
          ),
        ],
        color: AppColors.white,
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(
            path: AppAssets.horse,
            height: (context.isBrowserMobile) ? 42.w : 30.w,
          ),
          10.w.horizontalSpace,
          Text(
            "Ask @ PuntGPT",
            textAlign: TextAlign.center,
            style: semiBold(
              fontSize: (context.isBrowserMobile) ? 38.sp : 20.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
        ],
      ),
    ),
  );
}
