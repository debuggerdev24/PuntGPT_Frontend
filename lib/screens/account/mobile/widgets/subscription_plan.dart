import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/services/subscription/subscription_platform_service.dart';

class SubscriptionPlanMobile extends StatelessWidget {
  const SubscriptionPlanMobile({super.key, required this.plan});
  final SubscriptionPlanModel plan;

  @override
  Widget build(BuildContext context) {
    final price = SubscriptionService.instance.products
        .firstWhere((element) => element.id == plan.productIdIos)
        .price;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
                      : "Lifetime",
                  style: regular(
                    fontSize: (context.isMobileWeb) ? 37.sp : 24.sp,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
                TextSpan(
                  text: plan.id == 1 ? "  ‘Mug Punter’ " : "  ‘Pro Punter’ ",
                  style: regular(
                    fontSize: (context.isMobileWeb) ? 37.sp : 24.sp,
                    color: plan.id == 1
                        ? AppColors.primary
                        : AppColors.premiumYellow,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
                TextSpan(
                  text: " Account",
                  style: regular(
                    fontSize: (context.isMobileWeb) ? 36.sp : 24.sp,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
              ],
            ),
          ),
          8.w.verticalSpace,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      // (plan.id == 1)
                      //     ? "\$ ${int.parse(plan.price).toStringAsFixed(2)} "
                      //     : "\$
                      // "\$ ${plan.price} ",
                      "$price ",
                  style: bold(
                    fontSize: (context.isMobileWeb) ? 33.sp : 20.sp,
                    fontFamily: AppFontFamily.primary,
                  ),
                ),

                if (plan.id != 4)
                  TextSpan(
                    text: "/ ${plan.durationLabel}",
                    style: semiBold(
                      fontFamily: AppFontFamily.primary,
                      fontSize: (context.isMobileWeb) ? 29.sp : 16.sp,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
          16.h.verticalSpace,
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              // Map item = activePlan[i];
              final features = plan.features;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageWidget(
                    type: ImageType.svg,
                    path: (plan.id == 1 && i < 2)
                        ? AppAssets.close
                        : AppAssets.done,
                    height: (context.isMobileWeb) ? 32.w : 20.w,
                  ),
                  (context.isMobileWeb)
                      ? 14.w.horizontalSpace
                      : 10.w.horizontalSpace,
                  Expanded(
                    child: Text(
                      features[i],
                      style: regular(
                        fontSize: (context.isMobileWeb) ? 28.sp : 16.sp,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => 5.h.verticalSpace,
            itemCount: plan.features.length,
          ),
          if (plan.id == 4) ...[
            12.w.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageWidget(
                  path: AppAssets.onBoardingImage,
                  height: context.isMobileWeb ? 100.w : 75.w,
                ),
                16.w.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6.w,
                  children: [
                    Text(
                      "First 100 Life Memberships",
                      style: semiBold(
                        height: 1,
                        fontSize: context.isMobileWeb ? 22.sp : 18.sp,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),

                    Text(
                      "get individual Baggy Black #1-100",
                      style: regular(
                        fontSize: context.isMobileWeb ? 16.sp : 13.sp,
                        color: AppColors.primary.withValues(alpha: 0.6),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
