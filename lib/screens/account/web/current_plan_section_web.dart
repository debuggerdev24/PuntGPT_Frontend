import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/screens/account/web/widgets/subscription_plan_web.dart';

class CurrentPlanSectionWeb extends StatelessWidget {
  const CurrentPlanSectionWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final fourteenResponsive = context.isDesktop ? 14.sp : 22.sp;
    double subscriptionBoxWidth = context.isDesktop ? 340.w : 510.w;

    return Consumer<AccountProvider>(
      builder: (context, provider, child) {
        final plans = provider.plans;
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topBar(
                twelveResponsive: context.isDesktop ? 12.sp : 20.sp,
                provider: provider,
                context: context,
              ),
              horizontalDivider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      22.w.verticalSpace,
                      Text(
                        "Current Plan : ",
                        style: bold(fontSize: fourteenResponsive),
                      ),
                      12.w.verticalSpace,
                      SubscriptionPlanWeb(
                        plan: plans[0],
                        isCurrentPlan: provider.showCurrentPlan,
                      ),

                      //todo renew button
                      AppFilledButton(
                        margin: EdgeInsets.only(top: 20.w),
                        text: "Renew",
                        width: subscriptionBoxWidth,
                        textStyle: bold(
                          fontSize: fourteenResponsive,

                          color: AppColors.white,
                        ),
                        onTap: () {},
                      ),
                      //todo change plan button
                      AppOutlinedButton(
                        text: "Change Plan",
                        margin: EdgeInsets.symmetric(vertical: 10.w),
                        width: subscriptionBoxWidth,
                        textStyle: bold(fontSize: fourteenResponsive),
                        onTap: () {},
                      ),

                      //todo cancel button
                      AppOutlinedButton(
                        text: "Cancel",
                        width: subscriptionBoxWidth,
                        textStyle: bold(fontSize: fourteenResponsive),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              AppFilledButton(
                margin: EdgeInsets.only(
                  // top: 20.w,
                  left: 60.w,
                  right: 60.w,
                  bottom: 25.w,
                ),

                text: "See All Plans",
                textStyle: semiBold(
                  fontSize: context.isDesktop ? 17.sp : 22.sp,
                  color: AppColors.white,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: context.isDesktop ? 12.w : 16.5.w,
                ),
                onTap: () {
                  if (provider.showSelectedPlan) {
                    provider.setIsShowSelectedPlan(
                      showSelectedPlan: false,
                      planIndex: 1,
                    );
                  }
                  provider.setIsShowCurrentPlan = !provider.showCurrentPlan;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget points({bool? isBenefit, required String content}) {
    return Row(
      spacing: 10.w,
      children: [
        Icon(
          isBenefit ?? false ? Icons.check_rounded : Icons.close_rounded,
          color: isBenefit ?? false ? AppColors.green : AppColors.red,
        ),
        Expanded(child: Text(content)),
      ],
    );
  }

  Widget topBar({
    required double twelveResponsive,
    required AccountProvider provider,
    required BuildContext context,
  }) {
    final twentyTwoResponsive = context.isDesktop ? 22.sp : 30.sp;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isDesktop ? 18.w : 30.w,
        vertical: context.isDesktop ? 11.w : 17.w,
      ),
      child: Align(
        alignment: AlignmentGeometry.centerLeft,
        child: Row(
          children: [
            OnMouseTap(
              onTap: () {
                provider.setIsShowCurrentPlan = !provider.showCurrentPlan;
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: twentyTwoResponsive,
                color: AppColors.primary,
              ),
            ),
            (context.isDesktop) ? 13.w.horizontalSpace : 24.w.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manage Subscription",
                  style: regular(
                    fontSize: context.isDesktop ? 24.sp : 30.sp,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
                Text(
                  "Manage your Subscription Plan",
                  style: semiBold(
                    fontSize: twelveResponsive,
                    color: AppColors.greyColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
