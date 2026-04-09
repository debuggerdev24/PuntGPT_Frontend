import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
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
        if (provider.raceList == null || provider.raceDetails == null) {
          return HomeSectionShimmers.selectedRaceScreenShimmer(
            context: context,
          );
        }
        return Stack(
          children: [
            Column(
              children: [
                _topBar(context: context, provider: provider),
                //* Race selection view
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.w, 25.w, 25.w, 0),
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
                        //* Tips & Analysis, Speed Maps, Barrier Map
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 16.w,
                            horizontal: 25.w,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.w,
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
                                    raceId: provider.raceDetails!.raceId
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
                                    raceId: provider.raceDetails!.raceId
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
                        //* Race table
                        RaceDetails(provider: provider),
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

  Widget _topBar({
    required ClassicFormProvider provider,
    required BuildContext context,
  }) {
    final race = provider.raceDetails!;
    final meeting = provider.raceList!.meeting;
    // if (races.isEmpty) {
    //   return Column(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.fromLTRB(6.w, 6.w, 10.w, 6.w),
    //         child: Row(
    //           children: [
    //             IconButton(
    //               padding: EdgeInsets.zero,
    //               onPressed: () => context.pop(),
    //               icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
    //             ),
    //             Expanded(
    //               child: Text(
    //                 meeting.name,
    //                 style: regular(
    //                   fontSize: 24.sp,
    //                   fontFamily: AppFontFamily.secondary,
    //                   height: 1,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       horizontalDivider(),
    //     ],
    //   );
    // }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(2.w, 7.w, 2.w, 7.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.name,
                      style: regular(
                        fontSize: (context.isBrowserMobile) ? 36.sp : 24.sp,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.1,
                      ),
                    ),
                    1.w.verticalSpace,
                    Text(
                      "${meeting.trackName} - R${race.number} - ${race.name}",
                      style: semiBold(
                        fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                    2.w.verticalSpace,
                    Text(
                      "${race.trackCondition} - ${race.distance}m - ${DateFormatter.formatRaceDateTime(race.australianTime)}",
                      style: semiBold(
                        fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
                        height: 1.2,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                    2.w.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );

    // return Column(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.fromLTRB(6.w, 7.w, 25.w, 7.w),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           IconButton(
    //             padding: EdgeInsets.zero,
    //             onPressed: () {
    //               context.pop();
    //             },
    //             icon: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
    //           ),
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   meeting.name,
    //                   style: regular(
    //                     fontSize: 24.sp,
    //                     fontFamily: AppFontFamily.secondary,
    //                     height: 1.2,
    //                   ),
    //                 ),
    //                 Text(
    //                   "PuntGPT Legends Stakes ${race.distance} ${race.distanceUnits}, ${DateFormatter.formatRaceDateTime(race.startTimeUtc)}",
    //                   style: semiBold(
    //                     fontSize: 14.sp,
    //                     color: AppColors.primary.withValues(alpha: 0.6),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     horizontalDivider(),
    //   ],
    // );
  }
}

class RaceDetails extends StatefulWidget {
  const RaceDetails({super.key, required this.provider});
  final ClassicFormProvider provider;

  @override
  State<RaceDetails> createState() => _RaceDetailsState();
}

class _RaceDetailsState extends State<RaceDetails> {
  @override
  Widget build(BuildContext context) {
    final selections = widget.provider.raceDetails!.selections;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: selections.length,
      separatorBuilder: (_, __) => 10.w.verticalSpace,
      itemBuilder: (context, index) {
        final selection = selections[index];
        return _selectionCard(
          context: context,
          index: index,
          selection: selection,
          onOpenDetail: () =>
              _openSelectionDetailDialog(context, selection, index),
        );
      },
    );
  }

  void _openSelectionDetailDialog(
    BuildContext context,
    Selection selection,
    int index,
  ) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: AppColors.white,
      // Let the sheet fill the screen; inner [SafeArea] keeps content clear of notch/status bar.
      // useSafeArea: true,
      isScrollControlled: true,
      builder: (dialogContext) {
        final sheetH = MediaQuery.sizeOf(dialogContext).height - 95.w;
        return SizedBox(
          height: sheetH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //*Bottom sheet dialogue title
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 4.w, 5.w, 2.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${index + 1}. ${selection.horseName} (${selection.barrier})',
                        style: semiBold(
                          fontSize: (context.isBrowserMobile) ? 30.sp : 16.sp,
                          color: AppColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.primary,
                        size: (context.isBrowserMobile) ? 28.w : 24.w,
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ),
              horizontalDivider(),
              //* Bottom sheet body
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 12.w, 22.w, 2.w),
                  child: _SelectionDetailes(selection: selection),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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

Widget _pill({
  required String text,
  required BuildContext context,
  Color? bg,
  Color? fg,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.w),
    decoration: BoxDecoration(
      color: bg ?? AppColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
    ),
    child: Text(
      text,
      style: semiBold(
        fontSize: 12.sp,
        color: fg ?? AppColors.primary.withValues(alpha: 0.85),
      ),
    ),
  );
}

Widget _detailLabelValue({
  required String label,
  required String value,
  int maxLines = 4,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label : ',
        style: bold(fontSize: 12.sp, color: AppColors.primary),
      ),
      Expanded(
        child: Text(
          value,
          style: semiBold(
            fontSize: 12.sp,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
          maxLines: maxLines,
        ),
      ),
    ],
  );
}

/// Accent for track condition / distance line (reference-style blue).

Color _kFormHistoryTrackBlue = Color(0xFF1565C0);

class _FormHistoryCard extends StatelessWidget {
  const _FormHistoryCard({required this.history});

  final History history;

  String _ordinalPlace(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  String _historyResultHeadline(History h) {
    final pos = h.resultPosition;
    final total = h.totalStarters;
    if (pos == null || total == null) return '—';
    final ord = _ordinalPlace(pos);
    if (h.isTrial) {
      return 'TRIAL: $ord of $total';
    }
    return '$ord of $total';
  }

  String _historyDateCompact(History h) =>
      DateFormat('dd MMM, yyyy').format(h.date.toLocal());

  String _historyConditionDistanceLine(History h) {
    final cond = (h.trackCondition ?? '').trim();
    final d = h.distance;
    final dist = d != null ? '${d}m' : '';
    if (cond.isEmpty && dist.isEmpty) return '—';
    if (cond.isEmpty) return dist;
    if (dist.isEmpty) return cond;
    return '$cond $dist';
  }

  String _historyDetailBody(History h) {
    // final summary = h.positionSummary?.trim();
    // if (summary != null && summary.isNotEmpty) return summary;
    final parts = <String>[];
    final race = h.raceName?.trim();
    if (race != null && race.isNotEmpty) parts.add(race);
    final j = h.jockeyName;
    if (j != null && j.isNotEmpty) parts.add(j);
    final w = h.weightCarried?.trim();
    if (w != null && w.isNotEmpty) parts.add("$w kg");
    final m = h.margin?.trim();
    if (m != null && m.isNotEmpty) parts.add("$m margin");
    final pm = h.prizeMoney?.trim();
    if (pm != null && pm.isNotEmpty) parts.add("$pm/-");
    final b = h.barrier;
    if (b != null) parts.add('Bar $b');
    final sp = h.startingPrice?.trim();
    if (sp != null && sp.isNotEmpty) parts.add('SP $sp');
    final win = h.winnerHorseName?.trim();
    if (win != null && win.isNotEmpty) parts.add(win);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final h = history;
    final resultLine = _historyResultHeadline(h);
    final dateLine = _historyDateCompact(h);

    final condDist = _historyConditionDistanceLine(h);
    final detail = _historyDetailBody(h);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.w, 14.w, 0.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (h.isTrial) ...[
                      Icon(
                        Icons.schedule_rounded,
                        size: 18.w,
                        color: AppColors.primary.withValues(alpha: 0.85),
                      ),
                      6.w.horizontalSpace,
                    ],
                    Expanded(
                      child: Text(
                        resultLine,
                        style: bold(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                dateLine,
                style: semiBold(
                  fontSize: 12.sp,
                  color: AppColors.primary.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),

          6.w.verticalSpace,
          Text(
            "${history.trackName ?? "-"}  R${history.raceNumber ?? "-"}",
            style: semiBold(
              fontSize: 14.sp,
              color: AppColors.primary,
              height: 1.2,
            ),
          ),
          4.w.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.waves_rounded,
                size: 18.w,
                color: _kFormHistoryTrackBlue,
              ),
              6.w.horizontalSpace,
              Expanded(
                child: Text(
                  condDist,
                  style: semiBold(
                    fontSize: 12.5.sp,
                    color: _kFormHistoryTrackBlue,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          if (detail.isNotEmpty) ...[
            10.w.verticalSpace,
            Text(
              detail,
              style: semiBold(
                fontSize: 11.sp,
                color: AppColors.primary.withValues(alpha: 0.48),
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Same content as the former in-card expanded section (Sire/Dam/stats + tip slip).
class _SelectionDetailes extends StatelessWidget {
  const _SelectionDetailes({required this.selection});

  final Selection selection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                spacing: 4.w,
                children: [
                  _detailLabelValue(label: 'Sire', value: selection.horseSire),
                  _detailLabelValue(
                    label: 'Colour',
                    value: selection.horseColour,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 4.w,
                children: [
                  _detailLabelValue(label: 'Dam', value: selection.horseDam),
                  _detailLabelValue(
                    label: 'Age/Sex',
                    value: "${selection.horseAge} yo",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 4.w,
                children: [
                  _detailLabelValue(
                    label: 'Prize',
                    value: selection.horseTotalPrizeMoney,
                  ),
                  _detailLabelValue(label: 'Sex', value: selection.horseSex),
                ],
              ),
            ),
          ],
        ),
        10.w.verticalSpace,
        //* Horse status content
        _HorseStatusContent(selection: selection),
        12.w.verticalSpace,

        AppFilledButton(
          text: 'Add to Tip Slip',
          textStyle: semiBold(fontSize: 14.sp, color: AppColors.white),
          padding: EdgeInsets.symmetric(vertical: 12.w),
          onTap: () {
            context.read<SearchEngineProvider>().createTipSlip(
              context: context,
              selectionId: selection.selectionId.toString(),
            );
          },
        ),
        if (selection.history.isNotEmpty) ...[
          20.w.verticalSpace,
          Text(
            'Form history',
            style: bold(fontSize: 14.sp, color: AppColors.primary),
          ),
          10.w.verticalSpace,
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: selection.history.length,
              separatorBuilder: (_, __) => 12.w.verticalSpace,
              itemBuilder: (context, index) {
                return _FormHistoryCard(history: selection.history[index]);
              },
            ),
          ),
        ],
      ],
    );
  }
}

//* Selection card
Widget _selectionCard({
  required BuildContext context,
  required int index,
  required Selection selection,
  required VoidCallback onOpenDetail,
}) {
  final trainerStr = selection.trainerName.toString();

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onOpenDetail,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(9.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //* Silks image, horse name and barrier
                Expanded(
                  child: Column(
                    spacing: 4.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* Horse name and barrier
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${index + 1}. ",
                            style: semiBold(
                              fontSize: 15.sp,
                              color: AppColors.primary,
                              height: 1.2,
                            ),
                          ),
                          ImageWidget(
                            path: selection.silksImage,
                            type: ImageType.svg,
                            height: 25.w,
                          ),
                          4.w.horizontalSpace,
                          Text(
                            "${selection.horseName} (${selection.barrier})",
                            style: semiBold(
                              fontSize: 15.sp,
                              color: AppColors.primary,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //* Odds win
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => launchUnibetUrl(),
                  child: ImageWidget(
                    path: AppAssets.unibatLogo,
                    type: ImageType.asset,
                    height: 28.w,
                  ),
                ),
                10.w.horizontalSpace,
                _pill(text: "\$ ${selection.oddsWin}", context: context),
              ],
            ),
            // Weight / Form / Jockey / Trainer — always visible (no tap needed).
            Padding(
              padding: EdgeInsets.only(top: 10.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      spacing: 6.w,
                      children: [
                        _detailLabelValue(
                          label: 'Weight',
                          value: '${selection.weight}kg',
                          maxLines: 1,
                        ),
                        _detailLabelValue(
                          label: 'Form',
                          value: selection.formHistory,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 6.w,
                      children: [
                        _detailLabelValue(
                          label: 'Jockey',
                          value: selection.jockeyName,
                          maxLines: 1,
                        ),
                        _detailLabelValue(
                          label: 'Trainer',
                          value: trainerStr,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _HorseStatusContent extends StatelessWidget {
  const _HorseStatusContent({required this.selection});
  final Selection selection;

  static String _formatStat(HorseStatsDetails value) {
    final runs = value.runs;
    final wins = value.wins;
    final seconds = value.seconds;
    final thirds = value.thirds;
    return '$runs : $wins-$seconds-$thirds';
  }

  @override
  Widget build(BuildContext context) {
    final hs = selection.horseStats;
    final tiles = <MapEntry<String, String>>[
      // MapEntry('Sire', _dashIfEmpty(selection.horseSire)),
      // MapEntry('Dam', _dashIfEmpty(selection.horseDam)),
      // MapEntry('Prize', _formatPrize(selection.horseTotalPrizeMoney)),
      // MapEntry('Colour', _dashIfEmpty(selection.horseColour)),
      // MapEntry('Age', _dashIfEmpty(selection.horseAge)),
      // MapEntry('Sex', _dashIfEmpty(selection.horseSex)),
      // MapEntry('12 Months', _formatStat(hs.twelveMonths)),
      MapEntry('12 months', _formatStat(hs.last12Months)),
      MapEntry('Career', _formatStat(hs.career)),
      MapEntry('1st Up', _formatStat(hs.firstUp)),
      MapEntry('2nd Up', _formatStat(hs.secondUp)),
      MapEntry('3rd Up', _formatStat(hs.thirdUp)),
      MapEntry('Firm', _formatStat(hs.firm)),
      MapEntry('Good', _formatStat(hs.good)),
      MapEntry('Soft', _formatStat(hs.soft)),
      MapEntry('Heavy', _formatStat(hs.heavy)),
      MapEntry('Track', _formatStat(hs.track)),
      //
      MapEntry('Distance', _formatStat(hs.distance)),
    ];

    final gap = 6.w;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: tiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: gap,
        crossAxisSpacing: gap,
        mainAxisExtent: 60.w,
      ),
      itemBuilder: (context, index) {
        final e = tiles[index];
        return _statTile(label: e.key, value: e.value);
      },
    );
  }
}

//* Horse status tile
Widget _statTile({required String label, required String value}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(4.r),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
    ),
    alignment: Alignment.topLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      spacing: 2.w,
      children: [
        Text(
          label,
          style: semiBold(fontSize: 11.sp, color: AppColors.primary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              value,
              style: semiBold(
                fontSize: 12.sp,
                color: AppColors.primary.withValues(alpha: 0.75),
              ),
              softWrap: true,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
