import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';

List freePlan = [
  {"icon": AppAssets.close, "point": "No chat function with PuntGPT"},
  {"icon": AppAssets.close, "point": "No chat function with PuntGPT"},
  {"icon": AppAssets.done, "point": "Limited PuntGPT Search Engine Filters"},
  {"icon": AppAssets.done, "point": "Limited AI analysis of horses"},
  {"icon": AppAssets.done, "point": "Access to Classic Form Guide"},
];

List currentPlan = [
  {"icon": AppAssets.done, "point": "Chat function with PuntGPT"},
  {"icon": AppAssets.done, "point": "Access to PuntGPT Punters Club"},
  {"icon": AppAssets.done, "point": "Full use of PuntGPT Search Engine"},
  {"icon": AppAssets.done, "point": "Access to Classic Form Guide"},
];

class SubscriptionPlanWeb extends StatelessWidget {
  const SubscriptionPlanWeb({
    super.key,
    required this.plan,
    required this.isCurrentPlan,
  });
  final SubscriptionPlanModel plan;
  final bool isCurrentPlan;

  @override
  Widget build(BuildContext context) {
    final twentyResponsive = context.isDesktop
        ? 20.sp
        : context.isTablet
        ? 27.5.sp
        : context.isBrowserMobile
        ? 36.sp
        : 20.sp;
    final fourteenResponsive = context.isDesktop
        ? 14.sp
        : context.isTablet
        ? 21.5.sp
        : context.isBrowserMobile
        ? 26.sp
        : 14.sp;
    double subscriptionBoxWidth = context.isDesktop ? 340.w : 510.w;

    return Column(
      children: [
        Container(
          width: subscriptionBoxWidth,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w),
          // margin: EdgeInsets.only(bottom: 28.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.greyColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: plan.id == 1
                          ? "Free"
                          : plan.id == 2
                          ? "Monthly"
                          : plan.id == 3
                          ? "Yearly"
                          : "Life Time",
                      style: regular(
                        fontSize: twentyResponsive,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    TextSpan(
                      text: plan.id == 1 ? " ‘Mug Punter’" : " ‘Pro Punter’",
                      style: regular(
                        fontSize: twentyResponsive,
                        color: plan.id == 1 ? null : AppColors.premiumYellow,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    TextSpan(
                      text: " Account",
                      style: regular(
                        fontSize: twentyResponsive,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              8.h.verticalSpace,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: plan.id == 1
                          ? "\$ ${int.parse(plan.price).toStringAsFixed(2)} "
                          : "\$ ${plan.price} ",
                      style: bold(
                        fontSize: twentyResponsive,
                        fontFamily: AppFontFamily.primary,
                      ),
                    ),
                    TextSpan(
                      text: "/ ${plan.durationLabel}",
                      style: semiBold(
                        fontFamily: AppFontFamily.primary,
                        fontSize: fourteenResponsive,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              16.h.verticalSpace,
              //todo points
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  final features = plan.features;
                  return Row(
                    spacing: 8.w,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageWidget(
                        type: ImageType.svg,
                        path: plan.id == 1 && i < 2
                            ? AppAssets.close
                            : AppAssets.done,
                        height: context.isDesktop
                            ? 20.w
                            : context.isTablet
                            ? 28.w
                            : context.isBrowserMobile
                            ? 36.w
                            : 20.w,
                      ),
                      Expanded(
                        child: Text(
                          features[i],
                          style: regular(fontSize: fourteenResponsive),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => 5.h.verticalSpace,
                itemCount: plan.features.length,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// if (isSubscribe) ...[
//           //todo renew button
//           AppFiledButton(
//             text: "Renew",
//             width: subscriptionBoxWidth,
//             textStyle: bold(
//               fontSize: fourteenResponsive,
//               color: AppColors.white,
//             ),
//             onTap: () {},
//           ),
//           //todo change plan button
//           AppOutlinedButton(
//             text: "Change Plan",
//             width: subscriptionBoxWidth,
//             textStyle: bold(fontSize: fourteenResponsive),
//             onTap: () {},
//           ),
//
//           //todo cancel button
//           AppOutlinedButton(
//             text: "Cancel",
//             width: subscriptionBoxWidth,
//             textStyle: bold(fontSize: fourteenResponsive),
//             onTap: () {},
//           ),
//         ] else
//           AppFiledButton(
//             text: "Upgrade to Pro",
//             width: subscriptionBoxWidth,
//             textStyle: bold(
//               fontSize: fourteenResponsive,
//               color: AppColors.white,
//             ),
//             onTap: () {},
//           ),
