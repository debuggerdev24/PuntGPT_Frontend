import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/app_colors.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';

import '../../../provider/search_engine_provider.dart';

class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 50.h, 12.w, 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Search filters",
                  style: regular(
                    fontSize: 24.sp,
                    color: AppColors.primary,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          _buildFilterList(context: context),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 22, bottom: 11),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total Runners : (20)",
                style: semiBold(fontSize: 16.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: AppFilledButton(
              text: "Apply",
              onTap: () {
                context.pop();
              },
              textStyle: semiBold(fontSize: 16.sp, color: Colors.white),
            ),
          ),
          // horizontalDivider(),
          45.h.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildFilterList({required BuildContext context}) {
    final provider = context.watch<SearchEngineProvider>();

    return Column(
      children: [
        Theme(
          data: Theme.of(
            context,
          ).copyWith(dividerColor: AppColors.greyColor.withValues(alpha: 0.2)),
          child: ExpansionTile(
            childrenPadding: EdgeInsets.only(
              left: 25.w,
              right: 25.w,
              bottom: 8.h,
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: 25.w),
            iconColor: AppColors.greyColor,
            title: Text("Track", style: semiBold(fontSize: 16.sp)),
            children: [
              // Placed last start
              InkWell(
                onTap: () {
                  provider.togglePlacedLastStart(!provider.placedLastStart);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  children: [
                    Divider(color: AppColors.greyColor.withValues(alpha: 0.2)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Placed last start", style: semiBold(fontSize: 16.sp)),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: provider.placedLastStart
                                    ? Colors.green
                                    : AppColors.primary.withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color: provider.placedLastStart
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                            child: provider.placedLastStart
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Won last start
              InkWell(
                onTap: () {
                  provider.toggleWonLastStart(!provider.wonLastStart);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  children: [
                    Divider(color: AppColors.greyColor.withValues(alpha: 0.2)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Won last start", style: semiBold(fontSize: 16.sp)),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: provider.wonLastStart
                                    ? Colors.green
                                    : AppColors.primary.withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color: provider.wonLastStart
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                            child: provider.wonLastStart
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Won last 12 months
              InkWell(
                onTap: () {
                  provider.toggleWonLast12Months(!provider.wonLast12Months);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  children: [
                    Divider(color: AppColors.greyColor.withValues(alpha: 0.2)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Won last 12 months", style: semiBold(fontSize: 16.sp)),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: provider.wonLast12Months
                                    ? Colors.green
                                    : AppColors.primary.withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color: provider.wonLast12Months
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                            child: provider.wonLast12Months
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
