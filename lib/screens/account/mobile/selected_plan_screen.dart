import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/account/mobile/widgets/subscription_plan.dart';
import 'package:puntgpt_nick/services/subscription/subscription_platform_service.dart';

class SelectedPlanScreen extends StatelessWidget {
  const SelectedPlanScreen({super.key, required this.plan});
  final SubscriptionPlanModel plan;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            topBar(context: context, planName: plan.plan),
            14.w.verticalSpace,
            SubscriptionPlanMobile(plan: plan),
            Spacer(),
            AppFilledButton(
              text: "Pay & Subscribe",
              onTap: () => _onPayAndSubscribe(context: context, plan: plan),
              margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.w),
            ),
          ],
        ),
        Consumer<SubscriptionProvider>(
          builder: (context, provider, child) {
            if (!provider.isSubscriptionProcessing) {
              return SizedBox.shrink();
            }
            return FullPageIndicator();
          },
        ),
      ],
    );
  }

  Widget topBar({required BuildContext context, required String planName}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(23.w, 12.w, 25.w, 14.w),
          child: Row(
            spacing: 8.w,
            children: [
              OnMouseTap(
                onTap: () {
                  context.pop();
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 18.w),
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

  Future<void> _onPayAndSubscribe({
    required BuildContext context,
    required SubscriptionPlanModel plan,
  }) async {
    Logger.info(plan.productIdAndroid.toString());
    final tier = SubscriptionService.instance.getTierFromProductId(
      plan.productIdAndroid.toString(),
    ); //_subscriptionTierForPlanId(plan.id);
    Logger.info(tier!.name);

    final subscriptionProvider = context.read<SubscriptionProvider>();
    await subscriptionProvider.initiateSubscription(
      planId: plan.id,
      onSuccess: () {
        if (!context.mounted) return;
        subscriptionProvider.buy(tier: tier, context: context);
      },
      onFailed: (error) {
        AppToast.info(context: context, message: error);
      },
    );
  }
}
