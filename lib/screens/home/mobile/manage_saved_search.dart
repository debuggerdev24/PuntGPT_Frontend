import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/utils/app_toast.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';
import 'package:puntgpt_nick/core/widgets/app_outlined_button.dart';
import 'package:puntgpt_nick/core/widgets/app_text_field.dart';
import 'package:puntgpt_nick/core/widgets/app_text_field_drop_down.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/home_section_shimmers.dart';

import '../../../provider/search_engine/search_engine_provider.dart';

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

        //* Actual content when data is available
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) async {
            //* Clear saved search fields when navigating back
            provider.clearSavedSearchFields();
            context.pop();
            // return true;
          },
          child: Column(
            children: [
              topBar(
                context: context,
                provider: provider,
                title: provider.selectedSaveSearch?.name ?? "",
              ),
              horizontalDivider(),
              Expanded(
                child: SingleChildScrollView(
                  child: searchDetailsView(
                    context: context,
                    provider: provider,
                  ),
                ),
              ),
              horizontalDivider(),
              10.verticalSpace,

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
                    showDeleteSearchConfirmationDialog(
                      context: context,
                      provider: provider,
                    );
                  },
                  margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 6.w),
                ),
              ] else ...[
                AppFilledButton(
                  textStyle: semiBold(
                    fontSize: 16.sixteenSp(context),
                    color: AppColors.white,
                  ),
                  margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 6.h),
                  text: "Save",
                  onTap: () {
                    // Check if there are any changes
                    if (!provider.hasChangesInSavedSearch()) {
                      AppToast.info(
                        context: context,
                        message: "No changes found",
                      );
                      return;
                    }

                    // Proceed with saving if changes are detected
                    provider.editSaveSearch(
                      onSuccess: () {
                        provider.getAllSaveSearch();
                        AppToast.success(
                          context: context,
                          message: "Search updated successfully",
                        );
                      },
                    );
                  },
                ),
                AppOutlinedButton(
                  textStyle: semiBold(
                    fontSize: 16.sixteenSp(context),
                    color: AppColors.black,
                  ),
                  text: "Cancel",
                  onTap: () {
                    provider.setIsEditSavedSearch = !provider.isEditSavedSearch;
                  },
                  margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 6.w),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget topBar({
    required BuildContext context,
    required SearchEngineProvider provider,
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 14.h, 25.w, 14.h),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // Clear saved search fields when navigating back
              provider.clearSavedSearchFields();
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

  Widget searchDetailsView({
    required BuildContext context,
    required SearchEngineProvider provider,
  }) {
    final bodyHorizontalPadding = (context.isBrowserMobile) ? 50.w : 25.w;
    final isEditMode = provider.isEditSavedSearch;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: bodyHorizontalPadding),
      child: Column(
        children: [
          //* Track Section
          AppTextFieldDropdown(
            enabled: isEditMode,

            margin: EdgeInsets.symmetric(vertical: 20.w),
            items: provider.trackDetails ?? [],
            selectedValue: provider.selectedTrack,
            onChange: isEditMode
                ? (selectedValue) {
                    provider.setSelectedTrack = selectedValue;
                  }
                : (_) {},
            hintText: "Select Track",
          ),
          horizontalDivider(),
          //* Placed at last start Section
          Padding(
            padding: EdgeInsets.symmetric(vertical: 19.w),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isEditMode
                  ? () {
                      provider.togglePlacedLastStart(!provider.placedLastStart);
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Placed last start",
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: (context.isBrowserMobile) ? 40.sp : 22.sp,
                    height: (context.isBrowserMobile) ? 40.sp : 22.sp,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: provider.placedLastStart
                            ? Colors.green
                            : AppColors.primary.setOpacity(0.15),
                      ),
                      borderRadius: BorderRadius.circular(1),
                      color: provider.placedLastStart
                          ? Colors.green
                          : Colors.transparent,
                    ),
                    child: provider.placedLastStart
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: (context.isBrowserMobile) ? 30.sp : 18.sp,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          horizontalDivider(),
          //* Placed at distance Section
          AppTextFieldDropdown(
            margin: EdgeInsets.symmetric(vertical: 20.w),
            enabled: isEditMode,
            items: provider.distanceDetails ?? [],
            selectedValue: provider.selectedPlaceAtDistance,
            onChange: isEditMode
                ? (selectedValue) {
                    provider.setSelectedPlaceAtDistance = selectedValue;
                  }
                : (_) {},
            hintText: "Placed at distance",
          ),
          horizontalDivider(),
          //* Placed at track Section
          AppTextFieldDropdown(
            margin: EdgeInsets.symmetric(vertical: 20.w),
            items: provider.distanceDetails ?? [],
            selectedValue: provider.selectedPlaceAtTrack,
            enabled: isEditMode,

            onChange: isEditMode
                ? (selectedValue) {
                    provider.setSelectedPlaceAtTrack = selectedValue;
                  }
                : (_) {},
            hintText: "Placed at track",
          ),
          //* Odds range Section
          horizontalDivider(),
          AppTextField(
            margin: EdgeInsets.symmetric(vertical: 20.w),
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            controller: provider.oddsRangeCtr,
            hintText: "Odds Range",
            enabled: isEditMode,
          ),
          horizontalDivider(),
          //* Win at track Section
          AppTextFieldDropdown(
            margin: EdgeInsets.symmetric(vertical: 20.w),
            items: provider.trackDetails ?? [],
            selectedValue: provider.selectedWinsAtTrack,
            onChange: isEditMode
                ? (selectedValue) {
                    provider.setSelectedWinsAtTrack = selectedValue;
                  }
                : (_) {},
            enabled: isEditMode,
            hintText: "Win at track",
          ),
          horizontalDivider(),
          //* Wins at distance Section
          AppTextFieldDropdown(
            items: provider.distanceDetails ?? [],
            selectedValue: provider.selectedWinsAtDistance,
            onChange: isEditMode
                ? (selectedValue) {
                    provider.setSelectedWinsAtDistance = selectedValue;
                  }
                : (_) {},
            margin: EdgeInsets.symmetric(vertical: 20.w),
            enabled: isEditMode,

            hintText: "Wins at distance",
          ),
          horizontalDivider(),
          //* Won last start Section
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.w),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isEditMode
                  ? () {
                      provider.toggleWonLastStart(!provider.wonLastStart);
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Won last start",
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: (context.isBrowserMobile) ? 40.sp : 22.sp,
                    height: (context.isBrowserMobile) ? 40.sp : 22.sp,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: provider.wonLastStart
                            ? Colors.green
                            : AppColors.primary.setOpacity(0.15),
                      ),
                      borderRadius: BorderRadius.circular(1),
                      color: provider.wonLastStart
                          ? Colors.green
                          : Colors.transparent,
                    ),
                    child: provider.wonLastStart
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: (context.isBrowserMobile) ? 30.sp : 18.sp,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          horizontalDivider(),
          //* Won last 12 months Section
          Padding(
            padding: EdgeInsets.symmetric(vertical: 19.w),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isEditMode
                  ? () {
                      provider.toggleWonLast12Months(!provider.wonLast12Months);
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Won last 12 months",
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: (context.isBrowserMobile) ? 40.sp : 22.sp,
                    height: (context.isBrowserMobile) ? 40.sp : 22.sp,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: provider.wonLast12Months
                            ? Colors.green
                            : AppColors.primary.setOpacity(0.15),
                      ),
                      borderRadius: BorderRadius.circular(1),
                      color: provider.wonLast12Months
                          ? Colors.green
                          : Colors.transparent,
                    ),
                    child: provider.wonLast12Months
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: (context.isBrowserMobile) ? 30.sp : 18.sp,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          horizontalDivider(),
          //* Jockey horse wins Section
          AppTextField(
            margin: EdgeInsets.symmetric(vertical: 20.w),
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            controller: provider.jockeyHorseWinsCtr,
            hintText: "Jockey horse wins",
            enabled: isEditMode,
          ),
          horizontalDivider(),
          //* Barrier Section
          AppTextFieldDropdown(
            enabled: isEditMode,

            margin: EdgeInsets.symmetric(vertical: 20.w),
            selectedValue: provider.selectedBarrier,
            onChange: isEditMode
                ? (selectedValue) {
                    provider.setSelectedBarrier = selectedValue;
                  }
                : (_) {},
            items: provider.barrierList ?? [],
            hintText: "Barrier",
          ),
        ],
      ),
    );
  }

  /// Confirmation dialog for deleting a saved search (similar to Log Out dialog)
  void showDeleteSearchConfirmationDialog({
    required BuildContext context,
    required SearchEngineProvider provider,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            title: Text(
              "Are you sure you want to delete this search?",
              style: regular(
                color: AppColors.black,
                fontSize:
                    context.isBrowserMobile ? 65.sp : 19.sp,
              ),
            ),
            actions: [
              _dialogActionButton(
                onPressed: () async {
                  context.pop(dialogContext);

                  await provider.deleteSaveSearch(
                    id: provider.selectedSaveSearch?.id.toString() ?? "",
                    onSuccess: () {
                      AppToast.success(
                        context: context,
                        message: "Search deleted successfully",
                      );
                      // Clear fields and close the details screen
                      provider.clearSavedSearchFields();
                      context.pop();
                    },
                  );
                },
                title: "Yes",
              ),
              _dialogActionButton(
                onPressed: () {
                  context.pop(); // just close dialog
                },
                title: "Cancel",
              ),
            ],
          ),
        );
      },
    );
  }

  /// Simple dialog action button styling (mirrors log out dialog buttons)
  Widget _dialogActionButton({
    required VoidCallback onPressed,
    required String title,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: regular(
          color: (title == "Yes") ? AppColors.red : AppColors.black,
          fontSize: 16.5,
        ),
      ),
    );
  }
}
