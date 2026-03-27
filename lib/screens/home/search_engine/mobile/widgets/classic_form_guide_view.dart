import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8.w,
                      children: List.generate(
                        nextRaces.length,
                        (index) => _nextToGoItem(nextRace: nextRaces[index]),
                      ),
                    ),
                  ),
                ),
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
                    margin: EdgeInsets.only(
                      top: 24.w,
                      bottom: 16.w,
                      right: 8.w,
                    ),
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
              ? _buildRaceTableEmptyState(context: context, provider: provider)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 1.4.sw,
                    margin: EdgeInsets.only(bottom: 55.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      columnWidths: {
                        0: FlexColumnWidth(3.w),
                        1: FlexColumnWidth(2.w),
                        2: FlexColumnWidth(2.w),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: List.generate(
                        provider.classicFormGuide!.length,
                        (index) {
                          final classicForm = provider.classicFormGuide![index];
                          return _buildTableRow(
                            col1: classicForm.meetingName,
                            col3: classicForm.meetingDate,
                            col4: classicForm.meetingAustralianTime,
                            onTap: () {
                              provider.getMeetingRaceList(
                                meetingId: classicForm.meetingId.toString(),
                              );
                              provider.getRaceFieldDetail(
                                id: classicForm
                                    .races[provider.selectedRace]
                                    .raceId
                                    .toString(),
                              );
                              context.pushNamed(AppRoutes.selectedRace.name);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
          25.w.verticalSpace,
        ],
      ),
    );
  }
}

TableRow _buildTableRow({
  required String col1,
  required String col3,
  required String col4,
  required VoidCallback onTap,
}) {
  return TableRow(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
          child: Text(col1, style: semiBold(fontSize: 16.sp)),
        ),
      ),
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
          child: Text(col3, style: semiBold(fontSize: 16.sp)),
        ),
      ),
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
          child: Text(col4, style: semiBold(fontSize: 16.sp)),
        ),
      ),
    ],
  );
}

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
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
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
      children: [
        Text(nextRace.trackName, style: semiBold(fontSize: 16.sp)),
        6.w.verticalSpace,
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
              "13:15",
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
