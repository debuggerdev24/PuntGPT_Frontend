import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/runner_box.dart';
import 'home_screen.dart';

class RunnersListScreen extends StatefulWidget {
  const RunnersListScreen({super.key});

  @override
  State<RunnersListScreen> createState() => _RunnersListScreenState();
}

class _RunnersListScreenState extends State<RunnersListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<SearchEngineProvider>();
    if (!provider.hasMoreRunners || provider.isLoadingMoreRunners) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.loadNextRunners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        final runners = provider.runnersList;
        if (provider.runnersList == null) {
          return HomeSectionShimmers.runnerShimmer();
        }
        final totalDisplay = provider.totalRunners ?? runners!.length;
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(3.w, 0.w, 25.w, 0.w),
                  child: Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(Icons.arrow_back_ios_rounded, size: 20.w),
                      ),
                      // Spacer(),
                      Text(
                        "Total Runners: ($totalDisplay)",
                        style: bold(fontSize: 16.sp),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          provider.getAllSaveSearch();
                          context.pushNamed(AppRoutes.savedSearchedScreen.name);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5,
                          children: [
                            ImageWidget(
                              type: ImageType.svg,
                              path: AppAssets.bookmark,
                              height: 16.w.flexClamp(14, 18),
                            ),

                            Text(
                              "Saved Searches",
                              style: bold(
                                fontSize: 16.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: (runners!.isEmpty)
                      ? _buildNoRunnersEmptyState(context)
                      : Stack(
                          children: [
                            ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.only(bottom: 95.w),
                              itemCount:
                                  runners.length +
                                  (provider.isLoadingMoreRunners ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= runners.length) {
                                  return _buildBottomLoadingShimmer(context);
                                }
                                final runner = runners[index];
                                return RunnerBox(
                                  index: index + 1,
                                  runner: runner,
                                  onAddToSaveSearch: (name, dialogContext) {
                                    context.pop(dialogContext);
                                    provider.createSaveSearch(
                                      name: name,
                                      onError: (error) {
                                        AppToast.error(
                                          context: context,
                                          message: error,
                                        );
                                      },
                                      onSuccess: () {
                                        AppToast.success(
                                          context: context,
                                          message: "Search saved successfully",
                                        );
                                      },
                                    );
                                  },
                                  onAddToTipSlip: () {
                                    provider.createTipSlip(
                                      selectionId:
                                          runner.selectionId?.toString() ?? '',
                                      context: context,
                                    );
                                  },
                                  onCompareToField: () {
                                    provider.compareHorses(
                                      selectionId:
                                          runner.selectionId?.toString() ?? '',
                                    );
                                  },
                                  onOpenClassicFormGuide: () async {
                                    final classicForm = context
                                        .read<ClassicFormProvider>();
                                    classicForm.setTempLoading = true;
                                    await classicForm.getClassicFormGuide();

                                    Future.wait([
                                      classicForm.getMeetingRaceList(
                                        meetingId: classicForm
                                            .classicFormGuide![0]
                                            .meetingId
                                            .toString(),
                                      ),
                                      classicForm.getRaceFieldDetail(
                                        id: runner.raceId?.toString() ?? '',
                                      ),
                                    ]);
                                    classicForm.setTempLoading = false;

                                    context.pushNamed(
                                      AppRoutes.selectedRace.name,
                                    );
                                  },
                                );
                              },
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 25.w,
                                  bottom: 30.h,
                                ),
                                child: askPuntGPTButton(context: context),
                              ),
                            ),
                          ],
                        ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: GestureDetector(
                //     onTap: () {
                //       context.pushNamed(AppRoutes.searchFilter.name);
                //     },
                //     child: Container(
                //       decoration: BoxDecoration(color: AppColors.white),
                //       alignment: AlignmentDirectional.bottomCenter,
                //       padding: EdgeInsets.only(bottom: 14.h),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         spacing: 4,
                //         children: [
                //           ImageWidget(
                //             type: ImageType.svg,
                //             path: AppAssets.filter,
                //             height: 20.w.flexClamp(18, 22),
                //           ),
                //           Text("Filter", style: medium(fontSize: 16.sp)),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),

            if (provider.isCreatingSaveSearch ||
                context.watch<ClassicFormProvider>().tempLoading)
              FullPageIndicator(),
          ],
        );
      },
    );
  }

  Widget _buildBottomLoadingShimmer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 16.w, 25.w, 24.w),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 14.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 12.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 48.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoRunnersEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all((context.isBrowserMobile) ? 28.w : 22.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: (context.isBrowserMobile) ? 64.sp : 48.sp,
                color: AppColors.primary.withValues(alpha: 0.45),
              ),
            ),
            24.h.verticalSpace,
            Text(
              "No runners found",
              style: semiBold(
                fontSize: (context.isBrowserMobile) ? 28.sp : 18.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            12.h.verticalSpace,
            Text(
              "No horses match your current search criteria. Try adjusting your filters or track selection to see more results.",
              style: regular(
                fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            28.h.verticalSpace,
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: Icon(Icons.tune_rounded, size: 20.sp),
              label: Text(
                "Adjust search filters",
                style: semiBold(fontSize: 14.sp, color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
