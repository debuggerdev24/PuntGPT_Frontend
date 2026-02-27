
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/screens/onboarding/mobile/widgets/video_widget.dart';

import '../../../provider/auth/auth_provider.dart';
import '../../../services/storage/locale_storage_service.dart';

class WebOnboardingScreen extends StatelessWidget {
  const WebOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> planData = [
      {
        "title": "Free 'Mug Punter' Account",
        "price": "",
        "points": [
          {"icon": AppAssets.close, "text": "No chat function with PuntGPT"},
          {
            "icon": AppAssets.close,
            "text": "No access to PuntGPT Punters Club",
          },
          {
            "icon": AppAssets.done,
            "text": "Limited PuntGPT Search Engine Filters",
          },
          {"icon": AppAssets.done, "text": "Limited AI analysis of horses"},
          {"icon": AppAssets.done, "text": "Access to Classic Form Guide"},
        ],
      },
      {
        "title": "Monthly",
        "price": "9.99",
        "points": [
          {"icon": AppAssets.done, "text": "Chat function with PuntGPT"},
          {"icon": AppAssets.done, "text": "Access to PuntGPT Punters Club"},
          {"icon": AppAssets.done, "text": "Full use of PuntGPT Search Engine"},
          {"icon": AppAssets.done, "text": "Access to Classic Form Guide"},
        ],
      },
      {
        "title": "Yearly",
        "price": "59.99",
        "points": [
          {"icon": AppAssets.done, "text": "Chat function with PuntGPT"},
          {"icon": AppAssets.done, "text": "Access to PuntGPT Punters Club"},
          {"icon": AppAssets.done, "text": "Full use of PuntGPT Search Engine"},
          {"icon": AppAssets.done, "text": "Access to Classic Form Guide"},
        ],
      },
      {
        "title": "Lifetime",
        "price": "159.99",
        "points": [
          {"icon": AppAssets.done, "text": "Chat function with PuntGPT"},
          {"icon": AppAssets.done, "text": "Access to PuntGPT Punters Club"},
          {"icon": AppAssets.done, "text": "Full use of PuntGPT Search Engine"},
          {"icon": AppAssets.done, "text": "Access to Classic Form Guide"},
        ],
      },
    ];
    Logger.info(
      "is Mobile ${Responsive.isMobileWeb(context)} ${context.screenWidth}",
    );
    Logger.info(
      "is Desktop ${Responsive.isDesktop(context)} ${context.screenWidth}",
    );
    Logger.info(
      "is Tablet ${Responsive.isTablet(context)} ${context.screenWidth}",
    );
    return Scaffold(
      appBar: WebTopSection(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              30.h.verticalSpace,
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 50.w,
                runSpacing: 20.w,
                children: [
                  VideoWidget(
                    height: 240.w.flexClamp(220, 260),
                    width: 390.w.flexClamp(370, 410),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mug Punter?",
                        style: regular(
                          fontSize: context.isDesktop
                              ? 38.sp
                              : context.isTablet
                              ? 50.sp
                              : context.isBrowserMobile
                              ? 62.sp
                              : 48.sp,

                          height: context.isPhysicalMobile ? 1 : null,

                          fontFamily: AppFontFamily.secondary,
                        ),
                      ),
                      Text(
                        "Become Pro with AI.",
                        style: regular(
                          fontSize: context.isDesktop
                              ? 38.sp
                              : context.isTablet
                              ? 50.sp
                              : context.isBrowserMobile
                              ? 62.sp
                              : 48.sp,
                          fontFamily: AppFontFamily.secondary,
                          height: context.isPhysicalMobile ? 1 : null,
                          color: AppColors.premiumYellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              50.h.verticalSpace,
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 25,
                children: List.generate(planData.length, (index) {
                  return Container(
                    width: 280.w.flexClamp(260, 300),
                    // height: context.isDesktop
                    //     ? 500.w
                    //     : context.isTablet
                    //     ? 800.w
                    //     : 1000.w,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary.setOpacity(0.2),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 17),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        planData[index]['title'].toString().split(" ").length !=
                                1
                            ? Text(
                                planData[index]['title'],
                                style: regular(
                                  fontSize: 24.sp.flexClamp(18, 26),
                                  fontFamily: AppFontFamily.secondary,
                                ),
                              )
                            : RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: planData[index]['title'].toString(),
                                      style: regular(
                                        fontSize: 24.sp.flexClamp(20, 26),
                                        fontFamily: AppFontFamily.secondary,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ‘Pro Punter’ ',
                                      style: regular(
                                        fontSize: 24.sp.flexClamp(20, 26),
                                        fontFamily: AppFontFamily.secondary,
                                        color: AppColors.premiumYellow,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Account',
                                      style: regular(
                                        fontSize: 24.sp.flexClamp(20, 26),
                                        fontFamily: AppFontFamily.secondary,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        12.h.verticalSpace,
                        ...List.generate(
                          (planData[index]['points'] as List).length,
                          (i) {
                            Map item = planData[index]['points'][i];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageWidget(
                                  type: ImageType.svg,
                                  path: item['icon'],
                                  height: 20.w.clamp(18, 25),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    item['text'],
                                    style: regular(
                                      fontSize: 16.sp.clamp(14, 18),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        (index == 0) ? 48.w.verticalSpace : 40.w.verticalSpace,
                        planData[index]['price'].toString().isEmpty
                            ? const SizedBox()
                            : Row(
                                children: [
                                  Text(
                                    "\$ ${planData[index]['price'].toString()}",
                                    style: bold(
                                      fontSize: 24.sp.flexClamp(20, 26),
                                    ),
                                  ),
                                  Text(
                                    " /${planData[index]['title'].toString().toLowerCase()}",
                                    style: bold(
                                      fontSize: 14.sp.flexClamp(12, 16),
                                      color: AppColors.primary.setOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                        AppFilledButton(
                          text: planData[index]['price'].toString().isEmpty
                              ? "Create a Free Account"
                              : "Subscribe",
                          textStyle: semiBold(
                            color: AppColors.white,
                            fontSize: context.isDesktop
                                ? 18.sp
                                : context.isTablet
                                ? 26.sp
                                : context.isBrowserMobile
                                ? 38.sp
                                : 18.sp,
                          ),
                          onTap: () {
                            context
                                .read<AuthProvider>()
                                .clearSignUpControllers();
                            LocaleStorageService.setIsFirstTime(false);

                            context.pushNamed(
                              WebRoutes.signUpScreen.name,
                              extra: planData[index]['price']
                                  .toString()
                                  .isEmpty,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              50.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
