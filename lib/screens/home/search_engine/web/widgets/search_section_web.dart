import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:puntgpt_nick/models/home/search_engine/search_model.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/barrier_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/jockey_horse_wins_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/odds_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_checkbox_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/runners_list_web.dart';

class SearchSectionWeb extends StatefulWidget {
  const SearchSectionWeb({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  State<SearchSectionWeb> createState() => _SearchSectionWebState();
}

class _SearchSectionWebState extends State<SearchSectionWeb> {
  final Map<String, TextEditingController> _controllers = {};

  int _lastAutoPaginateForRunnerCount = 0;

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> onSaveSearchTap({required SearchEngineProvider provider}) async {
    await provider.getAllSaveSearch();
    if (!mounted) return;
    context.pushNamed(WebRoutes.savedSearchedScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    final isHidingFuilterPanel =
        context.screenWidth < context.fullScreenWidth - 70;
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        if (provider.runnersList == null) {
          _lastAutoPaginateForRunnerCount = 0;
        }
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.isDesktop ? 60 : 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isHidingFuilterPanel) ...[
                      OnMouseTap(
                        onTap: _openFilterSideSheet,
                        child: Icon(Icons.tune_outlined, size: 20),
                      ),
                      SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        "Filter through form your way",
                        style: bold(fontSize: 14, height: 1),
                      ),
                    ),
                    OnMouseTap(
                      onTap: () => onSaveSearchTap(provider: provider),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageWidget(
                            type: ImageType.svg,
                            path: AppAssets.bookmark,
                            height: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Saved Searches",
                            style: bold(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                //* filter view
                horizontalDivider(),
                if (!provider.isEditSavedSearch)
                  _buildSearchView(provider: provider),
              ],
            ),
          ),
        );
      },
    );
  }

  /// One cell: loading placeholder or runner card. No fixed aspect — height is
  /// whatever the child needs.
  Widget _runnerBoxWebAtIndex({
    required BuildContext context,
    required SearchEngineProvider provider,
    required int index,
  }) {
    if (index >= provider.runnersList!.length) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }
    final runnerCount = provider.runnersList!.length;
    if (index == runnerCount - 1 &&
        provider.hasMoreRunners &&
        !provider.isLoadingMoreRunners &&
        runnerCount != _lastAutoPaginateForRunnerCount) {
      _lastAutoPaginateForRunnerCount = runnerCount;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final p = context.read<SearchEngineProvider>();
        if (p.runnersList == null ||
            !p.hasMoreRunners ||
            p.isLoadingMoreRunners) {
          return;
        }
        p.loadNextRunners();
      });
    }
    return RunnerBoxWeb(
      index: index,
      runner: provider.runnersList![index],
      onAddToTipSlip: () {
        provider.createTipSlip(
          context: context,
          selectionId: provider.runnersList![index].selectionId.toString(),
        );
      },
      onCompareToField: () {
        provider.compareHorses(
          selectionId: provider.runnersList![index].selectionId.toString(),
        );
      },
      onSaveSearch: (String name) {
        provider.createSaveSearch(
          name: name,
          onError: (error) {
            AppToast.error(context: context, message: error);
          },
          onSuccess: () {
            AppToast.success(
              context: context,
              message: 'Search saved successfully',
            );
          },
        );
      },
    );
  }

  Widget _runnersWebRows({
    required BuildContext context,
    required SearchEngineProvider provider,
    required bool isShowingFilterPanel,
  }) {
    final cross = context.screenWidth > 1010
        ? context.screenWidth > 1274
              ? isShowingFilterPanel
                    ? 3
                    : 4
              : 3
        : 2;
    const horizontalGap = 8.0;
    const verticalGap = 6.0;
    final extra = provider.isLoadingMoreRunners ? 2 : 0;
    final total = provider.runnersList!.length + extra;

    final rows = <Widget>[];
    for (var start = 0; start < total; start += cross) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: start + cross < total ? verticalGap : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(cross, (slot) {
              final i = start + slot;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: slot < cross - 1 ? horizontalGap : 0,
                  ),
                  child: i < total
                      ? _runnerBoxWebAtIndex(
                          context: context,
                          provider: provider,
                          index: i,
                        )
                      : const SizedBox.shrink(),
                ),
              );
            }),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  /// For Mobile

  Widget _buildSearchView({required SearchEngineProvider provider}) {
    final isShowingFilterPanel =
        context.screenWidth > context.fullScreenWidth - 70;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isShowingFilterPanel)
              //* --------------------> left panel
              SizedBox(
                width: (context.fullScreenWidth * 23) / 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: AppMultiSelectTrackDropdown(
                        items: provider.trackList ?? const [],
                        hintText: "All Tracks",
                      ),
                    ),
                    SizedBox(height: 12),
                    horizontalDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SearchCheckboxField(
                        title: "Placed last start",
                        isChecked: provider.placedLastStart,
                        onTap: () => provider.togglePlacedLastStart(
                          !provider.placedLastStart,
                        ),
                        verticalPadding: 12,
                      ),
                    ),
                    horizontalDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SearchCheckboxField(
                        title: "Placed at distance",
                        isChecked: provider.placedAtDistance,
                        onTap: () => provider.togglePlacedAtDistance(
                          !provider.placedAtDistance,
                        ),
                        verticalPadding: 12,
                      ),
                    ),

                    horizontalDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SearchCheckboxField(
                        title: "Placed at track",
                        isChecked: provider.placeAtTrack == true,
                        onTap: () {
                          final current = provider.placeAtTrack;
                          provider.setSelectedPlaceAtTrack = current == null
                              ? true
                              : !current;
                        },
                        verticalPadding: 12,
                      ),
                    ),
                    horizontalDivider(),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: SearchCheckboxField(
                            title: "Won at track",
                            isChecked: provider.selectedWinsAtTrack == true,
                            onTap: () {
                              final current = provider.selectedWinsAtTrack;
                              provider.setSelectedWinsAtTrack = current == null
                                  ? true
                                  : !current;
                            },
                            verticalPadding: 12,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: SearchCheckboxField(
                            title: "Won at distance",
                            isChecked: provider.wonAtDistance,
                            onTap: () => provider.toggleWonAtDistance(
                              !provider.wonAtDistance,
                            ),
                            verticalPadding: 12,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: SearchCheckboxField(
                            title: "Won last start",
                            isChecked: provider.wonLastStart,
                            onTap: () => provider.toggleWonLastStart(
                              !provider.wonLastStart,
                            ),
                            verticalPadding: 12,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: SearchCheckboxField(
                            title: "Won last 12 months",
                            isChecked: provider.wonLast12Months,
                            onTap: () => provider.toggleWonLast12Months(
                              !provider.wonLast12Months,
                            ),
                            verticalPadding: 12,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: OddsRangeSliderField(
                            values: provider.oddsRangeValues,
                            onChanged: provider.updateOddsRange,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: JockeyHorseWinsSliderField(
                            values: provider.jockeyHorseWinsRangeValues,
                            onChanged: provider.updateJockeyHorseWinsRange,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: BarrierRangeSliderField(
                            values: provider.barrierRangeIndexValues,
                            onChanged: provider.updateBarrierRange,
                          ),
                        ),
                        horizontalDivider(),
                      ],
                    ),
                    SizedBox(height: 20),
                    AppFilledButton(
                      margin: EdgeInsets.only(
                        right: 12,
                        top: provider.isSearched ? 12 : 0,
                        bottom: 14,
                      ),
                      text: "Search",

                      textStyle: semiBold(color: AppColors.white, fontSize: 12),
                      onTap: () {
                        Logger.info("Search button tapped");
                        provider.getUpcomingRunner(onSuccess: () {});
                      },
                    ),
                    // AppOutlinedButton(
                    //   margin: EdgeInsets.only(top: 6, bottom: 50, right: 10),
                    //   text: "Save this Search",
                    //   padding: (!context.isMobileWeb)
                    //       ? EdgeInsets.symmetric(vertical: 12)
                    //       : null, // (context.isDesktop) ? 12.w : 11.w,
                    //   textStyle: semiBold(
                    //     fontSize: 12,
                    //   ),

                    //   onTap: () {
                    //     // formKey.currentState!.validate();
                    //     provider.setIsSearched(value: true);
                    //   },
                    // ),
                  ],
                ),
              ),
            //* --------------------> right panel (Grid view)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14),
                  if (provider.isGettingRunners)
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else if (provider.runnersList?.isEmpty ?? true)
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text(
                          "No runners found!",
                          style: semiBold(
                            fontSize: 14,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      "Total Runners: (${provider.totalRunners ?? provider.runnersList?.length ?? 0})",
                      style: semiBold(
                        fontSize: 14,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  SizedBox(height: 10),
                  if (provider.runnersList != null &&
                      provider.runnersList!.isNotEmpty)
                    _runnersWebRows(
                      context: context,
                      provider: provider,
                      isShowingFilterPanel: isShowingFilterPanel,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openFilterSideSheet() {
    showGeneralDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      barrierLabel: "Filter Panel",
      barrierColor: const Color(0x80000000),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, _, __) {
        // Consumer rebuilds this panel when SearchEngineProvider notifies
        // (checkbox toggles, sliders, track list), so UI updates in real time.
        return Align(
          alignment: Alignment.centerLeft,
          child: Consumer<SearchEngineProvider>(
            builder: (dialogContext, provider, _) {
              return Container(
                width: 340,
                height: MediaQuery.sizeOf(context).height,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                color: AppColors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Filters",
                            style: semiBold(
                              fontSize: 16,
                              fontFamily: AppFontFamily.secondary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    horizontalDivider(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppMultiSelectTrackDropdown(
                              items: provider.trackList ?? const [],
                              hintText: "All Tracks",
                            ),
                            horizontalDivider(),
                            SearchCheckboxField(
                              title: "Placed last start",
                              isChecked: provider.placedLastStart,
                              onTap: () => provider.togglePlacedLastStart(
                                !provider.placedLastStart,
                              ),
                              verticalPadding: 16,
                            ),
                            horizontalDivider(),
                            SearchCheckboxField(
                              title: "Placed at distance",
                              isChecked: provider.placedAtDistance,
                              onTap: () => provider.togglePlacedAtDistance(
                                !provider.placedAtDistance,
                              ),
                              verticalPadding: 16,
                            ),
                            horizontalDivider(),
                            SearchCheckboxField(
                              title: "Placed at track",
                              isChecked: provider.placeAtTrack == true,
                              onTap: () {
                                final current = provider.placeAtTrack;
                                provider.setSelectedPlaceAtTrack =
                                    current == null ? true : !current;
                              },
                              verticalPadding: 16,
                            ),
                            horizontalDivider(),
                            Column(
                              children: [
                                SearchCheckboxField(
                                  title: "Won at track",
                                  isChecked:
                                      provider.selectedWinsAtTrack == true,
                                  onTap: () {
                                    final current =
                                        provider.selectedWinsAtTrack;
                                    provider.setSelectedWinsAtTrack =
                                        current == null ? true : !current;
                                  },
                                  verticalPadding: 16,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Won at distance",
                                  isChecked: provider.wonAtDistance,
                                  onTap: () => provider.toggleWonAtDistance(
                                    !provider.wonAtDistance,
                                  ),
                                  verticalPadding: 16,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Won last start",
                                  isChecked: provider.wonLastStart,
                                  onTap: () => provider.toggleWonLastStart(
                                    !provider.wonLastStart,
                                  ),
                                  verticalPadding: 16,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Won last 12 months",
                                  isChecked: provider.wonLast12Months,
                                  onTap: () => provider.toggleWonLast12Months(
                                    !provider.wonLast12Months,
                                  ),
                                  verticalPadding: 16,
                                ),
                                horizontalDivider(),
                                OddsRangeSliderField(
                                  values: provider.oddsRangeValues,
                                  onChanged: provider.updateOddsRange,
                                ),
                                horizontalDivider(),
                                JockeyHorseWinsSliderField(
                                  values: provider.jockeyHorseWinsRangeValues,
                                  onChanged:
                                      provider.updateJockeyHorseWinsRange,
                                ),
                                horizontalDivider(),
                                BarrierRangeSliderField(
                                  values: provider.barrierRangeIndexValues,
                                  onChanged: provider.updateBarrierRange,
                                ),
                                horizontalDivider(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppFilledButton(
                      text: "Apply",
                      onTap: () {
                        provider.setIsSearched(value: true);
                        ctx.pop();
                      },
                      textStyle: semiBold(color: AppColors.white, fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  Widget searchDialog({required BuildContext dailogueCtx}) {
    return ZoomIn(
      child: AlertDialog(
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: SizedBox(
          width: context.isDesktop ? 500 : 680.w,
          height: context.isDesktop ? 280 : 500.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* -------------------> top bar of popup
              Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Saved Searches",
                      style: regular(
                        fontSize: context.isDesktop ? 22.sp : 30.sp,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    OnMouseTap(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.primary,
                        size: context.isDesktop ? 22.w : 30.w,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalDivider(),
              //* -------------------> search items
              Expanded(
                child: Consumer<SearchEngineProvider>(
                  builder: (context, provider, child) {
                    final saveSearches = provider.saveSearches;
                    if (saveSearches == null) {
                      return const SizedBox(
                        height: 140,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (saveSearches.isEmpty) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: Text("No saved searches found")),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return OnMouseTap(
                            onTap: () async {
                              dailogueCtx.pop();
                              await provider.getSaveSearchDetails(
                                id: provider.saveSearches![index].id.toString(),
                              );
                              if (!mounted) return;
                              _openManageSavedSearchSideSheet();
                            },
                            child: searchItem(
                              search: provider.saveSearches![index],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: horizontalDivider(),
                        ),
                        itemCount: saveSearches.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchItem({required SaveSearchModel search}) {
    return Row(
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
        Icon(Icons.arrow_forward_ios_rounded, color: AppColors.black, size: 12),
      ],
    );
  }

  //* -------------------> Manage Saved Search Side Sheet
  void _openManageSavedSearchSideSheet() {
    context.read<SearchEngineProvider>().setIsEditSavedSearch = false;
    showModalSideSheet(
      context: context,
      useRootNavigator: false,
      withCloseControll: true,
      barrierColor: const Color(0x80000000),
      width: 300,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        color: AppColors.white,
        padding: const EdgeInsets.all(10),
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
                  child: Text(
                    selectedSaveSearch.name,
                    style: semiBold(fontSize: 16),
                  ),
                ),
                horizontalDivider(),
                SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppMultiSelectTrackDropdown(
                          enabled: isEditMode,
                          margin: EdgeInsets.fromLTRB(10, 6, 10, 10),
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
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: OddsRangeSliderField(
                            values: provider.oddsRangeValues,
                            onChanged: isEditMode
                                ? provider.updateOddsRange
                                : null,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: JockeyHorseWinsSliderField(
                            values: provider.jockeyHorseWinsRangeValues,
                            onChanged: isEditMode
                                ? provider.updateJockeyHorseWinsRange
                                : null,
                          ),
                        ),
                        horizontalDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                SizedBox(height: 10),
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
                          context.pop();
                          provider.clearSavedSearchFields();
                          AppToast.success(
                            context: context,
                            message: "Search updated successfully",
                          );
                        },
                      );
                    },
                  ),
                  AppOutlinedButton(
                    margin: EdgeInsets.only(top: 8),
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

  Widget manageSavedSearchDialog({required BuildContext dailogueCtx}) {
    return ZoomIn(
      child: AlertDialog(
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: SizedBox(
          width: context.isDesktop ? 500 : 680.w,
          height: context.isDesktop ? 300 : 500.w,
          child: Consumer<SearchEngineProvider>(
            builder: (context, provider, child) {
              final selectedSaveSearch = provider.selectedSaveSearch;
              if (selectedSaveSearch == null) {
                return const SizedBox(
                  height: 140,
                  child: Center(child: LoadingIndicator()),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedSaveSearch.name,
                          style: semiBold(fontSize: 16),
                        ),
                        OnMouseTap(
                          onTap: () => dailogueCtx.pop(),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.primary,
                            size: context.isDesktop ? 22.w : 30.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalDivider(),
                  SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                AppMultiSelectTrackDropdown(
                                  enabled: true,
                                  margin: EdgeInsets.fromLTRB(10, 6, 10, 10),
                                  items: provider.trackList ?? const [],
                                  hintText: "Select Track",
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Placed last start",
                                  isChecked: provider.placedLastStart,
                                  onTap: () => provider.togglePlacedLastStart(
                                    !provider.placedLastStart,
                                  ),
                                  verticalPadding: 10,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Placed at distance",
                                  isChecked: provider.placedAtDistance,
                                  onTap: () => provider.togglePlacedAtDistance(
                                    !provider.placedAtDistance,
                                  ),
                                  verticalPadding: 10,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Placed at track",
                                  isChecked: provider.placeAtTrack == true,
                                  onTap: () {
                                    final current = provider.placeAtTrack;
                                    provider.setSelectedPlaceAtTrack =
                                        current == null ? true : !current;
                                  },
                                  verticalPadding: 10,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Won at track",
                                  isChecked:
                                      provider.selectedWinsAtTrack == true,
                                  onTap: () {
                                    final current =
                                        provider.selectedWinsAtTrack;
                                    provider.setSelectedWinsAtTrack =
                                        current == null ? true : !current;
                                  },
                                  verticalPadding: 10,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Won at distance",
                                  isChecked: provider.wonAtDistance,
                                  onTap: () => provider.toggleWonAtDistance(
                                    !provider.wonAtDistance,
                                  ),
                                  verticalPadding: 10,
                                ),

                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Won last start",
                                  isChecked: provider.wonLastStart,
                                  onTap: () => provider.toggleWonLastStart(
                                    !provider.wonLastStart,
                                  ),
                                  verticalPadding: 10,
                                ),
                                horizontalDivider(),
                                SearchCheckboxField(
                                  title: "Won last 12 months",
                                  isChecked: provider.wonLast12Months,
                                  onTap: () => provider.toggleWonLast12Months(
                                    !provider.wonLast12Months,
                                  ),
                                  verticalPadding: 10,
                                ),
                                horizontalDivider(),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 10),

                            child: Column(
                              children: [
                                OddsRangeSliderField(
                                  values: provider.oddsRangeValues,
                                  onChanged: provider.updateOddsRange,
                                ),
                                horizontalDivider(),
                                JockeyHorseWinsSliderField(
                                  values: provider.jockeyHorseWinsRangeValues,
                                  onChanged:
                                      provider.updateJockeyHorseWinsRange,
                                ),
                                horizontalDivider(),
                                BarrierRangeSliderField(
                                  values: provider.barrierRangeIndexValues,
                                  onChanged: provider.updateBarrierRange,
                                ),
                                horizontalDivider(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
