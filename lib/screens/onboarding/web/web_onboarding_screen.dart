import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';

import '../../../provider/auth/auth_provider.dart';
import '../../../services/storage/locale_storage_service.dart';

class WebOnboardingScreen extends StatelessWidget {
  const WebOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const proBenefits = <String>[
      "Chat function with PuntGPT",
      "Access to PuntGPT Punters Club",
      "Full use of PuntGPT Search Engine",
      "Access to Classic Form Guide",
      "Save PuntGPT Search Engine filters for quick form",
    ];
    const mugPunterFeatureLines = <String>[
      "Message PuntGPT and talk horse racing",
      "Save PuntGPT customised searches",
      "PuntGPT Punters Club group chats with AI",
      "Limited use of PuntGPT Search Engine",
      "Limited AI analysis of Horse Selections",
      "Classic Form Guide",
    ];
    const mugPunterFeatureIncluded = <bool>[
      false,
      false,
      false,
      true,
      true,
      true,
    ];

    List<Map> planData = [
      {
        "title": "Free 'Mug Punter' Account",
        "price": "",
        "points": List.generate(mugPunterFeatureLines.length, (index) {
          return {
            "icon": mugPunterFeatureIncluded[index]
                ? AppAssets.done
                : AppAssets.close,
            "text": mugPunterFeatureLines[index],
          };
        }),
      },
      {
        "title": "Monthly",
        "price": "9.99",
        "points": List.generate(proBenefits.length, (index) {
          return {"icon": AppAssets.done, "text": proBenefits[index]};
        }),
      },
      {
        "title": "Yearly",
        "price": "59.99",
        "points": List.generate(proBenefits.length, (index) {
          return {"icon": AppAssets.done, "text": proBenefits[index]};
        }),
      },
      {
        "title": "Lifetime",
        "price": "159.99",
        "points": List.generate(proBenefits.length, (index) {
          return {"icon": AppAssets.done, "text": proBenefits[index]};
        }),
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
              30.verticalSpace,
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 50.w,
                runSpacing: 20.w,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mug Punter?",
                        style: regular(
                          fontSize: 38,
                          // context.isDesktop
                          //     ? 38.sp
                          //     : context.isTablet
                          //     ? 50.sp
                          //     : context.isBrowserMobile
                          //     ? 62.sp
                          //     : 48.sp,
                          height: 1,
                          fontFamily: AppFontFamily.secondary,
                        ),
                      ),
                      Text(
                        "Become Pro with AI.",
                        style: regular(
                          fontSize: 38,
                          // context.isDesktop
                          //     ? 38.sp
                          //     : context.isTablet
                          //     ? 50.sp
                          //     : context.isBrowserMobile
                          //     ? 62.sp
                          //     : 48.sp,
                          fontFamily: AppFontFamily.secondary,
                          height: 1,
                          color: AppColors.premiumYellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              50.verticalSpace,
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
                                  fontSize: 22,
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
                                        fontSize: 22,
                                        fontFamily: AppFontFamily.secondary,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ‘Pro Punter’ ',
                                      style: regular(
                                        fontSize: 22,
                                        fontFamily: AppFontFamily.secondary,
                                        color: AppColors.premiumYellow,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Account',
                                      style: regular(
                                        fontSize: 22,
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
                                  height: 18,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    item['text'],
                                    style: regular(fontSize: 14),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        (index == 0) ? 48.verticalSpace : 40.verticalSpace,
                        planData[index]['price'].toString().isEmpty
                            ? const SizedBox()
                            : Row(
                                children: [
                                  Text(
                                    "\$ ${planData[index]['price'].toString()}",
                                    style: bold(fontSize: 22),
                                  ),
                                  Text(
                                    " /${planData[index]['title'].toString().toLowerCase()}",
                                    style: bold(
                                      fontSize: 12,
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
                            fontSize: 15,
                          ),
                          onTap: () {
                            context
                                .read<AuthProvider>()
                                .clearSignUpControllers();
                            LocaleStorageService.setIsFirstTime(false);
                            context.pushNamed(WebRoutes.signUpScreen.name);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
