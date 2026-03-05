import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/account/mobile/widgets/subscription_plan.dart';

class SelectedPlanScreen extends StatelessWidget {
  const SelectedPlanScreen({super.key, required this.plan});
  final SubscriptionPlanModel plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topBar(context: context, planName: plan.plan),
        14.h.verticalSpace,
        SubscriptionPlanMobile(plan: plan),
        Spacer(),
        AppOutlinedButton(
          margin: EdgeInsets.symmetric(horizontal: 25.w),
          text: "Cancel",
          onTap: () {
            context.pop();
          },
        ),
        AppFilledButton(
          text: "Pay & Subscribe",
          onTap: () {
            var selectedPlan = SubscriptionEnum.monthlyPlan;
            if (plan.id == 3) {
              selectedPlan = SubscriptionEnum.annualPlan;
            } else if (plan.id == 4) {
              selectedPlan = SubscriptionEnum.lifeTimePlan;
            }
            Logger.info(selectedPlan.name);
            context.read<SubscriptionProvider>().buy(
              tier: selectedPlan,
              context: context,
            );
          },
          margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
        ),
      ],
    );
  }

  Widget topBar({required BuildContext context, required String planName}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(23.w, 12.h, 25.w, 14.h),
          child: Row(
            spacing: 8.w,
            children: [
              OnMouseTap(
                onTap: () {
                  context.pop();
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 18.h),
              ),
              Expanded(
                child: Text(
                  planName,
                  style: regular(
                    fontSize: (context.isBrowserMobile) ? 34.sp : 22.sp,
                    fontFamily: AppFontFamily.secondary,
                  ),
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
