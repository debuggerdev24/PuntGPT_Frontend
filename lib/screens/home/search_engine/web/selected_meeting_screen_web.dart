import 'dart:ui';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/race_details_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_screen_tab_web.dart';

class SelectedMeetingScreenWeb extends StatefulWidget {
  const SelectedMeetingScreenWeb({super.key});

  @override
  State<SelectedMeetingScreenWeb> createState() =>
      _SelectedMeetingScreenWebState();
}

class _SelectedMeetingScreenWebState extends State<SelectedMeetingScreenWeb> {
  String _selectedRaceLabel = "R1";

  @override
  Widget build(BuildContext context) {
    final bodyWidth = context.isMobileWeb
        ? 1.6.sw
        : context.isTablet
        ? 1300.w
        : 1100.w;

    return Align(
      alignment: Alignment.topCenter,
      child: Consumer2<SearchEngineProvider, ClassicFormProvider>(
        builder: (context, provider, classicForm, child) {
          // Same behaviour as mobile: must have race list + race details.
          if (classicForm.raceList == null || classicForm.raceDetails == null) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }
          return SizedBox(
            width: bodyWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),

                  Center(
                    child: HomeScreenTabWeb(
                      selectedIndex: provider.selectedTab,
                      onTap: () {
                        context.pop();
                      },
                    ),
                  ),

                  //* top bar
                  _topBar(context: context, provider: classicForm),
                  horizontalDivider(),
                  //* Race selection (dropdown) + sub-nav (matches mobile layout)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 210,
                          child: AppTextFieldDropdown(
                            textStyle: medium(fontSize: 12),
                            items: List.generate(
                              classicForm.raceList!.races.length,
                              (i) => "R${i + 1}",
                            ),
                            selectedValue: _selectedRaceLabel,
                            onChange: (value) {
                              setState(() => _selectedRaceLabel = value);
                              final idx =
                                  int.tryParse(
                                    value.replaceAll('R', '').trim(),
                                  ) ??
                                  1;
                              final raceIndex = (idx - 1).clamp(
                                0,
                                classicForm.raceList!.races.length - 1,
                              );
                              classicForm.getRaceFieldDetail(
                                id: classicForm
                                    .raceList!
                                    .races[raceIndex]
                                    .raceId
                                    .toString(),
                              );
                            },
                            hintText: "R1",
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            spacing: 17,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tips & Analysis",
                                style: semiBold(fontSize: 14),
                              ),
                              Text("Speed Maps", style: semiBold(fontSize: 14)),
                              OnMouseTap(
                                onTap: () {
                                  AppToast.info(
                                    context: context,
                                    message: 'Coming soon',
                                  );
                                },
                                child: Text(
                                  "Barrier Map",
                                  style: semiBold(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SelectedRaceTableWeb(
                    bodyWidth: bodyWidth,
                    provider: classicForm,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //* top bar
  Widget _topBar({
    required BuildContext context,
    required ClassicFormProvider provider,
  }) {
    final race = provider.raceDetails!;
    final trackCond = race.trackCondition.toLowerCase();
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 10, 12, 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnMouseTap(
            onTap: () {
              context.pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Icon(Icons.arrow_back_ios_rounded, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* track name and race number
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${race.selections[0].trackName} - R${race.number} - ${race.distance}m",
                        style: regular(
                          fontSize: 21,
                          fontFamily: AppFontFamily.secondary,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          race.weatherEmoji,
                          style: semiBold(fontSize: 18.5),
                        ),
                        Text(
                          race.trackConditionRating == null
                              ? " ${race.trackCondition}"
                              : " ${race.trackCondition} ${race.trackConditionRating}",
                          style: semiBold(
                            fontSize: 14,
                            color: trackCond.contains('good')
                                ? AppColors.green
                                : trackCond.contains('soft')
                                ? Colors.blue
                                : AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                //* rail position
                Text(
                  "Rail Position : ${race.railPosition}",
                  style: semiBold(
                    fontSize: 14,
                    color: AppColors.primary,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 2),
                //* race name
                Row(
                  children: [
                    Text(
                      race.name,
                      style: semiBold(
                        fontSize: 14,
                        height: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    //* race time
                    Text(
                      " (${DateFormatter.formatRaceDateTime(race.australianTime)})",
                      style: semiBold(
                        fontSize: 14,
                        height: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedRaceTableWeb extends StatefulWidget {
  const SelectedRaceTableWeb({
    super.key,
    required this.bodyWidth,
    required this.provider,
  });

  final double bodyWidth;
  final ClassicFormProvider provider;

  @override
  State<SelectedRaceTableWeb> createState() => _SelectedRaceTableWebState();
}

class _SelectedRaceTableWebState extends State<SelectedRaceTableWeb> {
  int? expandedIndex;

  static String _formatStat(HorseStatsDetails value) {
    final runs = value.runs;
    final wins = value.wins;
    final seconds = value.seconds;
    final thirds = value.thirds;
    return '$runs : $wins-$seconds-$thirds';
  }

  Widget _chip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: bold(fontSize: 12, color: AppColors.primary)),
          Text(value, style: medium(fontSize: 12, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _raceCard({required Selection selection, required bool isExpanded}) {
    final odds = (selection.oddsWin ?? '-').toString();
    final weight = selection.weight ?? 0.0;
    final jockey = selection.jockeyName.trim();
    final trainer = selection.trainerName.trim();
    final form = selection.formHistory.trim();

    final weightStr = weight == 0.0
        ? '-'
        : (weight % 1 == 0
              ? '${weight.toInt()}kg'
              : '${weight.toStringAsFixed(1)}kg');

    Widget data(String label, String value) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label : ',
              style: semiBold(fontSize: 12, color: AppColors.primary),
            ),
            TextSpan(
              text: value,
              style: medium(
                fontSize: 12,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      );
    }

    final hs = selection.horseStats;
    final statTiles = <MapEntry<String, String>>[
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
    ];

    final sire = selection.horseSire.trim();
    final dam = selection.horseDam.trim();
    final prize = selection.horseTotalPrizeMoney.trim();
    final colour = selection.horseColour.trim();
    final age = selection.horseAge.trim();
    final sex = selection.horseSex.toString().trim();
    final comments = selection.previewComments
        .map((e) => e.comment.trim())
        .where((c) => c.isNotEmpty)
        .toList(growable: false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: isExpanded
            ? AppColors.primary.withValues(alpha: 0.035)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.primary.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isExpanded ? AppColors.primary : AppColors.white,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  '${selection.number}',
                  style: semiBold(
                    fontSize: 13,
                    color: isExpanded ? AppColors.white : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selection.horseName} (${selection.barrier})',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: semiBold(
                        fontSize: 15,
                        color: AppColors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        data('Weight', weightStr),
                        if (form.isNotEmpty) data('Form', form),
                        if (jockey.isNotEmpty) data('Jockey', jockey),
                        if (trainer.isNotEmpty) data('Trainer', trainer),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        odds.startsWith('\$') ? odds : '\$$odds',
                        style: semiBold(fontSize: 12, color: AppColors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 34,
                      child: AppFilledButton(
                        margin: EdgeInsets.zero,
                        text: "Add to Tip Slip",
                        textStyle: semiBold(
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: Wrap(
                spacing: 18,
                runSpacing: 6,
                children: [
                  if (sire.isNotEmpty) data('Sire', sire),
                  if (colour.isNotEmpty) data('Colour', colour),
                  if (dam.isNotEmpty) data('Dam', dam),
                  if (age.isNotEmpty) data('Age', '$age yo'),
                  if (prize.isNotEmpty) data('Prize', prize),
                  if (sex.isNotEmpty && sex != 'null') data('Sex', sex),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       if (sire.isNotEmpty) detailRow('Sire', sire),
                  //       if (colour.isNotEmpty) detailRow('Colour', colour),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(width: 6),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       if (dam.isNotEmpty) detailRow('Dam', dam),
                  //       if (age.isNotEmpty) detailRow('Age', '$age yo'),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(width: 6),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       if (prize.isNotEmpty) detailRow('Prize', prize),
                  //       if (sex.isNotEmpty && sex != 'null')
                  //         detailRow('Sex', sex),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            if (comments.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < comments.length; i++) ...[
                      Text(
                        ' ${comments[i]}',
                        style: bold(
                          fontSize: 12,
                          height: 1.2,
                          color: AppColors.primary.withValues(alpha: 0.7),
                        ),
                      ),
                       const SizedBox(height: 7),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 10,
              children: [for (final e in statTiles) _chip(e.key, e.value)],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selections =
        widget.provider.raceDetails?.selections ?? const <Selection>[];
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 18, 25, 30),
        child: Column(
          children: List.generate(selections.length, (index) {
            final isExpanded = expandedIndex == index;
            return OnMouseTap(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              child: _raceCard(
                selection: selections[index],
                isExpanded: isExpanded,
              ),
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
