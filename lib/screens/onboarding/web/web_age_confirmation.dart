import 'package:puntgpt_nick/core/widgets/web_top_section.dart';

import 'package:puntgpt_nick/core/app_imports.dart';

class WebAgeConfirmationScreen extends StatelessWidget {
  const WebAgeConfirmationScreen({super.key});

  void _onYesTap(BuildContext context) {
    context.goNamed(WebRoutes.onBoardingScreen.name);
  }

  void _onNoTap(BuildContext context) {
    context.goNamed(WebRoutes.onBoardingScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    Logger.info(
      "is Browser Mobile ${context.isBrowserMobile} ${context.screenWidth}",
    );
    Logger.info("is Mobile ${context.isPhysicalMobile} ${context.screenWidth}");
    Logger.info("is Desktop ${context.isDesktop} ${context.screenWidth}");
    Logger.info("is Tablet ${context.isTablet} ${context.screenWidth}");
    return Scaffold(
      appBar: WebTopSection(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you over 18?",
                textAlign: TextAlign.center,
                style: regular(
                  fontFamily: AppFontFamily.secondary,
                  fontSize: context.isDesktop
                      ? 40.sp
                      : context.isTablet
                      ? 48.sp
                      : (context.isBrowserMobile)
                      ? 80.sp
                      : 40.sp,
                ),
              ),
              SizedBox(height: 50.w.clamp(20, 80)),
              if (context.isDesktop || context.isTablet) ...[
                OnMouseTap(
                  child: AppFilledButton(
                    onTap: () => _onYesTap(context),
                    text: "Yes",
                    textStyle: semiBold(
                      fontSize: (context.isDesktop)
                          ? 16.sp
                          : context.isTablet
                          ? 22.sp
                          : 26.sp,
                      color: AppColors.white,
                    ),
                    width: (context.isDesktop)
                        ? 400.w
                        : context.isTablet
                        ? 450.w
                        : null,
                  ),
                ),
                10.verticalSpace,
                OnMouseTap(
                  child: AppOutlinedButton(
                    onTap: () => _onNoTap(context),
                    text: "No",
                    textStyle: semiBold(
                      fontSize: (context.isDesktop)
                          ? 16.sp
                          : context.isTablet
                          ? 22.sp
                          : 26.sp,
                    ),
                    width: (context.isDesktop)
                        ? 400.w
                        : context.isTablet
                        ? 450.w
                        : null,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: context.isBrowserMobile || context.isPhysicalMobile
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                25,
                0,
                25,
                context.bottomPadding + 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppFilledButton(
                    onTap: () => _onYesTap(context),
                    text: "Yes",
                    textStyle: semiBold(
                      fontSize: 18.sp.flexClamp(16, 20),
                      color: AppColors.white,
                    ),
                  ),
                  10.h.verticalSpace,
                  AppOutlinedButton(
                    onTap: () => _onNoTap(context),
                    text: "No",
                    textStyle: semiBold(fontSize: 18.sp.flexClamp(16, 20)),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
