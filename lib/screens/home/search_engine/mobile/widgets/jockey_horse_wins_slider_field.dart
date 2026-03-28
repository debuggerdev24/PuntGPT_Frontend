import 'package:puntgpt_nick/core/app_imports.dart';

class JockeyHorseWinsSliderField extends StatelessWidget {
  const JockeyHorseWinsSliderField({
    super.key,
    required this.values,
    this.onChanged,
  });

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;

  // Allowed fixed values for this slider.
  static const List<double> _steps = [1, 2, 3, 4, 5];
  // static const List<String> _scaleLabels = ["\$1", "\$2", "\$3", "\$4", "\$5"];

  String _format(double value) => value.toStringAsFixed(0);

  String _selectedText() {
    if (values.start == values.end) return "\$${_format(values.start)}";
    return "\$${_format(values.start)} - \$${_format(values.end)}";
  }

  int _stepIndexFromValue(double value) {
    int nearestIndex = 0;
    double minDiff = double.infinity;
    for (int i = 0; i < _steps.length; i++) {
      final diff = (value - _steps[i]).abs();
      if (diff <= minDiff) {
        minDiff = diff;
        nearestIndex = i;
      }
    }
    return nearestIndex;
  }

  @override
  Widget build(BuildContext context) {
    // Slider works with step indexes (0..4), provider stores real values (1..5).
    final startIndex = _stepIndexFromValue(values.start).toDouble();
    final endIndex = _stepIndexFromValue(values.end).toDouble();

    return Padding(
      padding: EdgeInsets.only(top: 14.w, bottom: 7.w),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jockey / Horse wins",
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
              children: _steps
                  .map(
                    (label) => Text(
                      "\$${label.toInt()}",
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
              max: 4,
              values: RangeValues(startIndex, endIndex),
              labels: RangeLabels(
                "\$${_format(values.start)}",
                "\$${_format(values.end)}",
              ),
              divisions: 4,
              onChanged: onChanged == null
                  ? null
                  : (sliderValues) {
                      // Convert index values back to actual values before sending up.
                      final start = _steps[sliderValues.start.round()];
                      final end = _steps[sliderValues.end.round()];
                      onChanged!(RangeValues(start, end));
                    },
            ),
          ),
        ],
      ),
    );
  }
}
