import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/barrier_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/jockey_horse_wins_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/odds_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_checkbox_field.dart';

class SearchDetailScreen extends StatelessWidget {
  const SearchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        // Show shimmer while details are loading
        if (provider.selectedSaveSearch == null) {
          return HomeSectionShimmers.searchDetailShimmer(context: context);
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
              _buildTopBar(
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

  Widget _buildTopBar({
    required BuildContext context,
    required SearchEngineProvider provider,
    required String title,
  }) {
    return AppScreenTopBar(
      title: title,
      slogan: "Manage your saved search",
      onBack: () {
        provider.clearSavedSearchFields();
        context.pop();
      },
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
          SearchCheckboxField(
            title: "Placed last start",
            isChecked: provider.placedLastStart,
            onTap: isEditMode
                ? () => provider.togglePlacedLastStart(!provider.placedLastStart)
                : null,
          ),
          horizontalDivider(),
          //* Placed at distance Section
          // AppTextFieldDropdown(
          //   margin: EdgeInsets.symmetric(vertical: 20.w),
          //   enabled: isEditMode,
          //   items: provider.distanceDetails ?? [],
          //   selectedValue: provider.selectedPlaceAtDistance,
          //   onChange: isEditMode
          //       ? (selectedValue) {
          //           provider.setSelectedPlaceAtDistance = selectedValue;
          //         }
          //       : (_) {},
          //   hintText: "Placed at distance",
          // ),
          SearchCheckboxField(
            title: "Placed at distance",
            isChecked: provider.placedAtDistance,
            onTap: isEditMode
                ? () => provider.togglePlacedAtDistance(!provider.placedAtDistance)
                : null,
          ),
          horizontalDivider(),
          //* Placed at track Section
          SearchCheckboxField(
            title: "Placed at track",
            isChecked: provider.selectedPlaceAtTrack == true,
            onTap: isEditMode
                ? () {
                    final current = provider.selectedPlaceAtTrack;
                    provider.setSelectedPlaceAtTrack =
                        current == null ? true : !current;
                  }
                : null,
          ),
          //* Odds range Section
          horizontalDivider(),
          OddsRangeSliderField(
            values: provider.oddsRangeValues,
            onChanged: isEditMode ? provider.updateOddsRange : null,
          ),
          horizontalDivider(),
          //* Win at track Section
          SearchCheckboxField(
            title: "Win at track",
            isChecked: provider.selectedWinsAtTrack == true,
            onTap: isEditMode
                ? () {
                    final current = provider.selectedWinsAtTrack;
                    provider.setSelectedWinsAtTrack =
                        current == null ? true : !current;
                  }
                : null,
          ),
          horizontalDivider(),
          //* Wins at distance Section
          // AppTextFieldDropdown(
          //   items: provider.distanceDetails ?? [],
          //   selectedValue: provider.selectedWinsAtDistance,
          //   onChange: isEditMode
          //       ? (selectedValue) {
          //           provider.setSelectedWinsAtDistance = selectedValue;
          //         }
          //       : (_) {},
          //   margin: EdgeInsets.symmetric(vertical: 20.w),
          //   enabled: isEditMode,
          //   hintText: "Wins at distance",
          // ),
          SearchCheckboxField(
            title: "Won at distance",
            isChecked: provider.wonAtDistance,
            onTap: isEditMode
                ? () => provider.toggleWonAtDistance(!provider.wonAtDistance)
                : null,
          ),
          horizontalDivider(),
          //* Won last start Section
          SearchCheckboxField(
            title: "Won last start",
            isChecked: provider.wonLastStart,
            onTap: isEditMode
                ? () => provider.toggleWonLastStart(!provider.wonLastStart)
                : null,
            verticalPadding: 20.w,
          ),
          horizontalDivider(),
          //* Won last 12 months Section
          SearchCheckboxField(
            title: "Won last 12 months",
            isChecked: provider.wonLast12Months,
            onTap: isEditMode
                ? () => provider.toggleWonLast12Months(!provider.wonLast12Months)
                : null,
          ),
          horizontalDivider(),
          //* Jockey horse wins Section
          JockeyHorseWinsSliderField(
            values: provider.jockeyHorseWinsRangeValues,
            onChanged: isEditMode ? provider.updateJockeyHorseWinsRange : null,
          ),
          horizontalDivider(),
          //* Barrier Section
          BarrierRangeSliderField(
            values: provider.barrierRangeIndexValues,
            onChanged: isEditMode ? provider.updateBarrierRange : null,
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
                fontSize: context.isBrowserMobile ? 65.sp : 19.sp,
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
