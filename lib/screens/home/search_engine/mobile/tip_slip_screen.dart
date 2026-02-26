import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/tip_slip_model.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class TipSlipScreen extends StatelessWidget {
  const TipSlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) {
        final tipSlips = provider.tipSlips;
        if (tipSlips != null) {
          return tipSlipScreenShimmer(context: context);
        }
        return Column(
          children: [
            topBar(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 10.w),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        itemCount: tipSlips!.length,
                        itemBuilder: (context, index) {
                          final tipSlip = tipSlips[index];
                          return tipSlipItem(
                            context: context,
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
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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

  //         //* -----------> title
  //         Text("8. Delicacy", style: semiBold(fontSize: context.isBrowserMobile ? 34.sp : 20.sp)),
  //         10.horizontalSpace,
  //         Icon(Icons.keyboard_arrow_down_rounded),
  //         Spacer(),
  //         Text("\$8.50", style: bold(fontSize: context.isBrowserMobile ? 34.sp : 20.sp)),
  //       ],
  //     ),
  //   );
  // }

  Widget tipSlipItem({
    required BuildContext context,
    required TipSlipModel tipSlip,
    required bool isExpanded,
    required VoidCallback onTap,
    VoidCallback? onRemove,
  }) {
    final selection = tipSlip.selection;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: isExpanded
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.3),
          width: isExpanded ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
        color: isExpanded
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main content
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  // AnimatedContainer(
                  //   duration: const Duration(milliseconds: 250),
                  //   curve: Curves.easeInOut,
                  //   width: 24.w,
                  //   height: 24.w,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(4.r),
                  //     color: isSelected
                  //         ? AppColors.primary
                  //         : Colors.transparent,
                  //     border: Border.all(
                  //       color: isSelected
                  //           ? AppColors.primary
                  //           : AppColors.primary.withValues(alpha: 0.4),
                  //       width: 2,
                  //     ),
                  //   ),
                  //   child: isSelected
                  //       ? const Icon(Icons.check, color: Colors.white, size: 16)
                  //       : null,
                  // ),

                  12.w.horizontalSpace,

                  //* Silks Image
                  _buildSilksOrPlaceholder(
                    silksImage: selection.silksImage,
                    number: selection.number,
                    context: context,
                  ),

                  12.w.horizontalSpace,

                  // Horse Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${selection.number}. ',
                              style: semiBold(
                                fontSize: context.isBrowserMobile
                                    ? 32.sp
                                    : 16.sp,
                                color: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                selection.horseName,
                                style: semiBold(
                                  fontSize: context.isBrowserMobile
                                      ? 32.sp
                                      : 16.sp,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        4.h.verticalSpace,
                        Text(
                          'R${selection.raceNumber} • ${selection.trackName}',
                          style: regular(
                            fontSize: context.isBrowserMobile ? 26.sp : 13.sp,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  12.w.horizontalSpace,

                  // Odds
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '\$${selection.unibetFixedOddsWin}',
                      style: bold(
                        fontSize: context.isBrowserMobile ? 32.sp : 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  // Remove button
                  if (onRemove != null) ...[
                    8.w.horizontalSpace,
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 32.w,
                        minHeight: 32.w,
                      ),
                      icon: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                      onPressed: onRemove,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Expandable details (accordion - only one at a time)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        height: 1,
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Race Name
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                selection.raceName,
                                style: medium(
                                  fontSize: context.isBrowserMobile ? 24.sp : 12.sp,
                                  color: AppColors.primary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            12.h.verticalSpace,
                            // Race Time
                            _buildDetailRow(
                              context: context,
                              icon: Icons.access_time,
                              label: 'Race Time',
                              value: DateFormatter.formatRaceDateTime(
                                selection.startTimeUtc.toIso8601String(),
                              ),
                            ),
                            8.h.verticalSpace,
                            // Jockey
                            _buildDetailRow(
                              context: context,
                              icon: Icons.person_outline,
                              label: 'Jockey',
                              value: selection.jockeyName,
                            ),
                            8.h.verticalSpace,
                            // Trainer
                            _buildDetailRow(
                              context: context,
                              icon: Icons.school_outlined,
                              label: 'Trainer',
                              value: selection.trainerName,
                            ),
                            8.h.verticalSpace,
                            // Track
                            _buildDetailRow(
                              context: context,
                              icon: Icons.location_on_outlined,
                              label: 'Track',
                              value: selection.trackName,
                            ),
                            12.h.verticalSpace,
                            // Added timestamp
                            Row(
                              children: [
                                Icon(
                                  Icons.bookmark_added_outlined,
                                  size: 13.sp,
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                ),
                                6.w.horizontalSpace,
                                Text(
                                  'Added ${_formatAddedTime(tipSlip.addedAt)}',
                                  style: regular(
                                    fontSize: context.isBrowserMobile ? 22.sp : 11.sp,
                                    color: AppColors.primary.withValues(alpha: 0.5),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
        8.w.horizontalSpace,
        Text(
          '$label: ',
          style: semiBold(
            fontSize: context.isBrowserMobile ? 24.sp : 12.sp,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: regular(
              fontSize: context.isBrowserMobile ? 24.sp : 12.sp,
              color: AppColors.primary.withValues(alpha: 0.9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper function to format "added at" time
  String _formatAddedTime(DateTime addedAt) {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormatter.formatToIso(
        DateTime.parse(addedAt.toIso8601String()),
      );
    }
  }

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

  Widget _buildSilksOrPlaceholder({
    required String silksImage,
    required int number,
    required BuildContext context,
  }) {
    final hasValidSilks = silksImage.trim().isNotEmpty;
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: hasValidSilks
            ? ImageWidget(
                path: silksImage,
                type: ImageType.svg,
                errorWidget: _silksPlaceholder(number: number),
              )
            : _silksPlaceholder(number: number),
      ),
    );
  }

  Widget _silksPlaceholder({required int number}) => Container(
    color: AppColors.primary.withValues(alpha: 0.08),
    alignment: Alignment.center,
    child: Text(
      '$number',
      style: semiBold(fontSize: 16.sp, color: AppColors.primary),
    ),
  );

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 25.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 14.w,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
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
                      color: AppColors.greyColor.withValues(alpha: 0.6),
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
