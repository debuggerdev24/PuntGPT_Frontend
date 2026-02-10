import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/core/router/web/web_routes.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/core/widgets/app_text_field.dart';
import 'package:puntgpt_nick/core/widgets/app_text_field_drop_down.dart';
import 'package:puntgpt_nick/core/widgets/image_widget.dart';
import 'package:puntgpt_nick/core/widgets/on_button_tap.dart';
import 'package:puntgpt_nick/provider/search_engine_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key, required this.providerh});
  final SearchEngineProvider providerh;

  @override
  Widget build(BuildContext context) {
    final bodyHorizontalPadding = (context.isBrowserMobile) ? 50.w : 25.w;
    // final provider = context.read<SearchEngineProvider>();
    return SizedBox(
      width: double.maxFinite,
      child: Consumer<SearchEngineProvider>(
        builder: (context, provider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          
          children: [
            //* Search for a horse that meets your criteria:
            Padding(
              padding: EdgeInsets.fromLTRB(
                bodyHorizontalPadding,
                16.w,
                bodyHorizontalPadding,
                0,
              ),
              child: Text(
                "Search for a horse that meets your criteria:",
                style: bold(
                  fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                  height: 1.2,
                ),
              ),
            ),
            //* Total Runners
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
                  Text(
                    "Total Runners: (20)",
                    style: bold(
                      fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                    ),
                  ),
                  OnMouseTap(
                    onTap: () {
                      context.pushNamed(
                        (context.isPhysicalMobile)
                            ? AppRoutes.savedSearchedScreen.name
                            : WebRoutes.savedSearchedScreen.name,
                      );
                      //* calling the api to get all saved searches
                      provider.getAllSaveSearch();
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

                  //  ...provider.trackBoolItems.map((item) {
                  // bool isChecked = item.checked;
                  // return Padding(
                  //         padding: EdgeInsets.symmetric(vertical: 8.h),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               item.trackType.value,
                  //               style: semiBold(
                  //                 fontSize: (context.isBrowserMobile)
                  //                     ? 36.sp
                  //                     : 16.sp,
                  //               ),
                  //             ),
                  //             AnimatedContainer(
                  //               duration: const Duration(milliseconds: 250),
                  //               curve: Curves.easeInOut,
                  //               width: (context.isBrowserMobile) ? 40.sp : 22.sp,
                  //               height: (context.isBrowserMobile) ? 40.sp : 22.sp,
                  //               decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                   color: provider.trackBoolItems[0].checked
                  //                       ? Colors.green
                  //                       : AppColors.primary.setOpacity(0.15),
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(1),
                  //                 color: provider.trackBoolItems[0].checked
                  //                     ? Colors.green
                  //                     : Colors.transparent,
                  //               ),
                  //               child: provider.trackBoolItems[0].checked
                  //                   ? Icon(
                  //                       Icons.check,
                  //                       color: Colors.white,
                  //                       size: (context.isBrowserMobile)
                  //                           ? 30.sp
                  //                           : 18.sp,
                  //                     )
                  //                   : null,
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //   return InkWell(
                  // onTap: () {
                  //   provider.toggleTrackItem(item.trackType.value, !item.checked);
                  // },
                  //     splashColor: Colors.transparent,
                  //     highlightColor: Colors.transparent,
                  //     child: Column(
                  //       children: [
                  //         horizontalDivider(height: 15),
                  //         // Divider(color: AppColors.greyColor.withValues(alpha: 0.2)),

                  //       ],
                  //     ),
                  //   );
                  // }).toList(),
                  horizontalDivider(),
                  //* Placed at last start Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 19.w),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        provider.togglePlacedLastStart(!provider.placedLastStart);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Placed last start",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 36.sp
                                  : 16.sp,
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
                                    size: (context.isBrowserMobile)
                                        ? 30.sp
                                        : 18.sp,
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
                    items: provider.distanceDetails ?? [],
                    selectedValue: provider.selectedPlaceAtDistance,
                    // selectedValue: "Placed at distance",
                    onChange: (selectedValue) {
                      provider.setSelectedPlaceAtDistance = selectedValue;
                    },
                    hintText: "Placed at distance",
                  ),
                  horizontalDivider(),
                  //* Wins at distance Section
                  AppTextFieldDropdown(
                    margin: EdgeInsets.symmetric(vertical: 20.w),
                    items: provider.distanceDetails ?? [],
                    selectedValue: provider.selectedPlaceAtTrack,
                    // selectedValue: "Placed at track",
                    onChange: (selectedValue) {
                      provider.setSelectedPlaceAtTrack = selectedValue;
                    },
                    hintText: "Placed at track",
                  ),
                  //* Odds range Section
                  horizontalDivider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: AppTextField(
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: provider.oddsRangeCtr,
                      hintText: "Odds Range",
                    ),
                  ),
                  horizontalDivider(),
                  //* Win at track Section
                  AppTextFieldDropdown(
                    margin: EdgeInsets.symmetric(vertical: 20.w),
                    items: provider.trackDetails ?? [],
                    selectedValue: provider.selectedWinsAtTrack,
                    onChange: (selectedValue) {
                      provider.setSelectedWinsAtTrack = selectedValue;
                    },
                    hintText: "Win at track",
                  ),
                  horizontalDivider(),
                  AppTextFieldDropdown(
                    items: provider.distanceDetails ?? [],
                    selectedValue: provider.selectedWinsAtDistance,
                    onChange: (selectedValue) {
                      provider.setSelectedWinsAtDistance = selectedValue;
                    },
                    margin: EdgeInsets.symmetric(vertical: 20.w),
                    hintText: "Wins at distance",
                  ),
                  horizontalDivider(),
                  //* Won last start Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.w),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        provider.toggleWonLastStart(!provider.wonLastStart);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Won last start",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 36.sp
                                  : 16.sp,
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
                                    size: (context.isBrowserMobile)
                                        ? 30.sp
                                        : 18.sp,
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
                      onTap: () {
                        provider.toggleWonLast12Months(!provider.wonLast12Months);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Won last 12 months",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 36.sp
                                  : 16.sp,
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
                                    size: (context.isBrowserMobile)
                                        ? 30.sp
                                        : 18.sp,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  horizontalDivider(),
                  AppTextField(
                    margin: EdgeInsets.symmetric(vertical: 20.w),
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: provider.jockeyHorseWinsCtr,
                    hintText: "Jockey horse wins",
                  ),
                  horizontalDivider(),
                  AppTextFieldDropdown(
                    margin: EdgeInsets.symmetric(vertical: 20.w),
                    selectedValue: provider.selectedBarrier,
                    onChange: (selectedValue) {
                      provider.setSelectedBarrier = selectedValue;
                    },
                    items: provider.barrierList ?? [],
                    hintText: "Barrier",
                  ),
                ],
              ),
            ),
            horizontalDivider(),
          ],
        ),
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
