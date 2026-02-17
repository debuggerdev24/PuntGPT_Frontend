import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puntgpt_nick/core/constants/app_colors.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

class PunterClubShimmers {
  // Shimmer for the Punter Club screen. Matches layout: top bar ("Your Punters Clubs:"
  /// + icons), divider, list of club rows, divider, empty area, and "Ask @ PuntGPT" FAB.
  static Widget punterClubScreenShimmer({required BuildContext context}) {
    final horizontalPadding = (context.isBrowserMobile) ? 35.w : 25.w;
    final listHorizontalPadding = 25.w;
    final listVerticalPadding = 20.h;

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top bar: group icon + title + bell + add
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 22.h,
            ),
            child: Row(
              children: [
                Container(
                  height: (context.isBrowserMobile) ? 42.w : 28.h,
                  width: (context.isBrowserMobile) ? 42.w : 28.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: (context.isBrowserMobile) ? 60.w : 12.w),
                Expanded(
                  child: Container(
                    height: (context.isBrowserMobile) ? 32.h : 22.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  height: 28,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  height: 28,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          horizontalDivider(),

          // Club list items (alternating like real UI)
          ...List.generate(5, (index) {
            final isAlternate = index % 2 == 1;
            return Container(
              decoration: BoxDecoration(
                color: isAlternate
                    ? AppColors.shimmerBaseColor.withValues(alpha: 0.4)
                    : null,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: listHorizontalPadding,
                vertical: listVerticalPadding,
              ),
              child: Row(
                children: [
                  Container(
                    height: (context.isBrowserMobile) ? 28.h : 18.h,
                    width: (context.isBrowserMobile) ? 180.w : 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          }),

          horizontalDivider(),

          const Spacer(),

          // Bottom: "Ask @ PuntGPT" FAB placeholder
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: Container(
                height: 48.h,
                width: (context.isBrowserMobile) ? 220.w : 160.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.shimmerBaseColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget notificationSheetShimmer({required BuildContext context}) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            // Title shimmer
            Container(
              margin: EdgeInsets.only(top: 8.h),
              height: 24.h,
              width: 160.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            16.h.verticalSpace,
            horizontalDivider(),
            // Body shimmer (notification list)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    19.h.verticalSpace,
                    ...List.generate(
                      3,
                      (_) => _notificationBoxShimmer(context),
                    ),
                  ],
                ),
              ),
            ),
            // Clear all button shimmer
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.redButton.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _notificationBoxShimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left icon shimmer
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              height: 24.w,
              width: 24.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text lines shimmer
                Container(
                  height: 16.h,
                  width: (context.isBrowserMobile) ? 260.w : 180.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 16.h,
                  width: (context.isBrowserMobile) ? 220.w : 150.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Buttons row shimmer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 32.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      height: 32.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 16.w,
                      width: 16.w,
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
        ],
      ),
    );
  }

  /// Shimmer for the Invite Users bottom sheet. Matches layout: back arrow,
  /// "Invite Users" title, divider, search bar, and repeating user rows
  /// (avatar + username + invite button).
  static Widget inviteUserSheetShimmer({required BuildContext context}) {
    final userHeight = (context.isBrowserMobile) ? 96.w : 48.w;
    final userWidth = (context.isBrowserMobile) ? 68.w : 48.w;

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 5, 25.w, 25.w),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder (centered visually; back arrow in stack)
                Container(
                  height: 24.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                20.h.verticalSpace,
                horizontalDivider(opacity: 0.65),
                20.h.verticalSpace,
                // Search bar placeholder
                Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                22.w.verticalSpace,
                // User list placeholders
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        10,
                        (_) => _inviteUserRowShimmer(
                          context: context,
                          userHeight: userHeight,
                          userWidth: userWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Back arrow placeholder
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 24.w,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _inviteUserRowShimmer({
    required BuildContext context,
    required double userHeight,
    required double userWidth,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 8.w),
      height: userHeight,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            height: userHeight,
            width: userWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: (context.isBrowserMobile) ? 80.w : 15.w),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Container(
            height: userHeight,
            width: userWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
