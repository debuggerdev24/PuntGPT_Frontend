import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class WebHomeSectionShimmers {
  WebHomeSectionShimmers._();

  static Widget classicFormGuideWebShimmer() {
    const gap = 6.0;

    Widget box({
      required double w,
      required double h,
      double r = 4,
      Border? border,
    }) {
      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r),
          border: border,
        ),
      );
    }

    Widget nextToGoCard() {
      const cardW = 200.0;
      const pad = 7.0;
      const innerW = cardW - pad * 2;
      return SizedBox(
        width: cardW,
        child: Container(
          padding: const EdgeInsets.all(pad),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.shimmerBaseColor.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              box(w: innerW * 0.88, h: 14),
              const SizedBox(height: gap),
              box(w: innerW * 0.95, h: 12),
              const SizedBox(height: 5),
              box(w: innerW * 0.62, h: 12),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  box(w: 78, h: 12),
                  box(w: 52, h: 12),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget dayTab() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
          ),
        ),
        child: box(w: 68, h: 14),
      );
    }

    Widget meetingTile() {
      return Container(
        width: 260,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  box(w: 140, h: 14),
                  const SizedBox(height: 6),
                  box(w: 110, h: 12),
                  const SizedBox(height: 6),
                  box(w: 160, h: 12),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                box(w: 64, h: 12),
                const SizedBox(height: 10),
                box(w: 44, h: 12),
              ],
            ),
          ],
        ),
      );
    }

    Widget sectionBlock() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          box(w: 90, h: 14),
          const SizedBox(height: 10),
          meetingTile(),
          const SizedBox(height: 8),
          meetingTile(),
        ],
      );
    }

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Next to go", style: bold(fontSize: 16)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                6,
                (i) => Padding(
                  padding: EdgeInsets.only(right: i == 5 ? 0 : gap),
                  child: nextToGoCard(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                dayTab(),
                const SizedBox(width: 8),
                dayTab(),
                const SizedBox(width: 8),
                dayTab(),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              sectionBlock(),
              sectionBlock(),
              sectionBlock(),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static Widget tipSlipScreenShimmer({required BuildContext context}) {
    return HomeSectionShimmers.tipSlipScreenShimmer(context: context);
  }

  static Widget fieldComparisonShimmer({required BuildContext context}) {
    return HomeSectionShimmers.fieldComparisonShimmer(context: context);
  }

  /// Shimmer for the web right-panel "AI Analysis and Field Comparison" sheet.
  /// Static sizes only (no ScreenUtil / .sp).
  static Widget compareFieldSideSheetShimmer() {
    const lineH = 12.0;
    const lineGap = 8.0;
    const padH = 22.0;
    final paragraphWidths = <double>[
      double.infinity,
      double.infinity,
      248,
      double.infinity,
      double.infinity,
      210,
      double.infinity,
      double.infinity,
      262,
      double.infinity,
      132,
    ];

    Widget lineBar(double w) {
      final bar = Container(
        height: lineH,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      );
      if (w == double.infinity) {
        return SizedBox(width: double.infinity, child: bar);
      }
      return SizedBox(width: w, child: bar);
    }

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 15, 11, 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 26),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 18,
                      width: 236,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   width: 22,
                //   height: 22,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(4),
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 10),
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(padH, 4, padH, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < paragraphWidths.length; i++) ...[
                  if (i > 0) const SizedBox(height: lineGap),
                  lineBar(paragraphWidths[i]),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(padH, 0, padH, 20),
            child: Container(
              height: 44,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.shimmerBaseColor.withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  /// Shimmer for classic tab "Next to go" horizontal cards (static sizes).
  static Widget nextToGoWebShimmer() {
    const cardW = 200.0;
    const pad = 7.0;
    const innerW = cardW - pad * 2;
    const gap = 6.0;

    Widget line(double width, double height) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    Widget oneCard() {
      return SizedBox(
        width: cardW,
        child: Container(
          padding: const EdgeInsets.all(pad),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.shimmerBaseColor.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              line(innerW * 0.88, 14),
              SizedBox(height: gap),
              line(innerW * 0.95, 12),
              const SizedBox(height: 5),
              line(innerW * 0.62, 12),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  line(78, 12),
                  line(52, 12),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: gap,
          children: List.generate(20, (_) => oneCard()),
        ),
      ),
    );
  }
}
