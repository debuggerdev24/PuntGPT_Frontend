import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import '../../../../provider/auth/auth_provider.dart';
import '../../../../services/storage/locale_storage_service.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  final List<String> _proBenefits = [
    "Chat function with PuntGPT",
    "Access to PuntGPT Punters Club",
    "Full use of PuntGPT Search Engine",
    "Access to Classic Form Guide",
    "Save PuntGPT Search Engine filters for quick form",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(),
        25.w.verticalSpace,
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.black,
                ),
                child: Column(
                  children: [
                    Text(
                      "Pro Punter",
                      style: medium(
                        fontSize: 18.sp,
                        color: AppColors.white,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    Text(
                      "(From \$9.99/month)",
                      style: medium(
                        fontSize: 12.sp,
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              18.w.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: _paymentDetail(),
              ),
              10.w.verticalSpace,
              Padding(
                padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 28.w),
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
                          path: AppAssets.done,
                          height: 20.w.clamp(18, 25),
                        ),
                        Flexible(
                          child: Text(
                            _proBenefits[i],
                            style: regular(fontSize: 16.sp.clamp(14, 18)),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 5.w),
                  itemCount: _proBenefits.length,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 28.w),
                child: Row(
                  spacing: 16.w,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppFilledButton(
          margin: EdgeInsets.only(top: 25.w),
          text: "Subscribe to Pro",
          onTap: () {
            context.read<AuthProvider>().clearSignUpControllers();
            LocaleStorageService.setIsFirstTime(false);
            context.pushNamed(
              kIsWeb ? WebRoutes.manageSubscriptionScreen.name : AppRoutes.manageSubscriptionScreen.name,
            );
          },
        ),
        12.w.verticalSpace,
        OnMouseTap(
          onTap: () {
            LocaleStorageService.setIsFirstTime(false);
            isGuest = true;
            context.pushNamed(
              kIsWeb ? WebRoutes.homeScreen.name : AppRoutes.homeScreen.name,
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
            text: "Become ",
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
