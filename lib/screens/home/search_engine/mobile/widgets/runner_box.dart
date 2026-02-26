import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/runner_model.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';

class RunnerBox extends StatelessWidget {
  const RunnerBox({super.key, required this.runner, required this.onAddToTipSlip, required this.onCompareToField});
  final RunnerModel runner;
  final VoidCallback onAddToTipSlip;
  final VoidCallback onCompareToField;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* first row section
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 12, 8.w, 3),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          // isChecked
                          //     ? Colors.green
                          //     :
                          AppColors.primary.setOpacity(0.15),
                    ),
                    color: Colors
                        .transparent, //isChecked ? Colors.green : Colors.transparent,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                  // isChecked
                  //     ? const Icon(Icons.check, color: Colors.white, size: 16)
                  //     : null,
                ),
                15.horizontalSpace,
                Text(
                  "${runner.barrier?.toString() ?? '-'}. ",
                  style: bold(fontSize: 18.sp),
                ),
                if ((runner.silksImage ?? '').isNotEmpty)
                  ImageWidget(
                    path: runner.silksImage!,
                    type: ImageType.svg,
                    height: 24.w,
                  ),
                if ((runner.silksImage ?? '').isNotEmpty) 4.horizontalSpace,
                Text(
                  runner.horseName ?? '-',
                  style: semiBold(fontSize: 18.sp),
                ),
                Spacer(),
                Text("\$${runner.odds ?? '-'}", style: bold(fontSize: 18.sp)),
              ],
            ),
          ),
          Divider(color: AppColors.greyColor.withValues(alpha: 0.15)),
          //*----------- second row section
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6, 8.w, 2),
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.start,
                  "${runner.jumpTimeAu?.split(" ").first ?? '-'}\n${DateFormatter.formatTimeFromString(runner.jumpTimeAu)}",
                  style: medium(fontSize: 16.sp),
                ),

                Text(runner.trainerName ?? '-', style: medium(fontSize: 16.sp)),
              ],
            ),
          ),
          Divider(color: AppColors.greyColor.withValues(alpha: 0.15)),
          //*----------- third row section
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6, 8.w, 2),
            child: Text("Odds may differ with:", style: bold(fontSize: 16.sp)),
          ),
          // Divider(color: AppColors.greyColor.withValues(alpha: 0.15)),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
          //   child: Text(
          //     "Next race ${runner.nextRaceRemainTime}",
          //     style: medium(fontSize: 16.sp),
          //   ),
          // ),
          Divider(color: AppColors.greyColor.withValues(alpha: 0.15)),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6, 8.w, 16),
            child: Row(
              spacing: 6.w,
              children: [
                Expanded(
                  child: AppFilledButton(
                    text: "Add to Tip Slip",
                    textStyle: semiBold(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 6.w,
                    ),
                      onTap: onAddToTipSlip,
                      // child: progressIndicator(),
                    child: _isThisRunnerLoading(context) ? progressIndicator() : null,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(22.w, 5.h, 22.w, 25.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.greyColor.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    14.w,
                                    18.h,
                                    14.w,
                                    12.h,
                                  ),
                                  child: Text(
                                    "Analysis and Field Comparison",
                                    style: semiBold(fontSize: 16.sp),
                                  ),
                                ),
                                Divider(
                                  color: AppColors.greyColor.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    22.w,
                                    10.h,
                                    22.w,
                                    16.h,
                                  ),
                                  child: Text(
                                    "‘Delicacy’ @8.50  might offer value as a top 3 contender, especially if the favourite gets caught wide or overworks early. Look for signs like a strong final 400m that it's shown in recent form. I like your simple formula, not overthinking things. Keep in mind the favourite, ‘Makybe Diva’ is short odds @2.10 I can take you to the manual form guide for a look at the other runners in this race?",
                                    style: regular(fontSize: 16.sp),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 8.w,
                      ),
                      // padding: EdgeInsets.symmetric(
                      //   vertical: 8.h,
                      //   horizontal: 6.w,
                      // ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageWidget(path: AppAssets.horse, height: 24.w),
                          Expanded(
                            child: Text(
                              "Compare to field",
                              textAlign: TextAlign.center,
                              style: bold(fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isThisRunnerLoading(BuildContext context) {
    final provider = context.read<SearchEngineProvider>();
    return provider.isCreatingTipSlip &&
        provider.creatingForSelectionId == runner.selectionId?.toString();
  }
}
