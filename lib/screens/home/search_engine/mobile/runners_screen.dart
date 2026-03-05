import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/runner_box.dart';
import 'home_screen.dart';

class RunnersListScreen extends StatelessWidget {
  const RunnersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return  _runnerShimmer();

    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        final runners = provider.runnersList;
        if (provider.runnersList == null) {
          return HomeSectionShimmers.runnerShimmer();
        }

        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 16.w, 25.w, 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Runners: (${runners?.length ?? 0})",
                        style: bold(fontSize: 16.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.savedSearchedScreen.name);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageWidget(
                              type: ImageType.svg,
                              path: AppAssets.bookmark,
                              height: 16.w.flexClamp(14, 18),
                            ),
                            SizedBox(width: 5),
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
                              padding: EdgeInsets.only(bottom: 95.w),
                              itemCount: runners.length,
                              itemBuilder: (context, index) {
                                final runner = runners[index];
                                return RunnerBox(
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
                                          message:
                                              "Search saved successfully",
                                        );
                                      },
                                    );
                                  },
                                  onAddToTipSlip: () {
                                    provider.createTipSlip(
                                      selectionId:
                                          runner.selectionId?.toString() ??
                                          '',
                                      context: context,
                                    );
                                  },
                                  onCompareToField: () {
                                    provider.compareHorses(
                                      selectionId:
                                          runner.selectionId?.toString() ??
                                          '',
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
                                child: askPuntGPTButton(context),
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
            if (provider.isCreatingSaveSearch) FullPageIndicator(),
          ],
        );
      },
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
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
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
