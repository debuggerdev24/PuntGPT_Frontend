import 'package:flutter/gestures.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/next_race_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_section_shimmers_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/race_table_web.dart';

class ClassicFormGuideViewWeb extends StatelessWidget {
  const ClassicFormGuideViewWeb({super.key, required this.bodyWidth});

  final double bodyWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: bodyWidth,
        child: SingleChildScrollView(
          child: Consumer<ClassicFormProvider>(
            builder: (context, provider, _) {
              final list = provider.nextRaceList;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Next to go", style: bold(fontSize: 16)),
                  const SizedBox(height: 10),
                  if (list == null)
                    WebHomeSectionShimmers.nextToGoWebShimmer()
                  else if (list.isEmpty)
                    _nextToGoEmptyWeb()
                  else
                    ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                        },
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 6,
                          children: List.generate(
                            list.length,
                            (index) => _nextToGoItemWeb(nextRace: list[index]),
                          ),
                        ),
                      ),
                    ),
                  _dayTabsAndRegionalHeader(provider: provider),
                  RaceTableWeb(tableWidth: bodyWidth),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _dayTabsAndRegionalHeader({required ClassicFormProvider provider}) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(provider.days.length, (index) {
                  final selected = provider.selectedDay == index;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < provider.days.length - 1 ? 8 : 0,
                    ),
                    child: OnMouseTap(
                      onTap: () => provider.changeSelectedDay = index,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : null,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          provider.days[index].value,
                          style: semiBold(
                            fontSize: 16,
                            color: selected
                                ? AppColors.white
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Regional', style: bold(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _nextToGoItemWeb({required NextRaceModel nextRace}) {
    return Container(
      width: 190,
      padding: const EdgeInsets.fromLTRB(6, 5, 7, 7),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Text(
            '${nextRace.trackName} - R${nextRace.raceNumber} - ${nextRace.raceDistance}m',
            style: semiBold(fontSize: 14),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _NextToGoRaceNameBlock(
                  raceName: nextRace.raceName,
                  nameStyle: semiBold(
                    height: 1.2,
                    fontSize: 14,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                nextRace.raceAustralianTime,
                style: semiBold(
                  fontSize: 12,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nextToGoEmptyWeb() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.03),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 22,
            color: AppColors.primary.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 10),
          Text(
            'NO races found',
            style: semiBold(
              fontSize: 15,
              fontFamily: AppFontFamily.secondary,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextToGoRaceNameBlock extends StatefulWidget {
  const _NextToGoRaceNameBlock({
    required this.raceName,
    required this.nameStyle,
  });

  final String raceName;
  final TextStyle nameStyle;

  @override
  State<_NextToGoRaceNameBlock> createState() => _NextToGoRaceNameBlockState();
}

class _NextToGoRaceNameBlockState extends State<_NextToGoRaceNameBlock> {
  bool _expanded = false;

  bool _overflowsTwoLines(double maxWidth, BuildContext context) {
    if (maxWidth <= 0) return false;
    final tp = TextPainter(
      text: TextSpan(text: widget.raceName, style: widget.nameStyle),
      textDirection: Directionality.of(context),
      maxLines: 2,
      textScaler: MediaQuery.textScalerOf(context),
      locale: Localizations.maybeLocaleOf(context),
    )..layout(maxWidth: maxWidth);
    return tp.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final overflows = _overflowsTwoLines(maxW, context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.raceName,
              style: widget.nameStyle,
              maxLines: _expanded ? null : 2,
              overflow: _expanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            if (overflows || _expanded)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    _expanded ? 'Show less' : 'Show more',
                    style: semiBold(
                      height: 1,
                      fontSize: 12,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
