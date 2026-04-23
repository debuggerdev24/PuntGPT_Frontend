import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/classic_form_model.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/next_race_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';

class ClassicFormGuideView extends StatelessWidget {
  const ClassicFormGuideView({super.key, required this.provider});

  final ClassicFormProvider provider;

  @override
  Widget build(BuildContext context) {
    final nextRaces = provider.nextRaceList;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Next to go", style: bold(fontSize: 16.sp)),
          10.w.verticalSpace,
          nextRaces.isEmpty
              ? _buildNextToGoEmptyState(context: context)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.w,
                      children: List.generate(
                        nextRaces.length,
                        (index) => _nextToGoItem(nextRace: nextRaces[index]),
                      ),
                    ),
                  ),
                ),
          //* Next to go tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(provider.days.length, (index) {
                return GestureDetector(
                  onTap: () {
                    provider.changeSelectedDay = index;
                  },
                  child: AnimatedContainer(
                    duration: 400.milliseconds,
                    margin: EdgeInsets.only(top: 14.w, right: 8.w),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.w,
                      horizontal: 18.w,
                    ),
                    decoration: BoxDecoration(
                      color: (provider.selectedDay == index)
                          ? AppColors.primary
                          : null,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      provider.days[index].value,
                      style: semiBold(
                        fontSize: 16.sp,
                        color: (provider.selectedDay == index)
                            ? AppColors.white
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          provider.classicFormGuide!.isEmpty
              ?
                //* Race table empty state
                _buildRaceTableEmptyState(context: context, provider: provider)
              :
                //* classic form meetings block
                Padding(
                  padding: EdgeInsets.only(bottom: 55.w),
                  child: _ClassicFormMeetingsBlock(provider: provider),
                ),
          25.w.verticalSpace,
        ],
      ),
    );
  }
}

//* Metro → Regional → Trials meeting list (grouped API) or one list (legacy API).
class _ClassicFormMeetingsBlock extends StatelessWidget {
  const _ClassicFormMeetingsBlock({required this.provider});

  final ClassicFormProvider provider;

  void _openMeeting(BuildContext context, ClassicFormModel meeting) {
    provider.getMeetingRaceList(meetingId: meeting.meetingId.toString());
    if (meeting.races.isEmpty) return;
    final raceIndex = provider.selectedRace.clamp(0, meeting.races.length - 1);
    provider.getRaceFieldDetail(id: meeting.races[raceIndex].raceId.toString());
    context.pushNamed(AppRoutes.selectedRace.name);
  }

  @override
  Widget build(BuildContext context) {
    if (provider.classicFormGuideIsGrouped) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (provider.classicFormMetroMeetings.isNotEmpty) ...[
            8.w.verticalSpace,
            const _ClassicFormSectionTitle(label: 'Metro'),
            ..._tilesFor(context, provider.classicFormMetroMeetings),
          ],
          if (provider.classicFormRegionalMeetings.isNotEmpty) ...[
            8.w.verticalSpace,
            const _ClassicFormSectionTitle(label: 'Regional'),
            ..._tilesFor(context, provider.classicFormRegionalMeetings),
          ],
          if (provider.classicFormTrialMeetings.isNotEmpty) ...[
            8.w.verticalSpace,
            const _ClassicFormSectionTitle(label: 'Trials'),
            ..._tilesFor(context, provider.classicFormTrialMeetings),
          ],
        ],
      );
    }

    // Use a Column here, not a ListView. This widget sits inside a parent
    // SingleChildScrollView; a normal ListView wants infinite height and throws
    // "Vertical viewport was given unbounded height" unless shrinkWrap is used.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < provider.classicFormGuide!.length; i++) ...[
          if (i > 0) 10.w.verticalSpace,
          _ClassicFormMeetingTile(
            meeting: provider.classicFormGuide![i],
            onTap: () => _openMeeting(context, provider.classicFormGuide![i]),
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
        if (i > 0) 8.h.verticalSpace,
        _ClassicFormMeetingTile(
          meeting: meetings[i],
          onTap: () => _openMeeting(context, meetings[i]),
        ),
      ],
    ];
  }
}

class _ClassicFormSectionTitle extends StatelessWidget {
  const _ClassicFormSectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 4.h),
      child: Text(
        label,
        style: semiBold(
          fontSize: 16.sp.clamp(15, 18),
          color: AppColors.black,
          fontFamily: AppFontFamily.primary,
        ),
      ),
    );
  }
}

/// One meeting row: track name, country under it, first-race time on the right, chevron.
class _ClassicFormMeetingTile extends StatelessWidget {
  const _ClassicFormMeetingTile({required this.meeting, required this.onTap});

  final ClassicFormModel meeting;
  final VoidCallback onTap;

  String get _displayName => meeting.trackName;
  //  meeting.meetingName.trim().isNotEmpty
  //     ? meeting.trackName
  //     : meeting.meetingName;

  String get _trackCondition =>
      meeting.races.first.trackCondition.toLowerCase();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.primary.setOpacity(0.5)),
        ),
        child: Row(
          children: [
            //*left side part for the classic forms meeting
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    _displayName,
                    style: semiBold(
                      fontSize: 15.sp,
                      color: AppColors.black,
                      fontFamily: AppFontFamily.primary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.w.verticalSpace,

                  if (meeting.country.isNotEmpty) ...[
                    Text(
                      "Country : ${meeting.country}",
                      style: regular(
                        fontSize: 12.sp,
                        color: AppColors.primary.withValues(alpha: 0.85),
                        fontFamily: AppFontFamily.primary,
                        height: 1.2,
                      ),
                    ),
                  ],
                  if (meeting.railPosition.isNotEmpty) ...[
                    Text(
                      "Rail Pos. : ${meeting.railPosition}",
                      style: regular(
                        fontSize: 12.sp.clamp(11, 14),
                        color: AppColors.primary.withValues(alpha: 0.85),
                        fontFamily: AppFontFamily.primary,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),

            //*right side part for the classic forms meeting
            8.w.horizontalSpace,
            Column(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .end,
              spacing: 5.w,

              children: [
                Row(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      "${meeting.weatherEmoji} ",
                      style: semiBold(
                        fontSize: 18.6.sp,
                        color: AppColors.primary.withValues(alpha: 0.85),
                        fontFamily: AppFontFamily.primary,
                      ),
                    ),
                    Text(
                      meeting.races.first.trackCondition,
                      style: semiBold(
                        fontSize: 13.5.sp,
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

                if (meeting.meetingAustralianTime.isNotEmpty)
                  Text(
                    meeting.meetingAustralianTime,
                    style: semiBold(
                      fontSize: 14.5.sp,
                      color: AppColors.black,
                      fontFamily: AppFontFamily.primary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//   scrollDirection: Axis.horizontal,
//   child: Container(
//     width: 1.4.sw,
//     margin: EdgeInsets.only(bottom: 55.w),
//     decoration: BoxDecoration(
//       border: Border.all(
//         color: AppColors.primary.withValues(alpha: 0.3),
//       ),
//     ),
//     child: Table(
//       border: TableBorder.symmetric(
//         inside: BorderSide(
//           color: AppColors.primary.withValues(alpha: 0.2),
//         ),
//       ),
//       columnWidths: {
//         0: FlexColumnWidth(3.w),
//         1: FlexColumnWidth(2.w),
//         2: FlexColumnWidth(2.w),
//       },
//       defaultVerticalAlignment:
//           TableCellVerticalAlignment.middle,
//       children: List.generate(
//         provider.classicFormGuide!.length,
//         (index) {
//           final classicForm = provider.classicFormGuide![index];
//           return _buildTableRow(
//             col1: classicForm.meetingName,
//             col3: classicForm.meetingDate,
//             col4: classicForm.meetingAustralianTime,
//             onTap: () {
//               provider.getMeetingRaceList(
//                 meetingId: classicForm.meetingId.toString(),
//               );
//               provider.getRaceFieldDetail(
//                 id: classicForm
//                     .races[provider.selectedRace]
//                     .raceId
//                     .toString(),
//               );
//               context.pushNamed(AppRoutes.selectedRace.name);
//             },
//           );
//         },
//       ),
//     ),
//   ),
// ),
Widget _buildNextToGoEmptyState({required BuildContext context}) {
  return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 4.w),
        padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.03),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.12),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 22.sp,
              color: AppColors.primary.withValues(alpha: 0.45),
            ),
            10.w.horizontalSpace,
            Text(
              "NO races found",
              style: semiBold(
                fontSize: 15.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      )
      .animate()
      .fadeIn(duration: 400.ms)
      .slideY(
        begin: 0.08,
        end: 0,
        duration: 400.ms,
        curve: Curves.easeOutCubic,
      );
}

Widget _buildRaceTableEmptyState({
  required BuildContext context,
  required ClassicFormProvider provider,
}) {
  final dayLabel = provider.days[provider.selectedDay].value.toLowerCase();
  return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 55.w),
        padding: EdgeInsets.symmetric(vertical: 28.w, horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.03),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.green.withValues(alpha: 0.22),
                ),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 30.sp,
                color: AppColors.primary.withValues(alpha: 0.55),
              ),
            ),
            14.w.verticalSpace,
            Text(
              "No races for $dayLabel",
              style: semiBold(
                fontSize: 16.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
      .animate()
      .fadeIn(duration: 350.ms)
      .slideY(
        begin: 0.04,
        end: 0,
        duration: 350.ms,
        curve: Curves.easeOutCubic,
      );
}

Widget _nextToGoItem({required NextRaceModel nextRace}) {
  return Container(
    width: 240.w,
    padding: EdgeInsets.fromLTRB(16.w, 12.w, 14.w, 14.w),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6.w,
      children: [
        Text("${nextRace.trackName} - R${nextRace.raceNumber} - ${nextRace.raceDistance}m", style: semiBold(fontSize: 16.sp)),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                nextRace.raceName,
                style: semiBold(
                  fontSize: 14.sp,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ),
            Text(
              nextRace.raceAustralianTime,
              style: semiBold(
                fontSize: 14.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
