import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/extensions/double_extensions.dart';
import 'package:puntgpt_nick/core/router/app/app_router.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/core/utils/date_formater.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';
import 'package:puntgpt_nick/models/search_engine/search_model.dart';
import 'package:puntgpt_nick/provider/search_engine_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/home_section_shimmers.dart';

import '../../../core/constants/app_colors.dart';

class SavedSearchScreen extends StatelessWidget {
  const SavedSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!context.isMobileView) {
      context.pop();
    }
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) => Column(
        children: [
          topBar(context: context),
          horizontalDivider(),
          // Consumer<SearchEngineProvider>(
          //   builder: (context, provider, child) =>
          // ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                20.h.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      Text(
                        "Upgrade to Pro Punter to save your custom Searches.",
                        style: bold(fontSize: 16.sixteenSp(context)),
                      ),
                      16.h.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ", style: medium(fontSize: 14.sp)),
                          Expanded(
                            child: Text(
                              "Have your form done and ready each time you open the app.",
                              style: medium(fontSize: 14.fourteenSp(context)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: medium(fontSize: 14.fourteenSp(context)),
                          ),
                          Expanded(
                            child: Text(
                              "Have one for favorite's, one for Roughies, one for heavy track conditions, or any system you thinks a winner!",
                              style: medium(fontSize: 14.fourteenSp(context)),
                            ),
                          ),
                        ],
                      ),
                      32.h.verticalSpace,
                    ],
                  ),
                ),

                if (provider.saveSearches == null)
                  ...List.generate(
                    5,
                    (index) => searchedItemShimmer(context: context),
                  ),
                if (provider.saveSearches != null) ...[
                  ...List.generate(
                    provider.saveSearches!.length,
                    (index) => SearchedItem(
                      search: provider.saveSearches![index],
                      onTap: () => provider.getSaveSearchDetails(
                        id: provider.saveSearches![index].id.toString(),
                      ),
                    ),
                  ),

                  //provider.saveSearches!.map((e) => ),
                ],
              ],
            ),
          ),
          // horizontalDivider(),

          // AppFilledButton(
          //   margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.w),
          //   text: "Save Current Search",
          //   textStyle: semiBold(
          //     fontSize: 16.sixteenSp(context),
          //     color: AppColors.white,
          //   ),
          //   onTap: () {},
          // ),
        
        ],
      ),
    );
  }

  Widget topBar({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        (context.isBrowserMobile) ? 35.w : 25.w,
        16.h,
        (context.isBrowserMobile) ? 33.w : 23.w,
        16.h,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Saved Searches",
            style: TextStyle(
              fontFamily: AppFontFamily.secondary,
              fontSize: (context.isBrowserMobile) ? 50.sp : 24.sp,
            ),
          ),
          GestureDetector(
            onTap: () {
              AppRouter.indexedStackNavigationShell!.goBranch(3);
            },
            child: Container(
              margin: EdgeInsets.only(left: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.premiumYellow),
              ),
              child: Text(
                "Upgrade to Pro",
                style: bold(
                  fontSize: 14.fourteenSp(context),
                  color: AppColors.premiumYellow,
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class SearchedItem extends StatelessWidget {
  const SearchedItem({super.key, required this.search, required this.onTap});
  final SaveSearchModel search;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (context.isBrowserMobile) ? 35.w : 25.w,
        vertical: (context.isBrowserMobile) ? 24.w : 14.h,
      ),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(AppRoutes.searchDetails.name);
          onTap.call();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  search.name,
                  style: semiBold(
                    fontSize: (context.isBrowserMobile) ? 40.sp : 20.sp,
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                Text(
                  // "Sep 30, 2025"
                  DateFormatter.formatDateLong(search.createdAt),
                  style: semiBold(
                    fontSize: (context.isBrowserMobile) ? 30.sp : 12.sp,
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                6.5.h.verticalSpace,
                Text(
                  search.comment,
                  // "Randwick • 1200m • >20%",
                  style: regular(
                    fontSize: (context.isBrowserMobile) ? 40.sp : 20.sp,
                    color: AppColors.primary.withValues(alpha: 0.27),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.black,
              size: (context.isBrowserMobile) ? 40.w : 14.w,
            ),
          ],
        ),
      ),
    );
  }
}
