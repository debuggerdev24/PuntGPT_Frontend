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
          return runnerShimmer();
        }
        if (runners!.isEmpty) {
          return Center(
            child: Text("No runners found!", style: medium(fontSize: 16.sp)),
          );
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
                        "Total Runners: (${runners.length})",
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
                  child: Stack(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.only(bottom: 95.w),
                        itemCount: runners.length,
                        itemBuilder: (context, index) {
                          final runner = runners[index];
                          return RunnerBox(runner: runner,
                          onAddToTipSlip: () {
                            provider.createTipSlip(
                              selectionId: runner.selectionId?.toString() ?? '',
                              onError: (error) {
                                AppToast.error(context: context, message: error);
                              },
                              context: context,
                            );
                          },
                          onCompareToField: () {
                            // provider.setSelectedRunnerIndex = index;
                          },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 25.w, bottom: 30.h),
                          child: askPuntGPTButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.searchFilter.name);
                    },
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.white),
                      alignment: AlignmentDirectional.bottomCenter,
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          ImageWidget(
                            type: ImageType.svg,
                            path: AppAssets.filter,
                            height: 20.w.flexClamp(18, 22),
                          ),
                          Text("Filter", style: medium(fontSize: 16.sp)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // if(provider.isCreatingTipSlip)
            // FullPageIndicator()
          ],
        );
      },
    );
  }
}
