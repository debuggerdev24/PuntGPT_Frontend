import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/race_details_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class SelectedMeetingScreen extends StatelessWidget {
  const SelectedMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassicFormProvider>(
      builder: (context, provider, child) {
        if (provider.raceList == null || provider.raceFieldDetail == null) {
          return HomeSectionShimmers.selectedRaceScreenShimmer(
            context: context,
          );
        }
        return Stack(
          children: [
            Column(
              children: [
                topBar(context: context, provider: provider),
                //* Race selection view
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  provider.raceList!.races.length,
                                  (index) {
                                    final race =
                                        provider.raceList!.races[index];
                                    return GestureDetector(
                                      onTap: () {
                                        provider.changeSelectedRace = index;
                                        provider.getRaceFieldDetail(
                                          id: race.raceId.toString(),
                                        );
                                      },
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 12,
                                        ),
                                        duration: 400.milliseconds,
                                        decoration: BoxDecoration(
                                          color:
                                              (provider.selectedRace == index)
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
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 16.w,
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
                              _raceSubNavBar(
                                title: 'Tips & Analysis',
                                onTap: () {
                                  provider.getTipsAndAnalysis(
                                    raceId: provider
                                        .raceFieldDetail!
                                        .race
                                        .raceId
                                        .toString(),
                                  );
                                  context.pushNamed(
                                    AppRoutes.tipsAndAnalysis.name,
                                  );
                                },
                              ),
                              _raceSubNavBar(
                                title: 'Speed Maps',
                                onTap: () {
                                  provider.getSpeedMaps(
                                    meetingId: provider
                                        .raceList!
                                        .meeting
                                        .meetingId
                                        .toString(),
                                    raceId: provider
                                        .raceFieldDetail!
                                        .race
                                        .raceId
                                        .toString(),
                                  );
                                  context.pushNamed(AppRoutes.speedMaps.name);
                                },
                              ),
                              _raceSubNavBar(
                                title: 'Barrier Map',
                                onTap: () {
                                  deBouncer.run(() {
                                    AppToast.info(
                                      context: context,
                                      message: 'Coming soon',
                                    );
                                  });
                                },
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
            //* ask punt gpt button
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.w, right: 25.w),
                child: askPuntGPTButton(context: context),
              ),
            ),
            Consumer<SearchEngineProvider>(
              builder: (context, provider, child) {
                if (provider.isCreatingTipSlip) {
                  return FullPageIndicator();
                }
                return Container();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _raceSubNavBar({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(title, style: semiBold(fontSize: 14.sp)),
    );
  }

  Widget topBar({
    required ClassicFormProvider provider,
    required BuildContext context,
  }) {
    final meeting = provider.raceList!.meeting;
    final races = provider.raceList!.races;
    if (races.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(6.w, 6.w, 10.w, 6.w),
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
                      height: 1,
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
          padding: EdgeInsets.fromLTRB(6.w, 7.w, 25.w, 7.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
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
                        height: 1.2,
                      ),
                    ),
                    Text(
                      "PuntGPT Legends Stakes ${race.distance} ${race.distanceUnits}, ${DateFormatter.formatRaceDateTime(race.startTimeUtc)}",
                      style: semiBold(
                        fontSize: 14.sp,
                        color: AppColors.primary.withValues(alpha: 0.6),
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
  final ClassicFormProvider provider;

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
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          columnWidths: {0: FlexColumnWidth(1.7.w), 1: FlexColumnWidth(4.5.w)},
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
                            vertical: 10.w,
                            horizontal: 8.w,
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
                                12.w.verticalSpace,
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
                                  onTap: () {
                                    context
                                        .read<SearchEngineProvider>()
                                        .createTipSlip(
                                          context: context,
                                          selectionId: selection.selectionId
                                              .toString(),
                                        );
                                  },
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

  static String _formatStat(HorseStatsDetails value) {
    // if (value == null) return '—';
    final runs = value.runs;
    final wins = value.wins;
    final seconds = value.seconds;
    final thirds = value.thirds;
    final winPercentage = value.winPercentage;
    final placePercentage = value.placePercentage;
    final roi = value.roi;
    final parts = <String>[];
    parts.add('runs: $runs');
    parts.add('wins: $wins');
    parts.add('seconds: $seconds');
    parts.add('thirds: $thirds');
    parts.add('winPercentage: $winPercentage');
    parts.add('placePercentage: $placePercentage');
    parts.add('roi: $roi');
    Logger.info(
      'HorseStatsDetails: $runs, $wins, $seconds, $thirds, $winPercentage, $placePercentage, $roi',
    );
    if (parts.isEmpty) return value.toString();
    return parts.join(', ');
    // return value.toString();
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${e.key}: ',
                  style: bold(fontSize: 15.sp, color: AppColors.primary),
                ),
                Expanded(
                  child: Text(
                    e.value,
                    style: medium(fontSize: 14.sp, color: AppColors.primary),
                  ),
                ),
              ],
            ),

            // Text.rich(
            //   TextSpan(
            //     children: [
            //       TextSpan(
            //         text: '${e.key}: ',
            //         style: bold(fontSize: 15.sp, color: AppColors.primary),
            //       ),
            //       TextSpan(
            //         text: '${e.value}',
            //         style: medium(fontSize: 14.sp, color: AppColors.primary),
            //       ),
            //     ],
            //   ),
            //   softWrap: true,
            //   overflow: TextOverflow.ellipsis,
            //   maxLines: 3,
            // ),
          ],
        ],
      ),
    );
  }
}
