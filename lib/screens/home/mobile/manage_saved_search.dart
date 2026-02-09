import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/app_colors.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/extensions/double_extensions.dart';
import 'package:puntgpt_nick/core/utils/app_toast.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';
import 'package:puntgpt_nick/core/widgets/app_outlined_button.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/home_section_shimmers.dart';

import '../../../provider/search_engine_provider.dart';

class SearchDetailScreen extends StatelessWidget {
  const SearchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        // Show shimmer while details are loading
        if (provider.selectedSaveSearch == null) {
          return searchDetailShimmer(context: context);
        }

        // Actual content when data is available
        return Column(
          children: [
            topBar(context: context,title: provider.selectedSaveSearch?.name ?? ""),
            horizontalDivider(),
            _trackedView(context: context,provider: provider),
            Spacer(),
            if (!provider.isEditSavedSearch) ...[
              AppFilledButton(
                textStyle: semiBold(
                  fontSize: 16.sixteenSp(context),
                  color: AppColors.white,
                ),
                text: "Edit",
                onTap: () {
                  provider.setIsEditSavedSearch = !provider.isEditSavedSearch;
                },
                margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 6.h),
              ),
              AppOutlinedButton(
                textStyle: semiBold(
                  fontSize: 16.sixteenSp(context),
                  color: AppColors.black,
                ),
                text: "Delete",
                onTap: () {
                  provider.deleteSaveSearch(id: provider.selectedSaveSearch?.id.toString() ?? "", onSuccess: () {
                    AppToast.success(context: context, message: "Search deleted successfully");
                    context.pop();
                  });
                },
                margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 16.h),
              ),
            ] else
              AppFilledButton(
                textStyle: semiBold(
                  fontSize: 16.sixteenSp(context),
                  color: AppColors.white,
                ),
                margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 6.h),
                text: "Save",
                onTap: () {
                  provider.editSaveSearch(
                    onSuccess: () {
                      provider.editSaveSearch(onSuccess: () {
                        AppToast.success(context: context, message: "Search edited successfully");
                      },);
                      

                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget topBar({required BuildContext context,required String title}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 14.h, 25.w, 14.h),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: regular(
                  fontFamily: AppFontFamily.secondary,
                  height: 1.1,
                  fontSize: (context.isBrowserMobile) ? 65.sp : 24,
                ),
              ),
              Text(
                "Manage your saved search",
                style: medium(
                  fontSize: 14.fourteenSp(context),
                  color: AppColors.greyColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trackedView({required BuildContext context,required SearchEngineProvider provider}) {
    

    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: AppColors.transparent),
          child: ExpansionTile(
            childrenPadding: EdgeInsets.only(
              left: 25.w,
              right: 25.w,
              bottom: 8.h,
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: 25.w),
            iconColor: AppColors.greyColor,
            title: Text(
              "Track",
              style: semiBold(fontSize: 16.sixteenSp(context)),
            ),
            children: provider.savedSearchTrackItems.map((item) {
              bool isChecked = item.checked;
              return InkWell(
                onTap: () {
                  if (provider.isEditSavedSearch) {
                  provider.updateSavedSearchTrackItem(
                      item.trackType.value,
                      !isChecked,
                    );
                  }
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
                          Text(
                            item.trackType.value,
                            style: semiBold(fontSize: 16.sixteenSp(context)),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isChecked
                                    ? Colors.green
                                    : AppColors.primary.withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(1),
                              color: isChecked
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                            child: isChecked
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
              );
            }).toList(),
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}
