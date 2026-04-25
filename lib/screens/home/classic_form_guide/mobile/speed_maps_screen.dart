import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/speed_maps_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

/// Matches [TipSlipItem] list styling — soft greys, white cards.
const _kListTextPrimary = Color(0xFF424242);
const _kListTextMuted = Color(0xFF757575);
const _kListBorder = Color(0xFFE0E0E0);
const _kListOddsBg = Color(0xFFEEEEEE);

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
          return HomeSectionShimmers.speedMapsScreenShimmer(context: context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Tab Selector
            Row(
              children: [
                16.w.horizontalSpace,
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
                ),
                Expanded(child: _buildTabSelector()),
              ],
            ),

            if (speedMaps.speedMapsList.isEmpty)
              Expanded(child: _buildEmptyState(context))
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.w,
                  ),
                  child: Column(
                    children: [
                      //* Visual Speed Map
                      _buildVisualSpeedMap(speedMaps.speedMapsList),

                      18.w.verticalSpace,

                      //* Legend
                      _buildLegend(),

                      18.w.verticalSpace,

                      //* List of horses
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
              width: 1.4,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all((context.isMobileWeb) ? 22.w : 16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.insights_rounded,
                  size: (context.isMobileWeb) ? 56.sp : 40.sp,
                  color: AppColors.primary.withValues(alpha: 0.55),
                ),
              ),
              16.h.verticalSpace,
              Text(
                "No speed map data available",
                textAlign: TextAlign.center,
                style: semiBold(
                  fontSize: (context.isMobileWeb) ? 30.sp : 20.sp,
                  fontFamily: AppFontFamily.secondary,
                  color: AppColors.primary,
                ),
              ),
              10.w.verticalSpace,
              Text(
                "No speed map data is available for this race yet. Please check back shortly.",
                textAlign: TextAlign.center,
                style: regular(
                  fontSize: (context.isMobileWeb) ? 24.sp : 14.sp,
                  color: AppColors.primary.withValues(alpha: 0.65),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 12.w, 16.w, 12.w),
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
    //* Sort horses based on selected tab
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
      height: 200.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        image: DecorationImage(
          image: AssetImage(AppAssets.speedMapBackground),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          //* Background gradient showing track sections
          _buildTrackGradient(),

          //* Position labels at bottom
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
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFE0E0E0),
            Color(0xFFBDBDBD),
            Color(0xFF9E9E9E),
            Color(0xFF616161),
            Color(0xFF212121),
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
              style: semiBold(fontSize: 11.sp, color: Colors.white).copyWith(
                shadows: const [
                  Shadow(
                    color: Color(0x80000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
            Text(
              rightLabel,
              style: semiBold(fontSize: 11.sp, color: Colors.white).copyWith(
                shadows: const [
                  Shadow(
                    color: Color(0x80000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
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
                  (label) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.5.w,
                      vertical: 1.2.w,
                    ),
                    color: AppColors.white,
                    child: Text(
                      label,

                      style: semiBold(
                        height: 1,
                        fontSize: 8.sp,
                        color: AppColors.black,
                      ),
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
    final verticalSpacing = 35.w;
    final topPosition = 30.w + (index % 5) * verticalSpacing;

    return Positioned(
      left: leftPosition - 20.w,
      top: topPosition,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _kListBorder, width: 1),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              // padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _kListBorder, width: 1),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ImageWidget(
                path: speedMap.selection.silksImage,
                type: ImageType.svg,
                // width: 40.w,
                // height: 40.w,
                fit: BoxFit.cover,
              ),
            ),
            4.w.verticalSpace,
            Container(
              width: 44.w,
              // constraints: BoxConstraints(maxWidth: 60.w),
              child: Text(
                speedMap.selection.horse.name,
                style: semiBold(fontSize: 9.sp, color: _kListTextPrimary),
                textAlign: TextAlign.center,
                // maxLines: 1,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    //* Darker greys (fast = darkest) so legend reads clearly on white — not washed out.
    final items = _selectedTab == 0
        ? [
            ('Very Fast', const Color(0xFF616161)),
            ('Fast', const Color(0xFF757575)),
            ('Moderate', const Color(0xFF8A8A8A)),
            ('Slow', const Color(0xFF9E9E9E)),
            ('Very Slow', const Color(0xFFB5B5B5)),
          ]
        : [
            ('Leader', const Color(0xFF616161)),
            ('On Pace', const Color(0xFF757575)),
            ('Off Pace', const Color(0xFF8A8A8A)),
            ('Midfield', const Color(0xFF9E9E9E)),
            ('Backmarker', const Color(0xFFB5B5B5)),
          ];

    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: items.reversed
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    color: item.$2,
                    borderRadius: BorderRadius.circular(3.r),
                    border: Border.all(
                      color: const Color(0xFF9E9E9E).withValues(alpha: 0.45),
                    ),
                  ),
                ),
                6.w.horizontalSpace,
                Text(
                  item.$1,
                  style: semiBold(fontSize: 12.sp, color: _kListTextPrimary),
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
      children: List.generate(sortedMaps.length, (index) {
        return _buildHorseCard(speedMap: sortedMaps[index], index: index);
      }),
    );
  }

  Widget _buildHorseCard({required SpeedMap speedMap, required int index}) {
    String speedLabel = '';
    Color tagBg = _kListOddsBg;

    if (_selectedTab == 0) {
      speedLabel = speedMap.barrierSpeedLabel;
      tagBg = _getSpeedTagBackground(speedMap.barrierSpeedLabel);
    } else if (_selectedTab == 1) {
      speedLabel = speedMap.settlingSpeedLabel;
      tagBg = _getPositionTagBackground(speedMap.settlingSpeedLabel);
    } else {
      speedLabel = speedMap.closingSpeedLabel;
      tagBg = _getPositionTagBackground(speedMap.closingSpeedLabel);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.fromLTRB(5.w, 5.w, 8.w, 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kListBorder),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          //* Silks Image
          ImageWidget(
            path: speedMap.selection.silksImage,
            type: ImageType.svg,
            width: 40.w,
            height: 40.w,
            fit: BoxFit.cover,
          ),

          12.w.horizontalSpace,

          //* Horse Details
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
                        color: _kListTextPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${speedMap.selection.horse.name} (${speedMap.selection.barrier})",
                        style: semiBold(
                          fontSize: 16.sp,
                          color: _kListTextPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                4.w.verticalSpace,
                Text(
                  "J: ${speedMap.selection.jockey.name}",
                  style: regular(fontSize: 13.sp, color: _kListTextMuted),
                  overflow: TextOverflow.ellipsis,
                ),
                4.w.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.w),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: _kListBorder),
                  ),
                  child: Text(
                    speedLabel,
                    style: semiBold(fontSize: 11.sp, color: _kListTextPrimary),
                  ),
                ),
              ],
            ),
          ),

          //* Odds
          if (speedMap.selection.unibetFixedOddsWin.isNotEmpty)
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
          Text(
            "\$${speedMap.selection.unibetFixedOddsWin}",
            style: bold(fontSize: 17.sp),
          ),
        ],
      ),
    );
  }

  /// Light grey ramp for tags (matches tip slip “soft” look).
  Color _getSpeedTagBackground(String speedLabel) {
    switch (speedLabel.toLowerCase()) {
      case 'very fast':
        return const Color(0xFFD6D6D6);
      case 'fast':
        return const Color(0xFFDDDDDD);
      case 'moderate':
        return const Color(0xFFE3E3E3);
      case 'slow':
        return const Color(0xFFE8E8E8);
      case 'very slow':
        return const Color(0xFFEEEEEE);
      default:
        return _kListOddsBg;
    }
  }

  Color _getPositionTagBackground(String positionLabel) {
    switch (positionLabel.toLowerCase()) {
      case 'leader':
        return const Color(0xFFD6D6D6);
      case 'on-pace':
      case 'on pace':
        return const Color(0xFFDDDDDD);
      case 'off-pace':
      case 'off pace':
        return const Color(0xFFE3E3E3);
      case 'midfield':
        return const Color(0xFFE8E8E8);
      case 'backmarker':
        return const Color(0xFFEEEEEE);
      default:
        return _kListOddsBg;
    }
  }
}
