import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/app_colors.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/speed_maps_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';

class SpeedMapsScreen extends StatefulWidget {
  const SpeedMapsScreen({super.key});

  @override
  State<SpeedMapsScreen> createState() => _SpeedMapsScreenState();
}

class _SpeedMapsScreenState extends State<SpeedMapsScreen> {
  int _selectedTab = 0; // 0: Barrier, 1: Settling, 2: Closing

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassicFormProvider>(
      builder: (context, provider, child) {
        final speedMaps = provider.speedMaps;
        if (speedMaps == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Selector
            _buildTabSelector(),

            if (speedMaps.speedMapsList.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No speed maps found',
                    style: medium(
                      fontSize: 16.sp,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      // Visual Speed Map
                      _buildVisualSpeedMap(speedMaps.speedMapsList),

                      24.h.verticalSpace,

                      // Legend
                      _buildLegend(),

                      24.h.verticalSpace,

                      // List of horses
                      _buildHorsesList(speedMaps.speedMapsList),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _buildTab('Barrier', 0),
          _buildTab('Settling', 1),
          _buildTab('Closing', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: index == 0
                ? BorderRadius.horizontal(left: Radius.circular(7.r))
                : index == 2
                ? BorderRadius.horizontal(right: Radius.circular(7.r))
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: semiBold(
              fontSize: 15.sp,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisualSpeedMap(List<SpeedMap> speedMaps) {
    // Sort horses based on selected tab
    List<SpeedMap> sortedMaps = List.from(speedMaps);

    if (_selectedTab == 0) {
      // Barrier - sort by barrier speed (fastest to slowest)
      sortedMaps.sort(
        (a, b) => double.parse(
          b.barrierNormalisedSpeedMeasure,
        ).compareTo(double.parse(a.barrierNormalisedSpeedMeasure)),
      );
    } else if (_selectedTab == 1) {
      // Settling - sort by settling position (leader to backmarker)
      sortedMaps.sort((a, b) => b.settlingLength.compareTo(a.settlingLength));
    } else {
      // Closing - sort by closing speed
      sortedMaps.sort(
        (a, b) => double.parse(
          b.closingSpeedMeasure,
        ).compareTo(double.parse(a.closingSpeedMeasure)),
      );
    }

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          // Background gradient showing track sections
          _buildTrackGradient(),

          // Position labels at bottom
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: _buildPositionLabels(),
          ),

          // Horses positioned based on speed/position
          ...List.generate(sortedMaps.length, (index) {
            return _buildHorseMarker(
              sortedMaps[index],
              index,
              sortedMaps.length,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrackGradient() {
    String leftLabel = '';
    String rightLabel = '';

    if (_selectedTab == 0) {
      leftLabel = 'Slow';
      rightLabel = 'Fast';
    } else if (_selectedTab == 1) {
      leftLabel = 'Backmarker';
      rightLabel = 'Leader';
    } else {
      leftLabel = 'Backmarker';
      rightLabel = 'Leader';
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFFE8F5E9),
            const Color(0xFFC8E6C9),
            const Color(0xFFA5D6A7),
            const Color(0xFF81C784),
            const Color(0xFF66BB6A),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftLabel,
              style: semiBold(
                fontSize: 11.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            Text(
              rightLabel,
              style: semiBold(
                fontSize: 11.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionLabels() {
    if (_selectedTab != 1) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            [
                  'Backmarker',
                  'Off Midfield',
                  'Midfield',
                  'Off Pace',
                  'On Pace',
                  'Leader',
                ]
                .map(
                  (label) => Text(
                    label,
                    style: semiBold(
                      fontSize: 8.sp,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildHorseMarker(SpeedMap speedMap, int index, int total) {
    double position = 0.0;

    if (_selectedTab == 0) {
      // Barrier - use normalized speed measure
      position = double.parse(speedMap.barrierNormalisedSpeedMeasure);
    } else if (_selectedTab == 1) {
      // Settling - use settling length (normalize to 0-1)
      final maxLength = 12; // approximate max
      position = speedMap.settlingLength / maxLength;
    } else {
      // Closing - use closing speed measure
      position = double.parse(speedMap.closingSpeedMeasure);
    }

    // Calculate horizontal position (with some padding)
    final leftPosition = (position * 0.85 + 0.075) * 1.sw;

    // Calculate vertical position with slight variation for visibility
    final verticalSpacing = 35.h;
    final topPosition = 30.h + (index % 5) * verticalSpacing;

    return Positioned(
      left: leftPosition - 20.w,
      top: topPosition,
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(6.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Image.network(
                speedMap.selection.silksImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Center(
                      child: Text(
                        '${speedMap.selection.number}',
                        style: semiBold(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          4.h.verticalSpace,
          Container(
            constraints: BoxConstraints(maxWidth: 60.w),
            child: Text(
              speedMap.selection.horse.name,
              style: semiBold(fontSize: 9.sp, color: AppColors.primary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final items = _selectedTab == 0
        ? [
            ('Very Fast', const Color(0xFF66BB6A)),
            ('Fast', const Color(0xFF81C784)),
            ('Moderate', const Color(0xFFA5D6A7)),
            ('Slow', const Color(0xFFC8E6C9)),
            ('Very Slow', const Color(0xFFE8F5E9)),
          ]
        : [
            ('Leader', const Color(0xFF66BB6A)),
            ('On Pace', const Color(0xFF81C784)),
            ('Off Pace', const Color(0xFFA5D6A7)),
            ('Midfield', const Color(0xFFC8E6C9)),
            ('Backmarker', const Color(0xFFE8F5E9)),
          ];

    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: item.$2,
                    borderRadius: BorderRadius.circular(3.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                6.w.horizontalSpace,
                Text(
                  item.$1,
                  style: medium(fontSize: 12.sp, color: AppColors.primary),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildHorsesList(List<SpeedMap> speedMaps) {
    // Sort based on current tab
    List<SpeedMap> sortedMaps = List.from(speedMaps);

    if (_selectedTab == 0) {
      sortedMaps.sort(
        (a, b) => double.parse(
          b.barrierNormalisedSpeedMeasure,
        ).compareTo(double.parse(a.barrierNormalisedSpeedMeasure)),
      );
    } else if (_selectedTab == 1) {
      sortedMaps.sort((a, b) => b.settlingLength.compareTo(a.settlingLength));
    } else {
      sortedMaps.sort(
        (a, b) => double.parse(
          b.closingSpeedMeasure,
        ).compareTo(double.parse(a.closingSpeedMeasure)),
      );
    }

    return Column(
      children: sortedMaps
          .map((speedMap) => _buildHorseCard(speedMap))
          .toList(),
    );
  }

  Widget _buildHorseCard(SpeedMap speedMap) {
    String speedLabel = '';
    Color labelColor = Colors.grey;

    if (_selectedTab == 0) {
      speedLabel = speedMap.barrierSpeedLabel;
      labelColor = _getSpeedColor(speedMap.barrierSpeedLabel);
    } else if (_selectedTab == 1) {
      speedLabel = speedMap.settlingSpeedLabel;
      labelColor = _getPositionColor(speedMap.settlingSpeedLabel);
    } else {
      speedLabel = speedMap.closingSpeedLabel;
      labelColor = _getPositionColor(speedMap.closingSpeedLabel);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: labelColor.withValues(alpha: 0.15),
        border: Border.all(color: labelColor.withValues(alpha: 0.3), width: 1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Silks Image
          Container(
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
              child: Image.network(
                speedMap.selection.silksImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Center(
                      child: Text(
                        '${speedMap.selection.number}',
                        style: semiBold(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                      '${speedMap.selection.number}. ',
                      style: semiBold(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        speedMap.selection.horse.name,
                        style: semiBold(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                4.h.verticalSpace,
                Text(
                  speedMap.selection.jockey.name,
                  style: regular(
                    fontSize: 13.sp,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                4.h.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: labelColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    speedLabel,
                    style: semiBold(fontSize: 11.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Odds
          if (speedMap.selection.unibetFixedOddsWin.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '\$${speedMap.selection.unibetFixedOddsWin}',
                style: semiBold(fontSize: 15.sp, color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Color _getSpeedColor(String speedLabel) {
    switch (speedLabel.toLowerCase()) {
      case 'very fast':
        return const Color(0xFF66BB6A);
      case 'fast':
        return const Color(0xFF81C784);
      case 'moderate':
        return const Color(0xFFA5D6A7);
      case 'slow':
        return const Color(0xFFC8E6C9);
      case 'very slow':
        return const Color(0xFFB0BEC5);
      default:
        return Colors.grey;
    }
  }

  Color _getPositionColor(String positionLabel) {
    switch (positionLabel.toLowerCase()) {
      case 'leader':
        return const Color(0xFF66BB6A);
      case 'on-pace':
      case 'on pace':
        return const Color(0xFF81C784);
      case 'off-pace':
      case 'off pace':
        return const Color(0xFFA5D6A7);
      case 'midfield':
        return const Color(0xFFC8E6C9);
      case 'backmarker':
        return const Color(0xFFB0BEC5);
      default:
        return Colors.grey;
    }
  }

  Widget topBar({
    required BuildContext context,
    required SpeedMapsModel speedMaps,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(6.w, 8, 25.w, 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Speed Maps",
                      style: regular(
                        fontSize: 24.sp,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.35,
                      ),
                    ),
                    Text(
                      "Race ${speedMaps.raceNumber} - ${speedMaps.meetingName}",
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
