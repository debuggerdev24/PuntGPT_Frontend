import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/screens/account/mobile/widgets/subscription_plan.dart';
import 'package:puntgpt_nick/core/app_imports.dart';

List activePlan = [
  {"icon": AppAssets.done, "point": "Chat function with PuntGPT"},
  {"icon": AppAssets.done, "point": "Access to PuntGPT Punters Club"},
  {"icon": AppAssets.done, "point": "Full use of PuntGPT Search Engine"},
  {"icon": AppAssets.done, "point": "Access to Classic Form Guide"},
];

List freePlan = [
  {"icon": AppAssets.close, "point": "No chat function with PuntGPT"},
  {"icon": AppAssets.close, "point": "No chat function with PuntGPT"},
  {"icon": AppAssets.done, "point": "Limited PuntGPT Search Engine Filters"},
  {"icon": AppAssets.done, "point": "Limited AI analysis of horses"},
  {"icon": AppAssets.done, "point": "Access to Classic Form Guide"},
];

bool isSubscribe = true;

class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
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
              topBar(context, provider),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ...List.generate(provider.plans.length, (index) {
                      final plan = provider.plans[index];
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            (kIsWeb && context.isMobileView)
                                ? WebRoutes.selectedPlanScreen.name
                                : AppRoutes.selectedPlanScreen.name,
                            extra: plan,
                          );
                        },
                        child: SubscriptionPlanMobile(plan: plan),
                      );
                    }),
                    Spacer(),
                    AppFilledButton(
                      margin: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 20.h),
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

  Widget topBar(BuildContext context, AccountProvider provider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 8.h, 25.w, 10.h),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Logger.info("showCurrentPlan ; ${provider.showCurrentPlan}");
                  // if (provider.showCurrentPlan) {
                  //   provider.setIsShowCurrentPlan = false;
                  //   return;
                  // }
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
                      color: AppColors.greyColor.withValues(alpha: 0.6),
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
}
