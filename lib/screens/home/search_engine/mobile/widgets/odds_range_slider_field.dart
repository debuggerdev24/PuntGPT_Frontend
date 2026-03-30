import 'package:puntgpt_nick/core/app_imports.dart';

class OddsRangeSliderField extends StatelessWidget {
  const OddsRangeSliderField({super.key, required this.values, this.onChanged});

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  // These are the only allowed values for both thumbs.
  static const List<double> _oddsSteps = [1, 2.5, 5, 10, 20, 25];
  static const List<String> _scaleLabels = [
    "\$1",
    "\$2.5",
    "\$5",
    "\$10",
    "\$20",
    "\$25+",
  ];

  /// Converts a numeric odds value into label text shown in UI.
  /// Example: 2.5 -> "2.5", 25 -> "25+".
  String _formatOdds(double value) {
    if (value >= 25) return "25+";
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }

  /// Text on the right side of title ("Odds Range").
  /// If start and end are same, show one value only.
  String _selectedRangeText() {
    if (values.start == values.end) return "\$${_formatOdds(values.start)}";
    return "\$${_formatOdds(values.start)} - \$${_formatOdds(values.end)}";
  }

  /// Slider itself works on indices (0..5), while app state stores actual values.
  /// This maps actual value (like 10) to nearest step index.
  int _stepIndexFromValue(double value) {
    int nearestIndex = 0;
    double minDiff = double.infinity;

    for (int i = 0; i < _oddsSteps.length; i++) {
      final diff = (value - _oddsSteps[i]).abs();
      // <= keeps the later index on tie, useful around upper edge values.
      if (diff <= minDiff) {
        minDiff = diff;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }

  @override
  Widget build(BuildContext context) {
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
                "Odds Range",
                style: semiBold(
                  fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                ),
              ),
              Text(
                _selectedRangeText(),
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
              children: _scaleLabels.map((label) => _scaleText(context, label)).toList(),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.greyColor,
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
              rangeTickMarkShape: const RoundRangeSliderTickMarkShape(
                tickMarkRadius: 0,
              ),
            ),
            child: RangeSlider(
              min: 0,
              max: 5,
              values: RangeValues(startIndex, endIndex),
              labels: RangeLabels(
                "\$${_formatOdds(values.start)}",
                "\$${_formatOdds(values.end)}",
              ),
              // 6 fixed points => 5 intervals.
              divisions: 5,
              onChanged: onChanged == null
                  ? null
                  : (sliderValues) {
                      final startIndex = sliderValues.start.round();
                      final endIndex = sliderValues.end.round();
                 
                      // Convert index back to actual odds values for provider/state.
                      onChanged!(
                        RangeValues(_oddsSteps[startIndex], _oddsSteps[endIndex]),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _scaleText(BuildContext context, String text) {
    return Text(
      text,
      style: medium(
        fontSize: (context.isBrowserMobile) ? 24.sp : 12.sp,
        color: AppColors.primary.withValues(alpha: 0.8),
      ),
    );
  }
}
