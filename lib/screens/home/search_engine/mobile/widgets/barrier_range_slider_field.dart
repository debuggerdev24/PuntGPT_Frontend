import 'package:puntgpt_nick/core/app_imports.dart';

class BarrierRangeSliderField extends StatelessWidget {
  const BarrierRangeSliderField({
    super.key,
    required this.values,
    this.onChanged,
  });

  final RangeValues values; // stores indexes (0..5)
  final ValueChanged<RangeValues>? onChanged;

  // Single-value points shown on UI (no range labels).
  static const List<int> _points = [1, 4, 7, 10, 13, 16];

  String _selectedText() {
    final start = values.start.round();
    final end = values.end.round();
    final lower = start <= end ? start : end;
    final upper = start <= end ? end : start;
    final minValue = _points[lower];
    final maxValue = _points[upper];
    if (minValue == maxValue) return "\$$minValue";
    return "\$$minValue - \$$maxValue";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.w, bottom: 7.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Barrier",
                style: semiBold(
                  fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                ),
              ),
              Text(
                _selectedText(),
                style: medium(
                  fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          10.w.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _points
                  .map(
                    (value) => Text(
                      "\$$value",
                      style: medium(
                        fontSize: (context.isBrowserMobile) ? 24.sp : 12.sp,
                        color: AppColors.primary.withValues(alpha: 0.8),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.greyColor2,
              trackHeight: 4,
              thumbColor: Colors.white,
              overlayColor: AppColors.primary.withValues(alpha: 0.15),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 5,
                pressedElevation: 8,
              ),
              rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 0),
              rangeTickMarkShape:
                  const RoundRangeSliderTickMarkShape(tickMarkRadius: 0),
            ),
            child: RangeSlider(
              min: 0,
              max: 5,
              values: values,
              labels: RangeLabels(
                "\$${_points[values.start.round()]}",
                "\$${_points[values.end.round()]}",
              ),
              // 6 fixed points.
              divisions: 5,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
