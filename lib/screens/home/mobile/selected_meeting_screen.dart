import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/utils/date_formater.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';

import 'package:puntgpt_nick/models/classic_form_guide/race_details_model.dart';
import 'package:puntgpt_nick/provider/classic_form/classic_form_guide_provider.dart';
import 'package:puntgpt_nick/screens/home/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/home_section_shimmers.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_style.dart';
import '../../../core/widgets/app_devider.dart';

class SelectedMeetingScreen extends StatefulWidget {
  const SelectedMeetingScreen({super.key});

  @override
  State<SelectedMeetingScreen> createState() => _SelectedMeetingScreenState();
}

class _SelectedMeetingScreenState extends State<SelectedMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClassicFormGuideProvider>(
      builder: (context, provider, child) {
        if (provider.meetingRace == null || provider.raceFieldDetail == null) {
          return selectedRaceScreenShimmer(context: context);
        }
        return Stack(
          children: [
            Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.fromLTRB(25.w, 16.h, 25.w, 0),
                //   child: HomeScreenTab(
                //     selectedIndex: provider.selectedTab,
                //     onTap: () {
                //       context.pop();
                //     },
                //   ),
                // ),
                topBar(context: context, provider: provider),
                //* Race selection view
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            children: List.generate(
                              provider.meetingRace!.races.length,
                              (index) {
                                final race = provider.meetingRace!.races[index];
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      provider.changeSelectedRace = index;
                                      provider.getRaceFieldDetail(
                                        id: race.raceId.toString(),
                                      );
                                    },
                                    child: AnimatedContainer(
                                      padding: EdgeInsetsGeometry.symmetric(
                                        vertical: 12,
                                      ),
                                      alignment: AlignmentGeometry.center,
                                      duration: 400.milliseconds,
                                      decoration: BoxDecoration(
                                        color: (provider.selectedRace == index)
                                            ? AppColors.primary
                                            : null,
                                      ),
                                      child: Text(
                                        "R${index + 1}",
                                        style: semiBold(
                                          fontSize: 16.sp,
                                          color:
                                              (provider.selectedRace == index)
                                              ? AppColors.white
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 16.h,
                            horizontal: 25.w,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tips & Analysis",
                                style: semiBold(fontSize: 14.sp),
                              ),
                              Text(
                                "Speed Maps",
                                style: semiBold(fontSize: 14.sp),
                              ),
                              Text(
                                "Sectionals",
                                style: semiBold(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                        SelectedRaceTable(provider: provider),
                        120.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //todo ask punt gpt button
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.h, right: 25.w),
                child: askPuntGPTButton(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget topBar({
    required ClassicFormGuideProvider provider,
    required BuildContext context,
  }) {
    final meeting = provider.meetingRace!.meeting;
    final races = provider.meetingRace!.races;
    if (races.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(6.w, 8, 25.w, 20.w),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
                ),
                Expanded(
                  child: Text(
                    meeting.name,
                    style: regular(
                      fontSize: 24.sp,
                      fontFamily: AppFontFamily.secondary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          horizontalDivider(),
        ],
      );
    }
    final safeIndex = provider.selectedRace.clamp(0, races.length - 1);
    final race = races[safeIndex];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(6.w, 8, 25.w, 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.name,
                      style: regular(
                        fontSize: 24.sp,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.35,
                      ),
                    ),
                    Text(
                      "PuntGPT Legends Stakes ${race.distance} ${race.distanceUnits}, ${DateFormatter.formatRaceDateTime(race.startTimeUtc)}",
                      style: semiBold(
                        fontSize: 14.sp,
                        color: AppColors.greyColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}

class SelectedRaceTable extends StatefulWidget {
  const SelectedRaceTable({super.key, required this.provider});
  final ClassicFormGuideProvider provider;

  @override
  State<SelectedRaceTable> createState() => _SelectedRaceTableState();
}

class _SelectedRaceTableState extends State<SelectedRaceTable> {
  int? expandedIndex;

  @override
  void didUpdateWidget(SelectedRaceTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selections = widget.provider.raceFieldDetail?.selections ?? [];
    if (expandedIndex != null &&
        (selections.isEmpty || expandedIndex! >= selections.length)) {
      expandedIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selections = widget.provider.raceFieldDetail!.selections;
    final safeExpandedIndex =
        expandedIndex != null && expandedIndex! < selections.length
        ? expandedIndex
        : null;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Container(
        width: 1.4.sw,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          columnWidths: {0: FlexColumnWidth(1.6), 1: FlexColumnWidth(5)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: List.generate(selections.length, (index) {
            final selection = selections[index];
            final isExpanded = safeExpandedIndex == index;
            return TableRow(
              children: [
                //* first column
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,

                  child: IntrinsicHeight(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedIndex = isExpanded ? null : index;
                        });
                      },

                      child: Container(
                        // alignment: Alignment.,
                        color: isExpanded
                            ? AppColors.primary
                            : Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ${selections[index].horseName}",
                                style: semiBold(
                                  fontSize: 16.sp,
                                  color: isExpanded ? Colors.white : null,
                                ),
                              ),
                              if (isExpanded) ...[
                                12.h.verticalSpace,
                                Text(
                                  "\$${selection.oddsWin}",
                                  style: semiBold(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                AppFilledButton(
                                  margin: EdgeInsets.only(top: 4),
                                  text: "Add to Tip Slip",
                                  textStyle: semiBold(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 9.h),
                                  color: AppColors.white,
                                  onTap: () {},
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //* second column
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.w,

                      horizontal: 12.w,
                    ),
                    child: isExpanded
                        ? _ExpandedStatsContent(
                            selection: selection,
                            distance:
                                widget.provider.raceFieldDetail!.race.distance,
                          )
                        : Text(
                            "W: J: F: T:",
                            style: medium(
                              fontSize: 14.sp,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Widget _buildDetailBox(String label) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
  //       borderRadius: BorderRadius.circular(6.r),
  //     ),
  //     child: Text(
  //       label,
  //       style: semiBold(fontSize: 13.sp, color: AppColors.primary),
  //     ),
  //   );
  // }
}

class _ExpandedStatsContent extends StatelessWidget {
  const _ExpandedStatsContent({
    required this.selection,
    required this.distance,
  });
  final Selection selection;
  final int distance;

  static String _formatStat(dynamic value) {
    if (value == null) return '—';
    if (value is Map) {
      final runs = value['runs'];
      final wins = value['wins'];
      final seconds = value['seconds'];
      final thirds = value['thirds'];
      final parts = <String>[];
      if (runs != null) parts.add('runs: $runs');
      if (wins != null) parts.add('wins: $wins');
      if (seconds != null) parts.add('seconds: $seconds');
      if (thirds != null) parts.add('thirds: $thirds');
      if (parts.isEmpty) return value.toString();
      return parts.join(', ');
    }
    return value.toString();
  }

  static String _formatForm(List<FormHistory> formHistory) {
    if (formHistory.isEmpty) return '—';
    return formHistory.map((f) => f.resultPosition.toString()).join('-');
  }

  @override
  Widget build(BuildContext context) {
    final trainerStr =
        trainerNameValues.reverse[selection.trainerName] ??
        '${selection.trainerName}';
    final trackStr =
        trackNameValues.reverse[selection.trackName] ??
        '${selection.trackName}';
    final rows = <String, String>{
      'Weight': '${selection.weight}',
      'Jockey': selection.jockeyName,
      'Form': _formatForm(selection.formHistory),
      'Trainer': trainerStr,
      'Career': _formatStat(selection.horseStats.career),
      'Track': trackStr,
      'Distance': '$distance',
      '1st up': _formatStat(selection.horseStats.firstUp),
      '2nd up': _formatStat(selection.horseStats.secondUp),
      '3rd up': _formatStat(selection.horseStats.thirdUp),
      'Firm': _formatStat(selection.horseStats.firm),
      'Soft': _formatStat(selection.horseStats.soft),
      'Heavy': _formatStat(selection.horseStats.heavy),
    };
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final e in rows.entries) ...[
            if (e.key != rows.keys.first) 8.h.verticalSpace,
            Text(
              '${e.key}: ${e.value}',
              style: medium(fontSize: 14.sp, color: AppColors.primary),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }
}
