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
                          padding: EdgeInsets.fromLTRB(25.w, 15.w, 25.w, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (
                                      var index = 0;
                                      index < provider.raceList!.races.length;
                                      index++
                                    ) ...[
                                      if (index > 0)
                                        verticalDivider(width: 1, opacity: 1),
                                      GestureDetector(
                                        onTap: () {
                                          Logger.info('index: $index');
                                          // provider.changeSelectedRace = index;
                                          provider.getRaceFieldDetail(
                                            id: provider
                                                .raceList!
                                                .races[index]
                                                .raceId
                                                .toString(),
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
                                                (provider.selectedRace ==
                                                    (index + 1))
                                                ? AppColors.primary
                                                : null,
                                          ),
                                          child: Text(
                                            "R${index + 1}",
                                            style: semiBold(
                                              fontSize: 16.sp,
                                              color:
                                                  (provider.selectedRace ==
                                                      (index + 1))
                                                  ? AppColors.white
                                                  : AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
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
    final trackCond = race.trackCondition.toLowerCase();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(13.w, 7.w, 12.w, 7.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.w),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
                ),
              ),
              12.w.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Race name and track condition
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "${race.selections[0].trackName} - R${race.number} - ${race.distance}m",
                            style: regular(
                              fontSize: (context.isMobileWeb) ? 36.sp : 21.sp,
                              fontFamily: AppFontFamily.secondary,
                              height: 1.1,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: .center,
                          children: [
                            Text(
                              race.weatherEmoji,
                              style: semiBold(fontSize: 18.5.sp),
                            ),
                            Text(
                              race.trackConditionRating == null
                                  ? " ${race.trackCondition}"
                                  : " ${race.trackCondition} ${race.trackConditionRating}",
                              style: semiBold(
                                fontSize: (context.isMobileWeb) ? 28.sp : 14.sp,
                                color: trackCond.contains('good')
                                    ? AppColors.green
                                    : trackCond.toLowerCase().contains('soft')
                                    ? Colors.blue
                                    : AppColors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    1.w.verticalSpace,
                    Text(
                      "Rail Position : ${race.railPosition}",
                      // "${meeting.trackName} - R${race.number} - ${race.name}",
                      style: semiBold(
                        fontSize: (context.isMobileWeb) ? 28.sp : 14.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                    2.w.verticalSpace,
                    Text(
                      race.name, //*Sponser and class data: - ${race.distance}m - ${DateFormatter.formatRaceDateTime(race.australianTime)}",
                      style: semiBold(
                        fontSize: (context.isMobileWeb) ? 28.sp : 14.sp,
                        height: 1.2,
                        color: AppColors.primary, //.withValues(alpha: 0.6),
                      ),
                    ),
                    2.w.verticalSpace,
                    Text(
                      DateFormatter.formatRaceDateTime(race.australianTime),
                      style: semiBold(
                        fontSize: (context.isMobileWeb) ? 28.sp : 14.sp,
                        height: 1.2,
                        color: AppColors.primary, //.withValues(alpha: 0.6),
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
  }
}

class RaceDetails extends StatefulWidget {
  const RaceDetails({super.key, required this.provider});
  final ClassicFormProvider provider;

  @override
  State<RaceDetails> createState() => _RaceDetailsState();
}

class _RaceDetailsState extends State<RaceDetails> {
  // Which runner row is expanded to show pedigree + stats + tip slip + long-form controls.
  int? _runnerDetailOpenIndex;
  // Within that row only: whether form history (long form) is visible.
  int? _longFormOpenIndex;

  @override
  void didUpdateWidget(covariant RaceDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldRace = oldWidget.provider.raceDetails?.raceId;
    final newRace = widget.provider.raceDetails?.raceId;
    if (oldRace != newRace) {
      _runnerDetailOpenIndex = null;
      _longFormOpenIndex = null;
    }
  }

  /// First tap opens this runner’s full card; tap again on the same header closes it.
  void _onRunnerHeaderTap(int index) {
    setState(() {
      if (_runnerDetailOpenIndex == index) {
        _runnerDetailOpenIndex = null;
        _longFormOpenIndex = null;
      } else {
        _runnerDetailOpenIndex = index;
        _longFormOpenIndex = null;
      }
    });
  }

  /// "See Long Form" — still only toggles form history (unchanged behaviour).
  void _toggleLongFormForRow(int index) {
    setState(() {
      if (_longFormOpenIndex == index) {
        _longFormOpenIndex = null;
      } else {
        _longFormOpenIndex = index;
      }
    });
  }

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
        final hasFormHistory = selection.history.isNotEmpty;
        final isDetailOpen = _runnerDetailOpenIndex == index;

        return _raceCard(
          context: context,
          index: index,
          selection: selection,
          isRunnerDetailOpen: isDetailOpen,
          onRunnerHeaderTap: () => _onRunnerHeaderTap(index),
          isLongFormOpen: _longFormOpenIndex == index,
          onSeeLongFormTap: (isDetailOpen && hasFormHistory)
              ? () => _toggleLongFormForRow(index)
              : null,
        );
      },
    );
  }
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
          // maxLines: 0,
        ),
      ),
    ],
  );
}

//* Form history card
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

  String _historyDistanceSuffix(History h) {
    final d = h.distance;
    if (d == null) return '';
    return " ${d}m";
  }

  Color _historyTrackConditionColor(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('good')) return AppColors.green;
    if (c.contains('soft')) return Colors.blue;
    return AppColors.red;
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

    final condition = (h.trackCondition ?? " ").trim();
    final dist = _historyDistanceSuffix(h);
    final detail = _historyDetailBody(h);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8.w, 9.w, 8.w, 6.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
              Expanded(
                child: condition.isEmpty && dist.isEmpty
                    ? Text(
                        '—',
                        style: semiBold(
                          fontSize: 12.5.sp,
                          color: AppColors.primary.withValues(alpha: 0.55),
                          height: 1.3,
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          style: semiBold(fontSize: 12.5.sp, height: 1.3),
                          children: [
                            if (condition.isNotEmpty)
                              TextSpan(
                                text: condition,
                                style: TextStyle(
                                  color: _historyTrackConditionColor(condition),
                                ),
                              ),
                            if (condition.isNotEmpty && dist.isNotEmpty)
                              const TextSpan(text: ' '),
                            if (dist.isNotEmpty)
                              TextSpan(
                                text: dist,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
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

//* Sire / Dam / Prize row — same facts we used to show in the bottom sheet.
Widget _threeColumns(Selection selection) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 6.w,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailLabelValue(label: 'Sire', value: selection.horseSire),
            _detailLabelValue(label: 'Colour', value: selection.horseColour),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailLabelValue(label: 'Dam', value: selection.horseDam),
            _detailLabelValue(label: 'Age', value: '${selection.horseAge} yo'),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
  );
}

/// One card per past run. Uses a [Column] (not a nested [ListView]) so it scrolls with the race screen.
Widget _formHistoryColumn(List<History> history) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < history.length; i++) ...[
        if (i > 0) 12.w.verticalSpace,
        _FormHistoryCard(history: history[i]),
      ],
    ],
  );
}

Widget _raceCard({
  required BuildContext context,
  required int index,
  required Selection selection,
  required bool isRunnerDetailOpen,
  required VoidCallback onRunnerHeaderTap,
  required bool isLongFormOpen,
  required VoidCallback? onSeeLongFormTap,
}) {
  final trainerStr = selection.trainerName.toString();

  final hintStyle = semiBold(
    fontSize: 12.sp,
    color: AppColors.primary.withValues(alpha: 0.45),
  );

  return Container(
    padding: EdgeInsets.fromLTRB(8.w, 10.w, 8.w, 7.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6.r),
      border: Border.all(width: 1),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //* Tappable summary (Unibet + odds stay separate so taps go to the partner link / price).
        InkWell(
          onTap: onRunnerHeaderTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ',
                    style: semiBold(
                      fontSize: 16.sp,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                  ImageWidget(
                    path: selection.silksImage,
                    type: ImageType.svg,
                    height: 25.w,
                    placeholder: Shimmer.fromColors(
                      baseColor: AppColors.shimmerBaseColor,
                      highlightColor: AppColors.shimmerHighlightColor,
                      child: Container(
                        width: 22.w,
                        height: 21.w,
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  4.w.horizontalSpace,
                  Expanded(
                    child: Text(
                      '${selection.horseName} (${selection.barrier})',
                      style: semiBold(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                  ),
                  5.w.horizontalSpace,
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => launchUnibetUrl(),
                    child: ImageWidget(
                      path: AppAssets.unibatLogo,
                      type: ImageType.asset,
                      height: 28.w,
                    ),
                  ),
                  8.w.horizontalSpace,
                  Text("\$ ${selection.oddsWin}", style: bold(fontSize: 17.sp)),
                ],
              ),
              //* weight, jockey, trainer and form
              Padding(
                padding: EdgeInsets.only(top: 6.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
              if (!isRunnerDetailOpen) ...[
                4.w.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.expand_more_rounded,
                      size: 20.w,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    4.w.horizontalSpace,
                    Text('Tap for full form', style: hintStyle),
                  ],
                ),
              ],
            ],
          ),
        ),

        //* Race Expanded details
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isRunnerDetailOpen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    8.w.verticalSpace,
                    horizontalDivider(opacity: 0.5),
                    8.w.verticalSpace,
                    //* Sire / Dam / Prize row
                    _threeColumns(selection),
                    8.w.verticalSpace,
                    horizontalDivider(opacity: 0.5),
                    8.w.verticalSpace,

                    Text(
                      "Comments",
                      style: bold(fontSize: 12.sp, color: AppColors.primary),
                    ),
                    3.w.verticalSpace,

                    ListView.separated
                    (
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selection.previewComments.length,
                      separatorBuilder: (context, index) => 7.w.verticalSpace,
                      itemBuilder: (context, index) => Row(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "${index+1}. ",
                            style: semiBold(
                              fontSize: 12.sp,
                              height: 1.2,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                          Expanded(
                            child: Text(
                               selection.previewComments[index].comment,
                              style: semiBold(
                                fontSize: 12.sp,
                                height: 1.2,
                                color: AppColors.primary.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.w.verticalSpace,
                    horizontalDivider(opacity: 0.5),
                    8.w.verticalSpace,
                    12.w.verticalSpace,
                    _HorseStatusContent(selection: selection),
                    12.w.verticalSpace,
                    AppFilledButton(
                      text: 'Add to Tip Slip',
                      textStyle: semiBold(
                        fontSize: 14.sp,
                        color: AppColors.white,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.w),
                      onTap: () {
                        context.read<SearchEngineProvider>().createTipSlip(
                          context: context,
                          selectionId: selection.selectionId.toString(),
                        );
                      },
                    ),
                    if (onSeeLongFormTap != null) ...[
                      AnimatedSize(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: isLongFormOpen
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  10.w.verticalSpace,
                                  Text(
                                    'Form history :',
                                    style: bold(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  10.w.verticalSpace,
                                  _formHistoryColumn(selection.history),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),

                      AppOutlinedButton(
                        text: '',
                        onTap: onSeeLongFormTap,
                        textStyle: semiBold(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                        ),
                        margin: EdgeInsets.only(top: 12.w, bottom: 4.w),
                        child: Row(
                          spacing: 6.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'See Long Form',
                              style: semiBold(
                                fontSize: 14.sp,
                                color: AppColors.primary,
                              ),
                            ),

                            Icon(
                              isLongFormOpen
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.primary,
                              size: 22.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
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
      MapEntry('Career', _formatStat(hs.career)),
      MapEntry('12 months', _formatStat(hs.last12Months)),
      MapEntry('Track', _formatStat(hs.track)),
      MapEntry('Distance', _formatStat(hs.distance)),
      MapEntry('Firm', _formatStat(hs.firm)),
      MapEntry('Good', _formatStat(hs.good)),
      MapEntry('Soft', _formatStat(hs.soft)),
      MapEntry('Heavy', _formatStat(hs.heavy)),
      MapEntry('1st Up', _formatStat(hs.firstUp)),
      MapEntry('2nd Up', _formatStat(hs.secondUp)),
      MapEntry('3rd Up', _formatStat(hs.thirdUp)),
      //
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
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
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
