import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/tip_slip.dart';

class TipSlipScreen extends StatelessWidget {
  const TipSlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        final tipSlips = provider.tipSlips;
        if (tipSlips == null) {
          return HomeSectionShimmers.tipSlipScreenShimmer(context: context);
        }
        return Column(
          children: [
            topBar(context),

            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 10.w),
                child: tipSlips.isEmpty
                    ? _buildEmptyState(context)
                    : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        itemCount: tipSlips.length,
                        itemBuilder: (context, index) {
                          final tipSlip = tipSlips[index];
                          return TipSlipItem(
                            tipSlip: tipSlip,
                            isExpanded: provider.expandedTipSlipId == tipSlip.id,
                            onTap: () => provider.toggleTipSlipExpand(tipSlip.id),
                            onRemove: () {
                              final removedId = tipSlips[index].id;
                              if (provider.expandedTipSlipId == removedId) {
                                provider.toggleTipSlipExpand(removedId);
                              }
                              provider.removeTipSlipAt(index);
                              AppToast.success(
                                context: context,
                                message: "Removed from tip slip successfully",
                              );
                              provider.removeFromTipSlip(
                                tipSlipId: removedId.toString(),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    AppFilledButton(
                      margin: EdgeInsets.only(top: 8, bottom: 12.h),
                      text: "Play Fantasy Picks (4)",
                      textStyle: semiBold(
                        fontSize: 16.sixteenSp(context),
                        color: AppColors.white,
                      ),
                      onTap: () {},
                    ),

                    Text(
                      "Upgrade to Pro Punter",
                      style: bold(
                        fontSize: 14.fourteenSp(context),
                        color: AppColors.premiumYellow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative icon container
            Container(
              // width: 120.w,
              padding: EdgeInsets.all(25.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.04),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.bookmark_border_rounded,
                  size: 56.sp,
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
            ),
            20.w.verticalSpace,
            Text(
              "Your tip slip is empty",
              textAlign: TextAlign.center,
              style: bold(
                fontSize: context.isBrowserMobile ? 36.sp : 22.sp,
                color: AppColors.primary,
              ),
            ),
            12.w.verticalSpace,
            Text(
              "Add picks from races to build your slip and track your selections",
              textAlign: TextAlign.center,
              style: regular(
                fontSize: context.isBrowserMobile ? 28.sp : 14.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
                height: 1.4,
              ),
            ),

            // Dashed placeholder card
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 15.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 20.sp,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                  10.w.horizontalSpace,
                  Text(
                    "Your picks will appear here",
                    style: medium(
                      fontSize: context.isBrowserMobile ? 26.sp : 13.sp,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            // 36.h.verticalSpace,
            // AppFilledButton(
            //   width: double.infinity,
            //   margin: EdgeInsets.symmetric(horizontal: 24.w),
            //   text: "Browse Races",
            //   textStyle: semiBold(
            //     fontSize: 16.sixteenSp(context),
            //     color: AppColors.white,
            //   ),
            //   onTap: () {
            //     context.pop();
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  // RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: "Use Code: ",
                    //         style: bold(
                    //           fontSize: 14.fourteenSp(context),
                    //           fontFamily: AppFontFamily.primary,
                    //         ),
                    //       ),
                    //       TextSpan(
                    //         text: "‘PUNTGPT’",
                    //         style: bold(
                    //           fontSize: 14.fourteenSp(context),
                    //           color: Color(0xffE5B82E),
                    //           fontFamily: AppFontFamily.primary,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

  // Widget tipSlipItem({required BuildContext context}) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 8.h),
  //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
  //     decoration: BoxDecoration(border: Border.all(color: AppColors.primary)),
  //     child: Row(
  //       children: [
  //         //todo -----------> check box
  //         AnimatedContainer(
  //           duration: const Duration(milliseconds: 250),
  //           curve: Curves.easeInOut,
  //           width: 22,
  //           height: 22,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(1),
  //             color: AppColors.primary,
  //           ),
  //           child: const Icon(Icons.check, color: Colors.white, size: 16),
  //         ),
  //         context.isBrowserMobile ? 90.w.horizontalSpace : 15.w.horizontalSpace,

  //* -----------> title
  //         Text("8. Delicacy", style: semiBold(fontSize: context.isBrowserMobile ? 34.sp : 20.sp)),
  //         10.horizontalSpace,
  //         Icon(Icons.keyboard_arrow_down_rounded),
  //         Spacer(),
  //         Text("\$8.50", style: bold(fontSize: context.isBrowserMobile ? 34.sp : 20.sp)),
  //       ],
  //     ),
  //   );
  // }

  // Widget tipSlipItem({
  //   required BuildContext context,
  //   required TipSlipModel tipSlip,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  //   VoidCallback? onRemove,
  // }) {
  //   final selection = tipSlip.selection;
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 12.h),
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: isSelected
  //             ? AppColors.primary
  //             : AppColors.primary.withValues(alpha: 0.3),
  //         width: isSelected ? 2 : 1,
  //       ),
  //       borderRadius: BorderRadius.circular(8.r),
  //       color: isSelected
  //           ? AppColors.primary.withValues(alpha: 0.05)
  //           : Colors.white,
  //     ),
  //     child: Column(
  //       children: [
  //         // Main content
  //         InkWell(
  //           onTap: onTap,
  //           borderRadius: BorderRadius.circular(8.r),
  //           child: Padding(
  //             padding: EdgeInsets.all(12.w),
  //             child: Row(
  //               children: [
  //                 //* Checkbox
  //                 AnimatedContainer(
  //                   duration: const Duration(milliseconds: 250),
  //                   curve: Curves.easeInOut,
  //                   width: 24.w,
  //                   height: 24.w,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(4.r),
  //                     color: isSelected
  //                         ? AppColors.primary
  //                         : Colors.transparent,
  //                     border: Border.all(
  //                       color: isSelected
  //                           ? AppColors.primary
  //                           : AppColors.primary.withValues(alpha: 0.4),
  //                       width: 2,
  //                     ),
  //                   ),
  //                   child: isSelected
  //                       ? const Icon(Icons.check, color: Colors.white, size: 16)
  //                       : null,
  //                 ),

  //                 12.w.horizontalSpace,

  //                 //* Silks Image
  //                 _buildSilksOrPlaceholder(
  //                   silksImage: selection.silksImage,
  //                   number: selection.number,
  //                   context: context,
  //                 ),

  //                 12.w.horizontalSpace,

  //                 // Horse Details
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Text(
  //                             '${selection.number}. ',
  //                             style: semiBold(
  //                               fontSize: context.isBrowserMobile
  //                                   ? 32.sp
  //                                   : 16.sp,
  //                               color: AppColors.primary,
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: Text(
  //                               selection.horseName,
  //                               style: semiBold(
  //                                 fontSize: context.isBrowserMobile
  //                                     ? 32.sp
  //                                     : 16.sp,
  //                                 color: AppColors.primary,
  //                               ),
  //                               overflow: TextOverflow.ellipsis,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       4.h.verticalSpace,
  //                       Text(
  //                         'R${selection.raceNumber} • ${selection.trackName}',
  //                         style: regular(
  //                           fontSize: context.isBrowserMobile ? 26.sp : 13.sp,
  //                           color: AppColors.primary.withValues(alpha: 0.7),
  //                         ),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ],
  //                   ),
  //                 ),

  //                 12.w.horizontalSpace,

  //                 // Odds
  //                 Container(
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: 12.w,
  //                     vertical: 6.h,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: AppColors.primary.withValues(alpha: 0.1),
  //                     borderRadius: BorderRadius.circular(4.r),
  //                   ),
  //                   child: Text(
  //                     '\$${selection.unibetFixedOddsWin}',
  //                     style: bold(
  //                       fontSize: context.isBrowserMobile ? 32.sp : 16.sp,
  //                       color: AppColors.primary,
  //                     ),
  //                   ),
  //                 ),

  //                 // Remove button
  //                 if (onRemove != null) ...[
  //                   8.w.horizontalSpace,
  //                   IconButton(
  //                     padding: EdgeInsets.zero,
  //                     constraints: BoxConstraints(
  //                       minWidth: 32.w,
  //                       minHeight: 32.w,
  //                     ),
  //                     icon: Icon(
  //                       Icons.close,
  //                       size: 18.sp,
  //                       color: AppColors.primary.withValues(alpha: 0.6),
  //                     ),
  //                     onPressed: onRemove,
  //                   ),
  //                 ],
  //               ],
  //             ),
  //           ),
  //         ),

  //         // Expandable details (if selected)
  //         if (isSelected) ...[
  //           Divider(height: 1, color: AppColors.primary.withValues(alpha: 0.2)),
  //           Padding(
  //             padding: EdgeInsets.all(12.w),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.person_outline,
  //                       size: 14.sp,
  //                       color: AppColors.primary.withValues(alpha: 0.6),
  //                     ),
  //                     6.w.horizontalSpace,
  //                     Text(
  //                       selection.jockeyName,
  //                       style: regular(
  //                         fontSize: context.isBrowserMobile ? 26.sp : 13.sp,
  //                         color: AppColors.primary.withValues(alpha: 0.8),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 6.h.verticalSpace,
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.access_time,
  //                       size: 14.sp,
  //                       color: AppColors.primary.withValues(alpha: 0.6),
  //                     ),
  //                     6.w.horizontalSpace,
  //                     Text(
  //                       DateFormatter.formatRaceDateTime(
  //                         selection.startTimeUtc.toIso8601String(),
  //                       ),
  //                       style: regular(
  //                         fontSize: context.isBrowserMobile ? 26.sp : 13.sp,
  //                         color: AppColors.primary.withValues(alpha: 0.8),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 8.h.verticalSpace,
  //                 Text(
  //                   selection.raceName,
  //                   style: medium(
  //                     fontSize: context.isBrowserMobile ? 24.sp : 12.sp,
  //                     color: AppColors.primary.withValues(alpha: 0.7),
  //                   ),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 6.w, 25.w, 8.w),

          // padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 25.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // spacing: 14.w,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tip Slip",
                    style: regular(
                      fontSize: (context.isBrowserMobile) ? 48.sp : 24.sp,
                      fontFamily: AppFontFamily.secondary,
                      height: 1.35,
                    ),
                  ),
                  Text(
                    "Your selected picks for the next race",
                    style: medium(
                      fontSize: 14.fourteenSp(context),
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),

              25.h.verticalSpace,
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}
