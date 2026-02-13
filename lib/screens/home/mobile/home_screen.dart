import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/enum/app_enums.dart';
import 'package:puntgpt_nick/core/router/web/web_routes.dart';
import 'package:puntgpt_nick/core/utils/app_toast.dart';
import 'package:puntgpt_nick/core/widgets/image_widget.dart';
import 'package:puntgpt_nick/models/classic_form_guide/next_race_model.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/search_section.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/home_screen_tab.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/race_start_timing_options.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/runners_list_screen.dart';
import '../../../core/router/app/app_routes.dart';
import '../../../core/widgets/app_filed_button.dart';
import '../../../provider/classic_form/classic_form_guide_provider.dart';
import '../../../provider/search_engine/search_engine_provider.dart';

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
              return homeScreenShimmer(context: context);
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
                        ? puntGptSearchEngine(
                            provider: provider,
                            formKey: formKey,
                            context: context,
                          )
                        : Consumer<ClassicFormGuideProvider>(
                            builder: (context, provider, child) =>
                                classicFormGuide(
                                  context: context,
                                  provider: provider,
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

  Widget classicFormGuide({
    required BuildContext context,
    required ClassicFormGuideProvider provider,
  }) {
    final nextRaces = provider.nextRaceList;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Next to go", style: bold(fontSize: 16.sp)),
          10.verticalSpace,
          SingleChildScrollView(
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
                      top: 24.h,
                      bottom: 16.h,
                      right: 8.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
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

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Container(
              width: 1.6.sw,
              margin: EdgeInsets.only(bottom: 55.h),
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
                  0: FlexColumnWidth(3.5.w),
                  1: FlexColumnWidth(6.w),
                  2: FlexColumnWidth(3.w),
                  3: FlexColumnWidth(3.w),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List.generate(provider.classicFormGuide.length, (
                  index,
                ) {
                  final classicForm = provider.classicFormGuide[index];
                  return _buildRow(
                    col1: classicForm.meetingName,
                    col2: "",
                    col3: classicForm.meetingDate,
                    col4: "14:35",
                    onTap: () {
                      provider.getMeetingRaceList(
                        meetingId: classicForm.meetingId.toString(),
                      );
                      provider.getRaceFieldDetail(
                        id: classicForm.races[provider.selectedRace].raceId
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
          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: askPuntGPTButton(context),
          ),
          25.h.verticalSpace,
        ],
      ),
    );
  }

  Widget puntGptSearchEngine({
    required SearchEngineProvider provider,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) {
    return Column(
      spacing: 16,
      children: [
        //todo timing buttons
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (provider.isSearched)
                  RunnersList(runnerData: provider.runnerData)
                else ...[
                  RaceStartTimingOptions(),
                  SearchView(providerh: provider),
                ],
                if (!provider.isSearched) ...[
                  20.verticalSpace,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: askPuntGPTButton(context),
                    ),
                  ),
                  IntrinsicWidth(
                    child: AppFilledButton(
                      margin: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10,
                      ),
                      text: "Search",
                      textStyle: semiBold(
                        fontSize: 16.sixteenSp(context),
                        color: AppColors.white,
                      ),
                      onTap: () {
                        // formKey.currentState!.validate();
                        provider.getSearchEngine(
                          onError: (error) {
                            AppToast.error(context: context, message: error);
                          },
                          onSuccess: () {
                            // Navigate to runners screen after data is loaded
                            if (provider.runnerData != null) {
                              context.pushNamed(
                                AppRoutes.runnersScreen.name,
                                extra: provider.runnerData,
                              );
                            }
                          },
                        );
                        provider.createSaveSearch(
                          onError: (error) {
                            AppToast.error(context: context, message: error);
                          },
                          onSuccess: () {
                            AppToast.success(
                              context: context,
                              message: "Search saved successfully",
                            );
                          },
                        );
                        // provider.setIsSearched(value: true);
                      },
                    ),
                  ),
                ],
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
    required String col2,
    required String col3,
    required String col4,
    required VoidCallback onTap,
  }) {
    return TableRow(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Text(col1, style: semiBold(fontSize: 16.sp)),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),

            child: Text(col2, style: semiBold(fontSize: 16.sp)),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Text(col3, style: semiBold(fontSize: 16.sp)),
          ),
        ),

        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Text(col4, style: semiBold(fontSize: 16.sp)),
          ),
        ),
      ],
    );
  }

  Widget nextToGoItem({required NextRaceModel nextRace}) {
    return Container(
      width: 240.w,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 14.w, 14.h),
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

Widget askPuntGPTButton(BuildContext context) {
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
          10.horizontalSpace,
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
