import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/screens/account/web/widgets/subscription_plan_web.dart';

class SelectedPlanSectionWeb extends StatelessWidget {
  const SelectedPlanSectionWeb({super.key});

  @override
  Widget build(BuildContext context) {
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
                      //todo show current plan
                      SubscriptionPlanWeb(
                        plan: plans
                            .where((e) => e.id == provider.selectedPlanId)
                            .first,
                        isCurrentPlan: provider.showCurrentPlan,
                      ),
                      AppOutlinedButton(
                        margin: EdgeInsets.only(
                          top: context.isDesktop ? 24.w : 34.w,
                        ),
                        width: subscriptionBoxWidth,
                        text: "Cancel",
                        onTap: () {
                          provider.setIsShowSelectedPlan(
                            showSelectedPlan: false,
                          );
                        },
                        textStyle: semiBold(
                          fontSize: context.isDesktop ? 16.sp : 21.5.sp,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: context.isDesktop ? 12.w : 16.5.w,
                        ),
                        child: (provider.isUpdateProfileLoading)
                            ? webProgressIndicator(context)
                            : null,
                      ),
                      AppFilledButton(
                        margin: EdgeInsets.only(
                          top: 12.w, //context.isDesktop ? 24.w : 34.w,
                        ),
                        width: subscriptionBoxWidth,
                        text: "Pay & Subscribe",
                        onTap: () {},
                        textStyle: semiBold(
                          fontSize: context.isDesktop ? 16.sp : 21.5.sp,
                          color: AppColors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: context.isDesktop ? 12.w : 16.5.w,
                        ),
                        child: (provider.isUpdateProfileLoading)
                            ? webProgressIndicator(context)
                            : null,
                      ),
                    ],
                  ),
                ),
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
      child: Row(
        children: [
          OnMouseTap(
            onTap: () {
              provider.setIsShowSelectedPlan(showSelectedPlan: false);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: twentyTwoResponsive,
              color: AppColors.primary,
            ),
          ),
          (context.isDesktop) ? 14.w.horizontalSpace : 24.w.horizontalSpace,
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
    );
  }
}
