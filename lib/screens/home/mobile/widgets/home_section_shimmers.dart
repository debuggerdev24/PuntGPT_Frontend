import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puntgpt_nick/core/constants/app_colors.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer for the Search Detail screen (home_screen)
Widget homeScreenShimmer({required BuildContext context}) {
  final bodyHorizontalPadding = (context.isBrowserMobile) ? 50.w : 25.w;

  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Search for a horse..." title shimmer
          Padding(
            padding: EdgeInsets.fromLTRB(
              bodyHorizontalPadding,
              16.w,
              bodyHorizontalPadding,
              0,
            ),
            child: Container(
              width: (context.isBrowserMobile) ? 420.w : 220.w,
              height: (context.isBrowserMobile) ? 40.h : 18.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // "Total runners" row shimmer
          Padding(
            padding: EdgeInsets.fromLTRB(
              (context.isBrowserMobile) ? 50.w : 25.w,
              12.w,
              (context.isBrowserMobile) ? 50.w : 25.w,
              20.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (context.isBrowserMobile) ? 260.w : 140.w,
                  height: (context.isBrowserMobile) ? 32.h : 18.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: (context.isBrowserMobile) ? 260.w : 150.w,
                  height: (context.isBrowserMobile) ? 32.h : 18.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          horizontalDivider(),

          // Filters area shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: bodyHorizontalPadding),
            child: Column(
              children: [
                // Track dropdown shimmer
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.w),
                  height: (context.isBrowserMobile) ? 56.h : 46.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                horizontalDivider(),

                // First checkbox row shimmer (e.g. "Placed last start")
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 19.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (context.isBrowserMobile) ? 260.w : 160.w,
                        height: (context.isBrowserMobile) ? 32.h : 18.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: (context.isBrowserMobile) ? 40.sp : 22.sp,
                        height: (context.isBrowserMobile) ? 40.sp : 22.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalDivider(),

                // "Placed at distance" dropdown shimmer
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.w),
                  height: (context.isBrowserMobile) ? 56.h : 46.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                horizontalDivider(),

                // "Odds range" text field shimmer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Container(
                    height: (context.isBrowserMobile) ? 56.h : 46.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                horizontalDivider(),

                // Additional dropdown / text-field rows shimmer
                ...List.generate(4, (index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.w),
                        height: (context.isBrowserMobile) ? 56.h : 46.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      horizontalDivider(),
                    ],
                  );
                }),

                // Final checkbox row shimmer (e.g. "Won last start")
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (context.isBrowserMobile) ? 260.w : 160.w,
                        height: (context.isBrowserMobile) ? 32.h : 18.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: (context.isBrowserMobile) ? 40.sp : 22.sp,
                        height: (context.isBrowserMobile) ? 40.sp : 22.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalDivider(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget searchedItemShimmer({required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: (context.isBrowserMobile) ? 35.w : 25.w,
      vertical: (context.isBrowserMobile) ? 24.w : 14.h,
    ),
    child: Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Container(
                width: (context.isBrowserMobile) ? 200.w : 100.w,
                height: (context.isBrowserMobile) ? 40.h : 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 6.5.h),
              // Date shimmer
              Container(
                width: (context.isBrowserMobile) ? 150.w : 80.w,
                height: (context.isBrowserMobile) ? 30.h : 12.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 6.5.h),
              // Description shimmer
              Container(
                width: (context.isBrowserMobile) ? 350.w : 180.w,
                height: (context.isBrowserMobile) ? 40.h : 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          // Arrow icon shimmer
          Container(
            width: (context.isBrowserMobile) ? 40.w : 14.w,
            height: (context.isBrowserMobile) ? 40.w : 14.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Shimmer for the Search Detail screen (manage_saved_search)
Widget searchDetailShimmer({required BuildContext context}) {
  return Column(
    children: [
      // Top bar shimmer (back arrow + title + subtitle)
      Padding(
        padding: EdgeInsets.fromLTRB(5.w, 14.h, 25.w, 14.h),
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: Row(
            children: [
              24.w.horizontalSpace,
              // Back icon placeholder
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: (context.isBrowserMobile) ? 180.w : 120.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Subtitle placeholder
                  Container(
                    width: (context.isBrowserMobile) ? 220.w : 160.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Divider placeholder
      Container(height: 1, color: AppColors.shimmerBaseColor),
      // Body shimmer (track section + buttons)
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              // Track section shimmer (title + rows)
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    // "Track" title shimmer
                    Container(
                      width: 80.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Track rows shimmer
                    ...List.generate(3, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Label placeholder
                            Container(
                              width: 160.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            // Checkbox placeholder
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              // Edit button shimmer
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8.h),
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Delete button shimmer
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Shimmer for the Selected Race screen. Matches layout: top bar, race tabs (R1–R7),
/// sub-nav (Tips & Analysis, Speed Maps, Sectionals), and race table rows.
Widget selectedRaceScreenShimmer({required BuildContext context}) {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Top bar: back arrow + title + subtitle
        Padding(
          padding: EdgeInsets.fromLTRB(25.w, 16.w, 25.w, 20.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 220.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        horizontalDivider(opacity: 0.8),
        //* Race selection tabs (R1–R7)
        Container(
          margin: EdgeInsets.fromLTRB(25.w, 28.w, 25.w, 0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.shimmerBaseColor),
          ),
          child: Row(
            children: List.generate(7, (_) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),

        //* Sub-nav: Tips & Analysis | Speed Maps | Sectionals
        Container(
          margin: EdgeInsets.symmetric(vertical: 30.w, horizontal: 25.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.shimmerBaseColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (_) {
              return Container(
                width: 80.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
        //* Race table shimmer (rows matching horse list + W: J: F: T: column)
        //* Use SizedBox instead of Expanded: Expanded requires a Flex parent, but
        //* Shimmer wraps the child and breaks that ancestor chain.
        SizedBox(
          height: 320.h,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: SizedBox(
              height: 240.h,
              child: Container(
                width: 1.4.sw,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: List.generate(5, (index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.shimmerBaseColor.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Horse number + name placeholder
                          Expanded(
                            flex: 16,
                            child: Container(
                              height: 16.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // W: J: F: T: placeholder
                          Expanded(
                            flex: 30,
                            child: Container(
                              height: 14.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        // Ask @PuntGPT button placeholder
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 25.h, right: 25.w),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 48.h,
              width: 160.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
