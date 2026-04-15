import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _proBenefits = [
    "Chat function with PuntGPT",
    "Access to PuntGPT Punters Club",
    "Full use of PuntGPT Search Engine",
    "Access to Classic Form Guide",
    "Save PuntGPT Search Engine filters for quick form",
  ];

  /// Mug Punter feature rows (same pattern as [SubscriptionPlanMobile]).
  final List<String> _mugPunterFeatureLines = [
    "Message PuntGPT and talk horse racing",
    "Save PuntGPT customised searches",
    "PuntGPT Punters Club group chats with AI",
    "Limited use of PuntGPT Search Engine",
    "Limited AI analysis of Horse Selections",
    "Classic Form Guide",
  ];

  /// `false` = excluded (close icon), `true` = included (check icon).
  final List<bool> _mugPunterFeatureIncluded = [
    false,
    false,
    false,
    true,
    true,
    true,
  ];

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionProvider>().initialize(context: context);

    isGuest = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.w),
            child: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                final selected = auth.onboardingPlanTab; // 0/1
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    28.w.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          //* Tabs selection
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => auth.setOnboardingPlanTab(0),
                                  child: Container(
                                    color: selected == 0
                                        ? AppColors.black
                                        : AppColors.white,
                                    child: Column(
                                      children: [
                                        14.5.w.verticalSpace,
                                        Text(
                                          "Mug Punter",
                                          style: semiBold(
                                            fontSize: 15.sp,
                                            color: selected == 0
                                                ? AppColors.white
                                                : AppColors.black,
                                            fontFamily: AppFontFamily.secondary,
                                          ),
                                        ),
                                        Text(
                                          "(Free as guest)",
                                          style: medium(
                                            fontSize: 11.sp,
                                            color: selected == 0
                                                ? AppColors.white.withValues(
                                                    alpha: 0.85,
                                                  )
                                                : AppColors.black.withValues(
                                                    alpha: 0.72,
                                                  ),
                                          ),
                                        ),
                                        14.5.w.verticalSpace,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => auth.setOnboardingPlanTab(1),
                                  child: Container(
                                    color: selected == 1
                                        ? AppColors.premiumYellow
                                        : AppColors.white,
                                    child: Column(
                                      children: [
                                        5.w.verticalSpace,
                                        Text(
                                          "Pro Punter",
                                          style: semiBold(
                                            fontSize: 15.sp,
                                            color: AppColors.black,
                                            fontFamily: AppFontFamily.secondary,
                                          ),
                                        ),
                                        Text(
                                          "(From \$9.99/month)",
                                          style: medium(
                                            fontSize: 11.sp,
                                            color: AppColors.black.withValues(
                                              alpha: 0.72,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "*Yearly Pro Punter billed annually",
                                          textAlign: TextAlign.center,
                                          style: medium(
                                            fontSize: 11.sp,
                                            color: AppColors.black.withValues(
                                              alpha: 0.72,
                                            ),
                                          ),
                                        ),
                                        5.w.verticalSpace,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          horizontalDivider(),
                          //* Content
                          if (selected == 0)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "*no payment details required*",
                                      textAlign: TextAlign.center,
                                      style: regular(
                                        fontSize: context.isBrowserMobile
                                            ? 14.sp
                                            : 12.sp,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.55,
                                        ),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  16.w.verticalSpace,
                                  ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      final included =
                                          _mugPunterFeatureIncluded[i];
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ImageWidget(
                                            type: ImageType.svg,
                                            path: included
                                                ? AppAssets.done
                                                : AppAssets.close,
                                            height: context.isBrowserMobile
                                                ? 32.w
                                                : 20.w,
                                          ),
                                          (context.isBrowserMobile)
                                              ? 14.w.horizontalSpace
                                              : 10.w.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              _mugPunterFeatureLines[i],
                                              style: regular(
                                                fontSize:
                                                    context.isBrowserMobile
                                                    ? 28.sp
                                                    : 16.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        5.h.verticalSpace,
                                    itemCount: _mugPunterFeatureLines.length,
                                  ),
                                  24.w.verticalSpace,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ImageWidget(
                                        path: AppAssets.onBoardingImage,
                                        height: context.isBrowserMobile
                                            ? 100.w
                                            : 80.w,
                                      ),
                                      16.w.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "First 100 Life Memberships",
                                            style: semiBold(
                                              height: 1,
                                              fontSize: context.isBrowserMobile
                                                  ? 22.sp
                                                  : 18.sp,
                                              fontFamily:
                                                  AppFontFamily.secondary,
                                            ),
                                          ),
                                          6.w.verticalSpace,
                                          Text(
                                            "get individual Baggy Black #1-100",
                                            style: regular(
                                              fontSize: context.isBrowserMobile
                                                  ? 16.sp
                                                  : 13.sp,
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.6),
                                              height: 1,
                                            ),
                                          ),

                                          AppOutlinedButton(
                                            margin: EdgeInsets.only(top: 10.w),
                                            text: "Upgrade to Pro",
                                            borderRadius: 2.r,

                                            isExpand: false,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 5.w,
                                            ),
                                            borderColor:
                                                AppColors.premiumYellow,
                                            textStyle: semiBold(
                                              fontSize: context.isBrowserMobile
                                                  ? 18.sp
                                                  : 14.sp,
                                              color: AppColors.premiumYellow,
                                            ),
                                            onTap: () =>
                                                auth.setOnboardingPlanTab(1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            //* Payment details
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 14.w,
                              ),
                              child: _paymentDetail(),
                            ),
                            //* Pro benefits
                            Padding(
                              padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 14.w),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      ImageWidget(
                                        type: ImageType.svg,
                                        path: AppAssets.done,
                                        height: 20.w.clamp(18, 25),
                                      ),
                                      Flexible(
                                        child: Text(
                                          _proBenefits[i],
                                          style: regular(
                                            fontSize: 16.sp.clamp(14, 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 5.w),
                                itemCount: _proBenefits.length,
                              ),
                            ),

                            //* Life membership
                            Padding(
                              padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 14.w),
                              child: Row(
                                spacing: 16.w,
                                children: [
                                  ImageWidget(
                                    path: AppAssets.onBoardingImage,
                                    height: 100.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            color: AppColors.primary.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppFilledButton(
                      margin: EdgeInsets.only(top: 25.w),
                      text: selected == 0 ? "Continue as guest" : "Subscribe",
                      onTap: () {
                        isGuest = true;

                        if (selected == 0) {
                          LocaleStorageService.setIsFirstTime(false);
                          isGuest = true;
                          context.pushNamed(
                            kIsWeb
                                ? WebRoutes.homeScreen.name
                                : AppRoutes.homeScreen.name,
                          );
                          return;
                        }

                        // context.read<AuthProvider>().clearSignUpControllers();
                        // LocaleStorageService.setIsFirstTime(false);
                        isGuest = false;
                        
                        context.pushNamed(
                          kIsWeb
                              ? WebRoutes.signUpScreen.name
                              : AppRoutes.signUpScreen.name,
                        );
                      },
                    ),
                    12.w.verticalSpace,
                    if (selected != 0)
                      OnMouseTap(
                        onTap: () {
                          LocaleStorageService.setIsFirstTime(false);
                          isGuest = true;
                          context.pushNamed(
                            kIsWeb
                                ? WebRoutes.homeScreen.name
                                : AppRoutes.homeScreen.name,
                          );
                        },
                        child: Center(
                          child: Text(
                            "Continue as guest",
                            style: medium(
                              fontSize: 14.sp,
                              color: AppColors.primary.withValues(alpha: 0.85),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    40.w.verticalSpace,
                  ],
                );
              },
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.fromLTRB(25, 0, 25, context.bottomPadding + 30),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       AppFiledButton(
      //         text: _currentIndex == 0
      //             ? "Continue with Free Account"
      //             : "Subscribe",
      //         onTap: () {
      //           context.read<AuthProvider>().clearSignUpControllers();
      //
      //           context.push(
      //             AppRoutes.signup,
      //             extra: {'is_free_sign_up': _currentIndex == 0},
      //           );
      //           context.read<AuthProvider>().clearSignUpControllers();
      //         },
      //       ),
      //       // 12.h.verticalSpace,
      //       // Row(
      //       //   mainAxisAlignment: MainAxisAlignment.center,
      //       //   children: List.generate(
      //       //     planData.length,
      //       //     (index) => GestureDetector(
      //       //       onTap: () {
      //       //         setState(() {
      //       //           _currentIndex = index;
      //       //         });
      //       //       },
      //       //       child: AnimatedContainer(
      //       //         duration: Duration(milliseconds: 300),
      //       //         margin: EdgeInsets.symmetric(horizontal: 4),
      //       //         height: 15.w,
      //       //         width: 15.w,
      //       //         decoration: BoxDecoration(
      //       //           color: _currentIndex == index
      //       //               ? AppColors.primary
      //       //               : AppColors.primary.setOpacity(0.3),
      //       //         ),
      //       //       ),
      //       //     ),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _paymentDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Yearly",
              style: regular(
                fontSize: 20.sp,
                fontFamily: AppFontFamily.secondary,
              ),
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
                    text: "/year",
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    text: "\$ 249.99 ",
                    style: bold(
                      fontSize: 16.sp,
                      fontFamily: AppFontFamily.primary,
                    ),
                  ),
                  TextSpan(
                    text: "/one off",
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

  RichText _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Mug Punter?\nBecome ",
            style: regular(
              fontSize: 40.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
          TextSpan(
            text: "Pro ",
            style: regular(
              fontSize: 40.sp,
              color: AppColors.premiumYellow,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
          TextSpan(
            text: "with AI.",
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
