import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/app_colors.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/widgets/app_devider.dart';
import 'package:puntgpt_nick/core/widgets/image_widget.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/tips_analysis_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:shimmer/shimmer.dart';

class TipAndAnalysisScreen extends StatelessWidget {
  const TipAndAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassicFormProvider>(
      builder: (context, provider, child) {
        if (provider.tipsAndAnalysis == null) {
          return tipsAndAnalysisScreenShimmer(context: context);
        }

        final tipsAnalysis = provider.tipsAndAnalysis!;
        final segments = provider.tipAnalysisSegments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topBar(context: context),
            Expanded(
              child: (tipsAnalysis.tips.isEmpty)
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
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

                          ...tipsAnalysis.tips.map((tip) => _buildTipCard(tip)),

                          // 12.w.verticalSpace,
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
      padding: EdgeInsets.all(16.w),
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
          //* Silks Image (SVG from network)
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Container(
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
              clipBehavior: Clip.antiAlias,
              child: ImageWidget(
                path: tip.silksImage,
                type: ImageType.svg,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.contain,
                placeholder: _silksImageShimmer(),
                errorWidget: Container(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  alignment: Alignment.center,
                  child: Text(
                    '${tip.number}',
                    style: semiBold(fontSize: 14.sp, color: AppColors.primary),
                  ),
                ),
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
                      '${tip.number}. ',
                      style: semiBold(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip.horseName,
                        style: semiBold(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                4.w.verticalSpace,
                Text(
                  tip.jockeyName,
                  style: regular(
                    fontSize: 13.sp,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                2.w.verticalSpace,
                Text(
                  'Barrier ${tip.barrier}',
                  style: regular(
                    fontSize: 12.sp,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Odds
          if (tip.unibetFixedOddsWin != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '\$${tip.unibetFixedOddsWin}',
                style: semiBold(fontSize: 15.sp, color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget topBar({required BuildContext context}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 8, 25.w, 20.w),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 14.w),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tips & Analysis",
                      style: regular(
                        fontSize: 24.sp,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.35,
                      ),
                    ),
                    Text(
                      "Expert insights to help you pick winners",
                      style: semiBold(
                        fontSize: (context.isBrowserMobile) ? 26.sp : 14.sp,
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