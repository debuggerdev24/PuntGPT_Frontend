import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/classic_form_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';

class ClassicFormMeetingsBlockWeb extends StatelessWidget {
  const ClassicFormMeetingsBlockWeb({super.key, required this.provider});

  final ClassicFormProvider provider;

  void _openMeeting(BuildContext context, ClassicFormModel meeting) {
    provider.getMeetingRaceList(meetingId: meeting.meetingId.toString());
    if (meeting.races.isEmpty) return;
    final raceIndex = provider.selectedRace.clamp(0, meeting.races.length - 1);
    provider.getRaceFieldDetail(
      id: meeting.races[raceIndex].raceId.toString(),
    );
    context.pushNamed(WebRoutes.selectedRace.name);
  }

  @override
  Widget build(BuildContext context) {
    final guide = provider.classicFormGuide;
    if (guide == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 16, bottom: 24),
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
    if (guide.isEmpty) {
      return _raceTableEmptyWeb(provider: provider);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: provider.classicFormGuideIsGrouped
          ? _buildGrouped(context)
          : _buildLegacyList(context),
    );
  }

  Widget _buildGrouped(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 6,
      // mainAxisSize: MainAxisSize.min,
      children: [
        if (provider.classicFormMetroMeetings.isNotEmpty) ...[
          const SizedBox(height: 6),
          _meetingSection(
            context,
            label: 'Metro',
            meetings: provider.classicFormMetroMeetings,
          ),
        ],
        if (provider.classicFormRegionalMeetings.isNotEmpty) ...[
          const SizedBox(height: 6),
          _meetingSection(
            context,
            label: 'Regional',
            meetings: provider.classicFormRegionalMeetings,
          ),
        ],
        if (provider.classicFormTrialMeetings.isNotEmpty) ...[
          const SizedBox(height: 6),
          _meetingSection(
            context,
            label: 'Trials',
            meetings: provider.classicFormTrialMeetings,
          ),
        ],
      ],
    );
  }

  Widget _meetingSection(
    BuildContext context, {
    required String label,
    required List<ClassicFormModel> meetings,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SectionTitleWeb(label: label),
        ..._tilesFor(context, meetings),
      ],
    );
  }

  Widget _buildLegacyList(BuildContext context) {
    final items = provider.classicFormGuide!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _ClassicFormMeetingTileWeb(
            meeting: items[i],
            onTap: () => _openMeeting(context, items[i]),
          ),
        ],
      ],
    );
  }

  List<Widget> _tilesFor(
    BuildContext context,
    List<ClassicFormModel> meetings,
  ) {
    return [
      for (var i = 0; i < meetings.length; i++) ...[
        if (i > 0) const SizedBox(height: 8),
        _ClassicFormMeetingTileWeb(
          meeting: meetings[i],
          onTap: () => _openMeeting(context, meetings[i]),
        ),
      ],
    ];
  }
}

class _SectionTitleWeb extends StatelessWidget {
  const _SectionTitleWeb({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        label,
        style: semiBold(
          fontSize: 16,
          color: AppColors.black,
          fontFamily: AppFontFamily.primary,
        ),
      ),
    );
  }
}

class _ClassicFormMeetingTileWeb extends StatelessWidget {
  const _ClassicFormMeetingTileWeb({
    required this.meeting,
    required this.onTap,
  });

  final ClassicFormModel meeting;
  final VoidCallback onTap;

  String get _displayName => meeting.trackName;

  String get _trackCondition => meeting.races.isEmpty
      ? ''
      : meeting.races.first.trackCondition.toLowerCase();

  @override
  Widget build(BuildContext context) {
    return OnMouseTap(
      onTap: onTap,
      child: Container(
        width: context.fullScreenWidth * 0.33,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _displayName,
                    style: semiBold(
                      fontSize: 15,
                      color: AppColors.black,
                      fontFamily: AppFontFamily.primary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (meeting.country.isNotEmpty)
                    Text(
                      'Country : ${meeting.country}',
                      style: regular(
                        fontSize: 12,
                        color: AppColors.primary.withValues(alpha: 0.85),
                        fontFamily: AppFontFamily.primary,
                        height: 1.2,
                      ),
                    ),
                  if (meeting.railPosition.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Rail Pos. : ${meeting.railPosition}',
                      style: regular(
                        fontSize: 12,
                        color: AppColors.primary.withValues(alpha: 0.85),
                        fontFamily: AppFontFamily.primary,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (meeting.races.isNotEmpty)
                      Text(
                        '${meeting.weatherEmoji} ',
                        style: semiBold(
                          fontSize: 18,
                          color: AppColors.primary.withValues(alpha: 0.85),
                          fontFamily: AppFontFamily.primary,
                        ),
                      ),
                    if (meeting.races.isNotEmpty)
                      Text(
                        meeting.races.first.trackCondition,
                        style: semiBold(
                          fontSize: 13.5,
                          color: _trackCondition.contains('good')
                              ? AppColors.green
                              : _trackCondition.contains('soft')
                              ? Colors.blue
                              : AppColors.red,
                          fontFamily: AppFontFamily.primary,
                        ),
                      ),
                  ],
                ),
                if (meeting.meetingAustralianTime.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    meeting.meetingAustralianTime,
                    style: semiBold(
                      fontSize: 14.5,
                      color: AppColors.black,
                      fontFamily: AppFontFamily.primary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _raceTableEmptyWeb({required ClassicFormProvider provider}) {
  final dayLabel = provider.days[provider.selectedDay].value.toLowerCase();
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 24),
    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.03),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.green.withValues(alpha: 0.22),
            ),
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            size: 30,
            color: AppColors.primary.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'No races for $dayLabel',
          style: semiBold(
            fontSize: 16,
            fontFamily: AppFontFamily.secondary,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
