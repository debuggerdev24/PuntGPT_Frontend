import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';
import 'package:puntgpt_nick/models/search_engine/runner_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/router/app/app_routes.dart';
import '../../../../core/widgets/image_widget.dart';
import '../home_screen.dart';

class RunnersList extends StatelessWidget {
  const RunnersList({super.key,required this.runnerData});

  final RunnerDataModel? runnerData;
  @override
  Widget build(BuildContext context) {
    // return  _runnerShimmer();
    final runners = runnerData?.runnersList;
      if(runnerData == null) {
        return _runnerShimmer();
      }
      if(runners!.isEmpty){
        // Use a SizedBox with height to ensure proper centering in scrollable context
        return Center(
          child: Text(
            "No runners found!",
            style: medium(fontSize: 16.sp),
          ),
        );
      }
      return Column(
      children:[
        Padding(
          padding: EdgeInsets.fromLTRB(25.w, 0.h, 25.w, 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Runners: (${runners.length})", style: bold(fontSize: 16.sp)),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.savedSearchedScreen);
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
        Stack(
          children: [

            
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: runners.length ,
              itemBuilder: (context, index) {
                  final runner = runners[index];
                  return Container(
                    margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.greyColor.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(12, 12, 12, 3),
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
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                // isChecked
                                //     ? const Icon(Icons.check, color: Colors.white, size: 16)
                                //     : null,
                              ),
                              15.horizontalSpace,
                              Text(
                                "${runner.raceNumber.toString()}. ",
                                style: bold(fontSize: 18.sp),
                              ),
                              Text(
                                runner.jockeyName,
                                style: semiBold(fontSize: 18.sp),
                              ),
                              Spacer(),
                              Text(

                                "\$${runner.odds}",
                                style: bold(fontSize: 18.sp),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColors.greyColor.withValues(alpha: 0.15),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${runner.jumpTimeAu}. ",
                                style: medium(fontSize: 16.sp),
                              ),
                              Text(
                                "${runner.raceNumber} Races",
                                style: medium(fontSize: 16.sp),
                              ),
                              Text(
                                
                                "runner.nextRaceRemainTime",
                                style: medium(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColors.greyColor.withValues(alpha: 0.15),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
                          child: Text(
                            "Odds may differ with:",
                            style: bold(fontSize: 16.sp),
                          ),
                        ),
                        // Divider(color: AppColors.greyColor.withValues(alpha: 0.15)),
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
                        //   child: Text(
                        //     "Next race ${runner.nextRaceRemainTime}",
                        //     style: medium(fontSize: 16.sp),
                        //   ),
                        // ),
                        Divider(
                          color: AppColors.greyColor.withValues(alpha: 0.15),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 6, 8, 16),
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
                                  onTap: () {},
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
                                          margin: EdgeInsets.fromLTRB(
                                            22.w,
                                            5.h,
                                            22.w,
                                            25.h,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.greyColor
                                                  .withValues(alpha: 0.15),
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
                                                  style: semiBold(
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: AppColors.greyColor
                                                    .withValues(alpha: 0.2),
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
                                                  style: regular(
                                                    fontSize: 16.sp,
                                                  ),
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
                                      border: Border.all(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ImageWidget(
                                          path: AppAssets.horse,
                                          height: 24.w,
                                        ),
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
        Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                context.push(AppRoutes.searchFilter);
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
    );
  
    }

  Widget _runnerShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.greyColor.withValues(alpha: 0.15),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with checkbox, name, and odds
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 3),
                    child: Row(
                      children: [
                        // Checkbox shimmer
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.greyColor.withValues(alpha: 0.15),
                            ),
                            color: Colors.white,
                          ),
                        ),
                        15.horizontalSpace,
                        // Race number shimmer
                        Container(
                          width: 30.w,
                          height: 18.h,
                          color: Colors.white,
                        ),
                        5.horizontalSpace,
                        // Jockey name shimmer
                        Container(
                          width: 120.w,
                          height: 18.h,
                          color: Colors.white,
                        ),
                        Spacer(),
                        // Odds shimmer
                        Container(
                          width: 60.w,
                          height: 18.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Divider(
                    color: AppColors.greyColor.withValues(alpha: 0.15),
                    height: 1,
                  ),
                  // Date/time info row
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                        Container(
                          width: 70.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                        Container(
                          width: 90.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Divider(
                    color: AppColors.greyColor.withValues(alpha: 0.15),
                    height: 1,
                  ),
                  // "Odds may differ with:" text shimmer
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
                    child: Container(
                      width: 150.w,
                      height: 16.h,
                      color: Colors.white,
                    ),
                  ),
                  // Divider
                  Divider(
                    color: AppColors.greyColor.withValues(alpha: 0.15),
                    height: 1,
                  ),
                  // Buttons section
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 6, 8, 16),
                    child: Row(
                      spacing: 6.w,
                      children: [
                        Expanded(
                          child: Container(
                            height: 44.h,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 44.h,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}
