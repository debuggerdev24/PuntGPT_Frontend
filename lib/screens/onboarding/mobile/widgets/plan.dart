
import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import '../../../../provider/auth/auth_provider.dart';
import '../../../../service/storage/locale_storage_service.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  List plan = [
    "Message PuntGPT and talk horse racing",
    "Save PuntGPT customised searches",
    "PuntGPT Punters Club group chats with AI",
    "Limited use of PuntGPT Search Engine",
    "Limited AI analysis of Horse Selections",
    "Classic Form Guide",
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //todo onBoarding title
          title(),
          25.h.verticalSpace,
          //todo tabs
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      buildTabs(
                        title: "Mug Punter",
                        status: "(Free)",
                        isSelected: provider.selectedTab == 0,
                        index: 0,
                        provider: provider,
                      ),
                      verticalDivider(),
                      buildTabs(
                        title: "Pro Punter",
                        status: "(From \$9.99/month)",
                        isSelected: provider.selectedTab == 1,
                        index: 1,
                        provider: provider,
                      ),
                    ],
                  ),
                ),
                horizontalDivider(),
                18.h.verticalSpace,
                //todo payment status
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: paymentDetail(isPro: provider.selectedTab == 1),
                ),
                10.h.verticalSpace,
                //todo features
                Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 28.h),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          ImageWidget(
                            type: ImageType.svg,
                            path: (provider.selectedTab == 0 && i < 3)
                                ? AppAssets.close
                                : AppAssets.done,
                            height: 20.w.clamp(18, 25),
                          ),
                          Flexible(
                            child: Text(
                              plan[i],
                              style: regular(fontSize: 16.sp.clamp(14, 18)),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                    itemCount: plan.length,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 28.h),
                  child: Row(
                    spacing: 16.h,
                    children: [
                      ImageWidget(
                        path: AppAssets.onBoardingImage,
                        height: 100.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "First 100 Life Memberships",
                              style: semiBold(
                                height: 1,
                                fontSize: 20.sp,
                                fontFamily: AppFontFamily.secondary,
                              ),
                            ),
                            Text(
                              "get individual Baggy Black #1-100",
                              style: regular(
                                fontSize: 14.sp,
                                color: AppColors.primary.withValues(alpha: 0.6),
                              ),
                            ),
                            if (provider.selectedTab == 0)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  provider.setSelectedTab = 1;
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 7.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.premiumYellow,
                                    ),
                                  ),
                                  child: Text(
                                    "Upgrade to Pro",
                                    style: bold(
                                      fontSize: 14.sp,
                                      color: AppColors.premiumYellow,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //
                ),
              ],
            ),
          ),
          //todo create account button
          AppFilledButton(
            margin: EdgeInsets.only(bottom: 40.h, top: 25.h),
            text: provider.selectedTab == 0
                ? "Continue with Free Account"
                : "Subscribe",
            onTap: () {
              context.read<AuthProvider>().clearSignUpControllers();
              LocaleStorageService.setIsFirstTime(false);
              context.pushNamed(
                AppRoutes.signUpScreen.name,

                extra: {'is_free_sign_up': provider.selectedTab == 0},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget paymentDetail({required bool isPro}) {
    if (isPro) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Monthly",
                style: regular(
                  fontSize: 20.sp,
                  fontFamily: AppFontFamily.secondary,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$ 9.99 ",
                      style: bold(
                        fontSize: 16.sp,
                        fontFamily: AppFontFamily.primary,
                      ),
                    ),
                    TextSpan(
                      text: "/month",
                      style: bold(
                        fontFamily: AppFontFamily.primary,
                        fontSize: 12.sp,
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,

                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Yearly",
                    style: regular(
                      fontSize: 20.sp,
                      fontFamily: AppFontFamily.secondary,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(" (50% OFF)", style: bold(fontSize: 12.sp)),
                  ),
                ],
              ),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$ 59.99 ",
                      style: bold(
                        fontSize: 16.sp,
                        fontFamily: AppFontFamily.primary,
                      ),
                    ),
                    TextSpan(
                      text: "/month",
                      style: bold(
                        fontFamily: AppFontFamily.primary,
                        fontSize: 12.sp,
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Lifetime",
                style: regular(
                  fontSize: 20.sp,
                  fontFamily: AppFontFamily.secondary,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$ 24 ",
                      style: bold(
                        fontSize: 16.sp,
                        fontFamily: AppFontFamily.primary,
                      ),
                    ),
                    TextSpan(
                      text: "one off",
                      style: bold(
                        fontFamily: AppFontFamily.primary,
                        fontSize: 12.sp,
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Text(
      "*no payment details required*",
      style: semiBold(
        fontSize: 14.sp,
        color: AppColors.primary.withValues(alpha: 0.4),
      ),
    );
  }

  Widget buildTabs({
    required String title,
    required String status,
    required bool isSelected,
    required int index,
    required AuthProvider provider,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          provider.setSelectedTab = (status == "(Free)") ? 0 : 1;
        },
        child: AnimatedContainer(
          duration: 350.milliseconds,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? (index == 0)
                      ? AppColors.primary
                      : AppColors.premiumYellow
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: medium(
                  fontSize: 18.sp,
                  fontFamily: AppFontFamily.secondary,
                  color: isSelected
                      ? (index == 0)
                            ? AppColors.white
                            : null
                      : null,
                ),
              ),
              Text(
                status,
                style: medium(
                  fontSize: 12.sp,
                  color: isSelected
                      ? (index == 0)
                            ? AppColors.white.withValues(alpha: 0.8)
                            : AppColors.primary.withValues(alpha: 0.6)
                      : AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RichText title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Mug Punter?\nBecome",
            style: regular(
              fontSize: 40.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
          TextSpan(
            text: " Pro ",
            style: regular(
              fontSize: 40.sp,
              color: AppColors.premiumYellow,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
          TextSpan(
            text: " with AI.",
            style: regular(
              fontSize: 40.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
