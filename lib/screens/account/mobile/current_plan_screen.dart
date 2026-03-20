import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/account/mobile/widgets/subscription_plan.dart';

class CurrentPlanScreen extends StatelessWidget {
  const CurrentPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        final currentPlan = provider.currentPlan;
        return Column(

          children: [
            topBar(context),
            if (currentPlan != null) ...[
              SubscriptionPlanMobile(plan: currentPlan),
              Center(
                child: Text(
                  "Billing handled via Apple Store / Google Play",
                  style: medium(
                    fontSize: 14.sp,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Spacer(),
              AppFilledButton(
                margin: EdgeInsets.only(bottom: 10.h, left: 25.w, right: 25.w),
                text: "Renew",
                textStyle: semiBold(
                  fontSize: (context.isBrowserMobile) ? 30.sp : 18.sp,
                  color: AppColors.white,
                ),
                onTap: () {},
              ),
              AppOutlinedButton(
                margin: EdgeInsets.only(bottom: 10.h, left: 25.w, right: 25.w),
                text: "Change Plan",
                textStyle: semiBold(
                  fontSize: (context.isBrowserMobile) ? 30.sp : 18.sp,
                ),
                onTap: () {},
              ),
              AppOutlinedButton(
                margin: EdgeInsets.only(bottom: 25.h, left: 25.w, right: 25.w),
                text: "Cancel",
                textStyle: semiBold(
                  fontSize: (context.isBrowserMobile) ? 30.sp : 18.sp,
                ),
                onTap: () {
                  context.pop();
                },
              ),
            ] else
              _noActivePlanView(context),
          ],
        );
      },
    );
  }

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 6.w, 25.w, 8.w),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manage Subscription",
                    style: regular(
                      fontSize: (context.isBrowserMobile) ? 36.sp : 24.sp,
                      fontFamily: AppFontFamily.secondary,
                      height: 1.35,
                    ),
                  ),
                  Text(
                    "Manage your Subscription Plan",
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }

  Widget _noActivePlanView(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(25.w, 30.w, 25.w, 12.w),
      padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 20.w),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 24.w,
            offset: Offset(0, 8.w),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 28.w,
              color: AppColors.primary,
            ),
          ),
          12.w.verticalSpace,
          Text(
            "No Active Plan",
            textAlign: TextAlign.center,
            style: semiBold(
              fontSize: (context.isBrowserMobile) ? 30.sp : 18.sp,
              color: AppColors.primary,
            ),
          ),
          8.w.verticalSpace,
          Text(
            "You are currently on the free plan. Choose a subscription plan to unlock premium features.",
            textAlign: TextAlign.center,
            style: regular(
              fontSize: (context.isBrowserMobile) ? 24.sp : 13.sp,
              color: AppColors.primary.withValues(alpha: 0.7),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
