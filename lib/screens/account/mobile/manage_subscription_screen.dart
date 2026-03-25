import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/guest_create_account_sheet.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/account/mobile/widgets/subscription_plan.dart';
import 'package:puntgpt_nick/core/app_imports.dart';

class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: provider.showCurrentPlan ? false : true,
          onPopInvokedWithResult: (didPop, result) {
            if (provider.showCurrentPlan) {
              provider.setIsShowCurrentPlan = false;
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topBar(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: List.generate(provider.plans.length, (index) {
                    final plan = provider.plans[index];
                    return GestureDetector(
                      onTap: () {
                        deBouncer.run(() {
                          if (isGuest) {
                            showGuestCreateAccountSheet(
                              context,
                              message:
                                  AppStrings.guestManageSubscriptionMessage,
                            );
                            return;
                          }
                          context.pushNamed(
                            (kIsWeb && context.isMobileView)
                                ? WebRoutes.selectedPlanScreen.name
                                : AppRoutes.selectedPlanScreen.name,
                            extra: plan,
                          );
                        });
                      },
                      child: SubscriptionPlanMobile(plan: plan),
                    );
                  }),
                ),
              ),
              // 8.w.verticalSpace,
              if (!isGuest)
                AppFilledButton(
                  margin: EdgeInsets.fromLTRB(25.w, 5.w, 25.w, 10.w),
                  text: "See Current Plan",
                  textStyle: semiBold(
                    fontSize: (context.isBrowserMobile) ? 30.sp : 18.sp,
                    color: AppColors.white,
                  ),
                  onTap: () {
                    context.pushNamed(
                      (kIsWeb && context.isMobileView)
                          ? WebRoutes.currentPlanScreen.name
                          : AppRoutes.currentPlanScreen.name,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget details({bool? isBenefit, required String content}) {
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

  Widget topBar(BuildContext context) {
    return AppScreenTopBar(
      title: "Manage Subscription",
      slogan: "Manage your Subscription Plan",
      onBack: () => context.pop(),
    );
  }
}
