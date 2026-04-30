import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:puntgpt_nick/models/home/search_engine/search_model.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/barrier_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/jockey_horse_wins_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/odds_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_checkbox_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_section_shimmers_web.dart';

class SavedSearchesWeb extends StatefulWidget {
  const SavedSearchesWeb({super.key});

  @override
  State<SavedSearchesWeb> createState() => _SavedSearchesWebState();
}

class _SavedSearchesWebState extends State<SavedSearchesWeb> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SearchEngineProvider>().getAllSaveSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: (context.isMobileView)
                ? 0
                : (context.isTablet)
                ? 100
                : 200,
          ),
          child: Consumer<SearchEngineProvider>(
            builder: (context, provider, child) {
              final items = provider.saveSearches;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(context: context, onBack: () {
                    provider.clearSavedSearchFields();
                    context.pop();
                  }),
                  if (items == null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: WebSectionShimmers.savedSearchesShimmer(
                        context: context,
                      ),
                    )
                  else if (items.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        "No saved searches found",
                        style: medium(fontSize: 14, color: AppColors.primary),
                      ),
                    )
                  else
                    ...items.map(
                      (e) => Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: _savedSearchItem(context: context, search: e),
                      ),
                    ),
                  SizedBox(height: 60),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: askPuntGPTButtonWeb(context: context),
        ),
      ],
    );
  }

  Widget _savedSearchItem({
    required BuildContext context,
    required SaveSearchModel search,
  }) {
    return OnMouseTap(
      onTap: () async {
        await context.read<SearchEngineProvider>().getSaveSearchDetails(
          id: search.id.toString(),
        );
        if (!context.mounted) return;
        _openManageSavedSearchSideSheet(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(search.name, style: semiBold(fontSize: 13)),
                Text(
                  DateFormatter.formatDateLong(search.createdAt),
                  style: semiBold(
                    fontSize: 9,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 4),
                Text(search.comment, style: medium(fontSize: 11)),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.black,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  //* -------------------> Manage Saved Search Side Sheet`
  void _openManageSavedSearchSideSheet(BuildContext context) {
    context.read<SearchEngineProvider>().setIsEditSavedSearch = false;
    showModalSideSheet(
      context: context,
      useRootNavigator: false,
      withCloseControll: true,
      barrierColor: const Color(0x80000000),
      width: 320,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Consumer<SearchEngineProvider>(
          builder: (context, provider, child) {
            final selectedSaveSearch = provider.selectedSaveSearch;
            if (selectedSaveSearch == null) {
              return const SizedBox(
                height: 140,
                child: Center(child: LoadingIndicator()),
              );
            }
            final isEditMode = provider.isEditSavedSearch;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
                  child: Text(
                    selectedSaveSearch.name,
                    style: semiBold(fontSize: 16),
                  ),
                ),
                horizontalDivider(),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppMultiSelectTrackDropdown(
                          enabled: isEditMode,
                          margin: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                          items: provider.trackList ?? const [],
                          hintText: "Select Track",
                        ),
                        horizontalDivider(),
                        SearchCheckboxField(
                          title: "Placed last start",
                          isChecked: provider.placedLastStart,
                          onTap: isEditMode
                              ? () => provider.togglePlacedLastStart(
                                  !provider.placedLastStart,
                                )
                              : null,
                          verticalPadding: 10,
                        ),
                        horizontalDivider(),
                        SearchCheckboxField(
                          title: "Placed at distance",
                          isChecked: provider.placedAtDistance,
                          onTap: isEditMode
                              ? () => provider.togglePlacedAtDistance(
                                  !provider.placedAtDistance,
                                )
                              : null,
                          verticalPadding: 10,
                        ),
                        horizontalDivider(),
                        SearchCheckboxField(
                          title: "Placed at track",
                          isChecked: provider.placeAtTrack == true,
                          onTap: isEditMode
                              ? () {
                                  final current = provider.placeAtTrack;
                                  provider.setSelectedPlaceAtTrack =
                                      current == null ? true : !current;
                                }
                              : null,
                          verticalPadding: 10,
                        ),
                        horizontalDivider(),
                        SearchCheckboxField(
                          title: "Won at track",
                          isChecked: provider.selectedWinsAtTrack == true,
                          onTap: isEditMode
                              ? () {
                                  final current = provider.selectedWinsAtTrack;
                                  provider.setSelectedWinsAtTrack =
                                      current == null ? true : !current;
                                }
                              : null,
                          verticalPadding: 10,
                        ),
                        horizontalDivider(),
                        SearchCheckboxField(
                          title: "Won at distance",
                          isChecked: provider.wonAtDistance,
                          onTap: isEditMode
                              ? () => provider.toggleWonAtDistance(
                                  !provider.wonAtDistance,
                                )
                              : null,
                          verticalPadding: 10,
                        ),
                        horizontalDivider(),
                        SearchCheckboxField(
                          title: "Won last start",
                          isChecked: provider.wonLastStart,
                          onTap: isEditMode
                              ? () => provider.toggleWonLastStart(
                                  !provider.wonLastStart,
                                )
                              : null,
                          verticalPadding: 10,
                        ),
                        horizontalDivider(),
                        SearchCheckboxField(
                          title: "Won last 12 months",
                          isChecked: provider.wonLast12Months,
                          onTap: isEditMode
                              ? () => provider.toggleWonLast12Months(
                                  !provider.wonLast12Months,
                                )
                              : null,
                          verticalPadding: 10,
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: OddsRangeSliderField(
                            values: provider.oddsRangeValues,
                            onChanged: isEditMode
                                ? provider.updateOddsRange
                                : null,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: JockeyHorseWinsSliderField(
                            values: provider.jockeyHorseWinsRangeValues,
                            onChanged: isEditMode
                                ? provider.updateJockeyHorseWinsRange
                                : null,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: BarrierRangeSliderField(
                            values: provider.barrierRangeIndexValues,
                            onChanged: isEditMode
                                ? provider.updateBarrierRange
                                : null,
                          ),
                        ),
                        horizontalDivider(),
                      ],
                    ),
                  ),
                ),
                horizontalDivider(),
                const SizedBox(height: 10),
                if (!isEditMode)
                  AppFilledButton(
                    text: "Edit",
                    textStyle: semiBold(fontSize: 14, color: AppColors.white),
                    onTap: () {
                      provider.setIsEditSavedSearch = true;
                    },
                  )
                else ...[
                  AppFilledButton(
                    text: "Save",
                    textStyle: semiBold(fontSize: 14, color: AppColors.white),
                    onTap: () {
                      if (!provider.hasChangesInSavedSearch()) {
                        AppToast.info(
                          context: context,
                          message: "No changes found",
                        );
                        return;
                      }
                      provider.editSaveSearch(
                        onSuccess: () {
                          provider.getAllSaveSearch();
                          provider.setIsEditSavedSearch = false;
                          AppToast.success(
                            context: context,
                            message: "Search updated successfully",
                          );
                        },
                      );
                    },
                  ),
                  AppOutlinedButton(
                    margin: const EdgeInsets.only(top: 8),
                    text: "Cancel",
                    textStyle: semiBold(fontSize: 14),
                    onTap: () {
                      provider.setIsEditSavedSearch = false;
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topBar({required BuildContext context,required VoidCallback onBack}) {
    final horizontalPadding = (!context.isMobileView) ? 0.0 : 18.0;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: (!context.isMobileView) ? 60 : 13,
            bottom: 14,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Row(
            spacing: 14,
            children: [
              Padding(
                padding: EdgeInsets.only(top: (!context.isMobileWeb) ? 4 : 2),
                child: OnMouseTap(
                  onTap: onBack,
                  child: Icon(Icons.arrow_back_ios_rounded, size: 14),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saved Searches",
                      style: regular(
                        fontSize: 22,
                        fontFamily: AppFontFamily.secondary,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Your saved filters and search presets",
                      style: medium(
                        fontSize: 12,
                        color: AppColors.primary.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(),
        SizedBox(height: 20),
      ],
    );
  }
}
