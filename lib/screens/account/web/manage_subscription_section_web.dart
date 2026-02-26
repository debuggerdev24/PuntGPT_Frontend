import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/screens/account/web/widgets/subscription_plan_web.dart';

class ManageSubscriptionSectionWeb extends StatelessWidget {
  const ManageSubscriptionSectionWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final fourteenResponsive = context.isDesktop ? 14.sp : 22.sp;
    // double subscriptionBoxWidth = context.isDesktop ? 340.w : 510.w;

    return Consumer<AccountProvider>(
      builder: (context, provider, child) {
        final plans = provider.plans;
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 10.w, 22.w, 11.w),
                child: topBar(
                  twelveResponsive: context.isDesktop ? 12.sp : 20.sp,
                  provider: provider,
                  context: context,
                ),
              ),
              horizontalDivider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      22.w.verticalSpace,

                      //todo show the all plans
                      Text(
                        "All Plans : ",
                        style: bold(fontSize: fourteenResponsive),
                      ),
                      12.w.verticalSpace,
                      Wrap(
                        runSpacing: 24.w,
                        spacing: 20.w,
                        children: List.generate(plans.length, (index) {
                          return OnMouseTap(
                            onTap: () {
                              provider.setIsShowSelectedPlan(
                                showSelectedPlan: true,
                                planIndex: plans[index].id,
                              );
                            },
                            child: SubscriptionPlanWeb(
                              plan: plans[index],
                              isCurrentPlan: provider.showCurrentPlan,
                            ),
                          );
                        }),
                      ),
                      if (context.isDesktop)
                        14.w.verticalSpace
                      else
                        20.w.verticalSpace,
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
                text: "See Current Plan",
                textStyle: semiBold(
                  fontSize: context.isDesktop ? 17.sp : 22.sp,
                  color: AppColors.white,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: context.isDesktop ? 12.w : 16.5.w,
                ),
                onTap: () {
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
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Column(
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
    );
  }
}
