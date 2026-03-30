import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';

class RaceStartTimingOptions extends StatelessWidget {
  const RaceStartTimingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, _) {
        final timings = provider.raceTimingEnums.map((e) => e.value).toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.of(context).textScaleFactor;
            double totalWidth = 50;
            for (final t in timings) {
              final estimatedTextWidth = (t.length * 10 * textScale);
              totalWidth += estimatedTextWidth + 36 + 15;
            }
            final fitsInScreen = totalWidth < constraints.maxWidth;
            return SizedBox(
              height: 45.w.flexClamp(40, 55),
              width: context.screenWidth,
              child: fitsInScreen
                  ? Center(
                      child: Wrap(
                        spacing: 15,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          timings.length,
                          (index) => _item(
                            context: context,
                            text: timings[index],
                            onTap: () => provider.setSelectedRaceTimingEnum =
                                provider.raceTimingEnums[index],
                            isSelected:
                                provider.selectedRaceTimingEnum ==
                                provider.raceTimingEnums[index],
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => _item(
                        context: context,
                        text: timings[index],
                        onTap: () {
                          provider.setSelectedRaceTimingEnum =
                              provider.raceTimingEnums[index];
                        },
                        isSelected:
                            provider.selectedRaceTimingEnum ==
                            provider.raceTimingEnums[index],
                      ),
                      separatorBuilder: (_, __) => const SizedBox(width: 15),
                      itemCount: timings.length,
                    ),
            );
          },
        );
      },
    );
  }

  Widget _item({
    required String text,
    required VoidCallback onTap,
    required bool isSelected,
    required BuildContext context,
  }) {
    return OnMouseTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 450.ms,
        curve: Curves.decelerate,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.setOpacity(0.15),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Text(
          text,
          style: semiBold(
            fontSize: 16.sixteenSp(context),
            color: isSelected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
