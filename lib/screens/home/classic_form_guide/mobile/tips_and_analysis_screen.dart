import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/tips_analysis_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class TipAndAnalysisScreen extends StatelessWidget {
  const TipAndAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassicFormProvider>(
      builder: (context, provider, child) {
        if (provider.tipsAndAnalysis == null) {
          return HomeSectionShimmers.tipsAndAnalysisScreenShimmer(
            context: context,
          );
        }

        final tips = provider.tipsAndAnalysis!.tips;
        final segments = provider.tipAnalysisSegments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topBar(context: context),
            Expanded(
              child: (tips.isEmpty)
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.w),
                        child: Text(
                          "No tip and analysis found",
                          style: medium(
                            fontSize: 16.sp,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* Analysis Section Header
                          12.w.verticalSpace,
                          Text(
                            "Analysis",
                            style: semiBold(
                              fontSize: 20.sp,
                              fontFamily: AppFontFamily.secondary,
                              color: AppColors.primary,
                            ),
                          ),

                          7.w.verticalSpace,

                          //* Analysis Text
                          Text.rich(
                            TextSpan(
                              style: regular(
                                fontSize: 15.sp,
                                color: AppColors.primary,
                              ),
                              children: segments
                                  .map(
                                    (s) => TextSpan(
                                      text: s.text,
                                      style: s.isBold
                                          ? semiBold(
                                              fontSize: 15.sp,
                                              color: AppColors.primary,
                                            )
                                          : regular(
                                              fontSize: 15.sp,
                                              color: AppColors.primary,
                                            ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            softWrap: true,
                          ),

                          //* Tips Cards Section
                          18.w.verticalSpace,
                          Text(
                            "Tips",
                            style: semiBold(
                              fontSize: 20.sp,
                              fontFamily: AppFontFamily.secondary,
                              color: AppColors.primary,
                            ),
                          ),
                          12.w.verticalSpace,
                          ...tips.map((tip) => _buildTipCard(tip)),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _silksImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
    );
  }

  Widget _buildTipCard(Tip tip) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          //* Horse Details
          Expanded(
            child: Column(
              spacing: 4.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${tip.number}. ',
                      style: semiBold(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    //* Silks Image (SVG from network)
                    ImageWidget(
                      path: tip.silksImage,
                      type: ImageType.svg,
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.contain,
                      placeholder: _silksImageShimmer(),
                    ),
                    Expanded(
                      child: Text(
                        "${tip.horseName} (${tip.barrier})",
                        style: semiBold(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "J: ${tip.jockeyName}\nT: ${tip.trainerName}",
                  style: regular(
                    fontSize: 13.sp,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          5.w.horizontalSpace,
          //* Unibet logo
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => launchUnibetUrl(),
            child: ImageWidget(
              path: AppAssets.unibatLogo,
              type: ImageType.asset,
              height: 28.w,
            ),
          ),
          10.w.horizontalSpace,
          Text("\$${tip.unibetFixedOddsWin}", style: bold(fontSize: 17.sp)),
        ],
      ),
    );
  }

  Widget topBar({required BuildContext context}) {
    return AppScreenTopBar(
      title: "Tips & Analysis",
      slogan: "Expert insights to help you pick winners",
      onBack: () => context.pop(),
    );
  }
}
