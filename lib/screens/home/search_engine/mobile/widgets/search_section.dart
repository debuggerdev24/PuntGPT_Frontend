import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/barrier_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/jockey_horse_wins_slider_field.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/odds_range_slider_field.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_checkbox_field.dart';

class SearchFields extends StatelessWidget {
  const SearchFields({super.key, required this.providerh});
  final SearchEngineProvider providerh;

  @override
  Widget build(BuildContext context) {
    final bodyHorizontalPadding = (context.isBrowserMobile) ? 50.w : 25.w;
    // final provider = context.read<SearchEngineProvider>();
    return SizedBox(
      width: double.maxFinite,
      child: Consumer2<SearchEngineProvider, SubscriptionProvider>(
        builder: (context, provider, subProvider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //* Saved Searches
            Padding(
              padding: EdgeInsets.fromLTRB(
                bodyHorizontalPadding,
                12.w,
                bodyHorizontalPadding,
                20.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      "Search for a horse that meets your criteria:",
                      style: bold(
                        fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                        height: 1.2,
                      ),
                    ),
                  ),
                  OnMouseTap(
                    onTap: () {
                      context.pushNamed(
                        (context.isPhysicalMobile)
                            ? AppRoutes.savedSearchedScreen.name
                            : WebRoutes.savedSearchedScreen.name,
                      );
                      if (subProvider.isSubscribed) {
                        provider.getAllSaveSearch();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageWidget(
                          type: ImageType.svg,
                          path: AppAssets.bookmark,
                          height: 16.w.flexClamp(14, 18),
                        ),
                        5.w.horizontalSpace,
                        Text(
                          "Saved Searches",
                          style: bold(
                            fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* FORM AREA
            horizontalDivider(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: bodyHorizontalPadding),
              child: Column(
                children: [
                  //* Track Section
                  AppTextFieldDropdown(
                    margin: EdgeInsets.symmetric(vertical: 20.w),
                    items: provider.trackDetails ?? [],
                    selectedValue: provider.selectedTrack,
                    onChange: (selectedValue) {
                      provider.setSelectedTrack = selectedValue;
                    },
                    hintText: "Select Track",
                  ),
                  horizontalDivider(),
                  //* Placed at last start Section
                  SearchCheckboxField(
                    title: "Placed last start",
                    isChecked: provider.placedLastStart,
                    onTap: () => provider.togglePlacedLastStart(
                      !provider.placedLastStart,
                    ),
                  ),

                  horizontalDivider(),
                  //* Placed at distance Section
                  // AppTextFieldDropdown(
                  //   margin: EdgeInsets.symmetric(vertical: 20.w),
                  //   items: provider.distanceDetails ?? [],
                  //   selectedValue: provider.selectedPlaceAtDistance,
                  //   onChange: (selectedValue) {
                  //     provider.setSelectedPlaceAtDistance = selectedValue;
                  //   },
                  //   hintText: "Placed at distance",
                  // ),
                  SearchCheckboxField(
                    title: "Placed at distance",
                    isChecked: provider.placedAtDistance,
                    onTap: () => provider.togglePlacedAtDistance(
                      !provider.placedAtDistance,
                    ),
                  ),
                  horizontalDivider(),
                  //* Placed at track
                  SearchCheckboxField(
                    title: "Placed at track",
                    isChecked: provider.selectedPlaceAtTrack == true,
                    onTap: () {
                      final current = provider.selectedPlaceAtTrack;
                      provider.setSelectedPlaceAtTrack = current == null
                          ? true
                          : !current;
                    },
                  ),
                  if (subProvider.isSubscribed) ...[
                    //* Odds range Section
                    horizontalDivider(),
                    //* Win at track Section
                    SearchCheckboxField(
                      title: "Won at track",
                      isChecked: provider.selectedWinsAtTrack == true,
                      onTap: () {
                        final current = provider.selectedWinsAtTrack;
                        provider.setSelectedWinsAtTrack = current == null
                            ? true
                            : !current;
                      },
                    ),
                    horizontalDivider(),

                    SearchCheckboxField(
                      title: "Won at distance",
                      isChecked: provider.wonAtDistance,
                      onTap: () =>
                          provider.toggleWonAtDistance(!provider.wonAtDistance),
                    ),
                    horizontalDivider(),
                    //* Won last start Section
                    SearchCheckboxField(
                      title: "Won last start",
                      isChecked: provider.wonLastStart,
                      onTap: () =>
                          provider.toggleWonLastStart(!provider.wonLastStart),
                      verticalPadding: 20.w,
                    ),
                    horizontalDivider(),
                    //* Won last 12 months Section
                    SearchCheckboxField(
                      title: "Won last 12 months",
                      isChecked: provider.wonLast12Months,
                      onTap: () => provider.toggleWonLast12Months(
                        !provider.wonLast12Months,
                      ),
                    ),
                    horizontalDivider(),
                    OddsRangeSliderField(
                      values: provider.oddsRangeValues,
                      onChanged: provider.updateOddsRange,
                    ),
                    horizontalDivider(),
                    JockeyHorseWinsSliderField(
                      values: provider.jockeyHorseWinsRangeValues,
                      onChanged: provider.updateJockeyHorseWinsRange,
                    ),
                    horizontalDivider(),
                    BarrierRangeSliderField(
                      values: provider.barrierRangeIndexValues,
                      onChanged: provider.updateBarrierRange,
                    ),
                  ] else ...[
                    horizontalDivider(),

                    _buildLockedSearchCard(context),
                  ],
                ],
              ),
            ),
            horizontalDivider(),
          ],
        ),
      ),
    );
  }

  static Widget _buildLockedSearchCard(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: 20.w),
      padding: EdgeInsets.symmetric(
        horizontal: (context.isBrowserMobile) ? 28.w : 20.w,
        vertical: (context.isBrowserMobile) ? 28.h : 22.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all((context.isBrowserMobile) ? 20.w : 14.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_rounded,
              size: (context.isBrowserMobile) ? 44.w : 32.w,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          16.h.verticalSpace,
          Text(
            "Subscribe to use all features",
            style: semiBold(
              fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
              fontFamily: AppFontFamily.secondary,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          8.h.verticalSpace,
          Text(
            "Unlock the full search engine and get access to all filters and criteria.",
            style: regular(
              fontSize: (context.isBrowserMobile) ? 22.sp : 13.sp,
              color: AppColors.primary.withValues(alpha: 0.6),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          20.h.verticalSpace,
          SizedBox(
            width: double.maxFinite,
            child: AppFilledButton(
              onTap: () {
                context.pushNamed(
                  (kIsWeb && context.isMobileView)
                      ? WebRoutes.manageSubscriptionScreen.name
                      : AppRoutes.manageSubscriptionScreen.name,
                );
              },
              text: "Subscribe to Pro",
              textStyle: semiBold(
                fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
                color: AppColors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  //* For Mobile
  // Widget _buildFilterSection() {
  //   final provider = context.watch<SearchEngineProvider>();
  //   return Column(
  //     children: [
  //       horizontalDivider(),
  //       Theme(
  //         data: Theme.of(context).copyWith(
  //           dividerColor: AppColors.transparent,
  //         ), //AppColors.greyColor.withValues(alpha: 0.2)
  //         child: ExpansionTile(
  //           initiallyExpanded: true,
  //           childrenPadding: EdgeInsets.only(
  //             left: (context.isBrowserMobile) ? 50.w : 25.w,
  //             right: (context.isBrowserMobile) ? 50.w : 25.w,
  //             bottom: 8.h,
  //           ),
  //           tilePadding: EdgeInsets.symmetric(
  //             horizontal: (context.isBrowserMobile) ? 50.w : 25.w,
  //           ),
  //           iconColor: AppColors.greyColor,
  //           title: Text(
  //             "Track",
  //             style: semiBold(
  //               fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
  //             ),
  //           ),
  //           children: [
  //             ...provider.trackBoolItems.map((item) {
  //               bool isChecked = item.checked;
  //               return InkWell(
  //                 onTap: () {
  //                   provider.toggleTrackItem(item.trackType.value, !isChecked);
  //                 },
  //                 splashColor: Colors.transparent,
  //                 highlightColor: Colors.transparent,
  //                 child: Column(
  //                   children: [
  //                     Divider(
  //                       color: AppColors.greyColor.withValues(alpha: 0.2),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(vertical: 8.h),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             item.trackType.value,
  //                             style: semiBold(
  //                               fontSize: (context.isBrowserMobile)
  //                                   ? 36.sp
  //                                   : 16.sp,
  //                             ),
  //                           ),
  //                           AnimatedContainer(
  //                             duration: const Duration(milliseconds: 250),
  //                             curve: Curves.easeInOut,
  //                             width: (context.isBrowserMobile) ? 40.sp : 22.sp,
  //                             height: (context.isBrowserMobile) ? 40.sp : 22.sp,
  //                             decoration: BoxDecoration(
  //                               border: Border.all(
  //                                 color: isChecked
  //                                     ? Colors.green
  //                                     : AppColors.primary.setOpacity(0.15),
  //                               ),
  //                               borderRadius: BorderRadius.circular(1),
  //                               color: isChecked
  //                                   ? Colors.green
  //                                   : Colors.transparent,
  //                             ),
  //                             child: isChecked
  //                                 ? Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                     size: (context.isBrowserMobile)
  //                                         ? 30.sp
  //                                         : 18.sp,
  //                                   )
  //                                 : null,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //             10.verticalSpace,

  //             horizontalDivider(),
  //             Padding(
  //               padding: EdgeInsets.symmetric(vertical: 14),
  //               child: AppTextField(
  //                 inputFormatter: [FilteringTextInputFormatter.digitsOnly],
  //                 keyboardType: TextInputType.number,
  //                 controller: provider.oddsRangeCtr,
  //                 hintText: "Odds Range",
  //               ),
  //             ),
  //             horizontalDivider(),

  //             Padding(
  //               padding: EdgeInsets.symmetric(vertical: 14),
  //               child: AppTextField(
  //                 controller: TextEditingController(),
  //                 hintText: "Wins at track",
  //               ),
  //             ),
  //             horizontalDivider(),
  //             Padding(
  //               padding: EdgeInsets.symmetric(vertical: 14),
  //               child: AppTextField(
  //                 controller: provider.winsAtDistanceCtr,
  //                 hintText: "Wins at distance",
  //               ),
  //             ),

  //             horizontalDivider(),
  //             Padding(
  //               padding: EdgeInsets.symmetric(vertical: 14),
  //               child: AppTextField(
  //                 inputFormatter: [FilteringTextInputFormatter.digitsOnly],
  //                 keyboardType: TextInputType.number,
  //                 controller: provider.jockeyHorseWinsCtr,
  //                 hintText: "Jockey horse wins",
  //               ),
  //             ),
  //             horizontalDivider(),
  //             Padding(
  //               padding: EdgeInsets.symmetric(vertical: 14),
  //               child: AppTextField(
  //                 inputFormatter: [FilteringTextInputFormatter.digitsOnly],
  //                 keyboardType: TextInputType.number,
  //                 controller: provider.barrierCtr,
  //                 hintText: "Barrier",
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       horizontalDivider(),
  //     ],
  //   );
  // }
}

/// Shimmer skeleton for the Home search section (filters + header) on mobile.
///
/// This is designed to closely match the `SearchView` UI so it can be shown
/// while the home screen data is loading.
