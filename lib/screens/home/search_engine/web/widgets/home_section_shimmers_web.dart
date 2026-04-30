import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class WebSectionShimmers {
  WebSectionShimmers._();

  static Widget tipSlipScreenShimmer({required BuildContext context}) {
    return HomeSectionShimmers.tipSlipScreenShimmer(context: context);
  }

  static Widget fieldComparisonShimmer({required BuildContext context}) {
    return HomeSectionShimmers.fieldComparisonShimmer(context: context);
  }

  //* Shimmer for web Saved Searches screen (top bar + list cards).
  static Widget savedSearchesShimmer({required BuildContext context}) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
