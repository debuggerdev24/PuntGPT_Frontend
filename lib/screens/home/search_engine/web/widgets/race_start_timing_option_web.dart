import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/gestures.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';

class RaceStartTimingOptionsWeb extends StatelessWidget {
  const RaceStartTimingOptionsWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, _) {
        final timings = provider.raceTimingEnums.map((e) => e.value).toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            // double totalWidth = 50;
            // for (final t in timings) {
              // final estimatedTextWidth = (t.length * 10 * textScale);
              // totalWidth += estimatedTextWidth + 36 + 15;
            // }
            return Center(
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.unknown,
                  },
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: (context.isMobileWeb) ? 35 : 25,
                  ),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: List.generate(
                      timings.length,
                      (index) => _item(
                        text: timings[index],
                        onTap: () => provider.setSelectedRaceTimingEnum = provider.raceTimingEnums[index],
                        isSelected: provider.selectedRaceTimingEnum == provider.raceTimingEnums[index],
                        context: context,
                      ),
                    ),
                  ),
                ),
              ),
            );
            //   SizedBox(
            //   height: 45.w.flexClamp(45, 55),
            //   width: context.screenWidth,
            //   child: fitsInScreen
            //       ? Center(
            //     child: Wrap(
            //       spacing: 15,
            //       alignment: WrapAlignment.center,
            //       children: List.generate(
            //         timings.length,
            //             (index) => _item(
            //           text: timings[index],
            //           onTap: () =>
            //           provider.selectedRaceTimingIndex = index,
            //           isSelected:
            //           provider.selectedRaceTimingIndex == index,
            //         ),
            //       ),
            //     ),
            //   )
            //       : ListView.separated(
            //     padding: EdgeInsets.symmetric(horizontal: 25.w),
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) => _item(
            //       text: timings[index],
            //       onTap: () => provider.selectedRaceTimingIndex = index,
            //       isSelected: provider.selectedRaceTimingIndex == index,
            //     ),
            //     separatorBuilder: (_, __) => const SizedBox(width: 15),
            //     itemCount: timings.length,
            //   ),
            // );
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
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.setOpacity(0.15),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Text(
          text,
          style: semiBold(
            fontSize: 13.5,
            // context.isDesktop
            //     ? 14.sp
            //     : context.isTablet
            //     ? 22.sp
            //     : (context.isMobileWeb)
            //     ? 34.sp
            //     : 14.sp,
            color: isSelected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
