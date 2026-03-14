import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:puntgpt_nick/core/widgets/web_top_section.dart';

import 'package:puntgpt_nick/core/app_imports.dart';
import '../../main.dart';
import '../../services/account/account_api_service.dart';
import '../../services/auth/auth_api_service.dart';
import '../../services/storage/locale_storage_service.dart';

class WebSplashScreen extends StatefulWidget {
  const WebSplashScreen({super.key});

  @override
  State<WebSplashScreen> createState() => _WebSplashScreenState();
}

class _WebSplashScreenState extends State<WebSplashScreen> {
  String authToken = LocaleStorageService.acccessToken;

  Timer? _timer;
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    Logger.info("Authorized Token : $authToken");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {


      _startTimer();
      Future.delayed(3.seconds).then((value) async {
        // return;

        if (isNetworkConnected.value) {
          if (LocaleStorageService.isFirstTime && authToken.isEmpty) {
            Logger.info("Inside if part");

            context.goNamed(WebRoutes.ageConfirmationScreen.name);

            return;
          }
          //todo checking token is expire or not.

          final result = await AccountApiService.instance.getProfile();
          result.fold(
            (l) async {
              if (l.errorMsg.startsWith("Unauthorized") &&
                  l.code.toString() == "401") {
                // AppToast.error(
                //   context: context,
                //   message: "Access token is expired",
                // );
                Logger.info("Access token is expired");
                Logger.info(
                  "Refresh token is: ${LocaleStorageService.refreshToken}",
                );
                final result = await AuthApiService.instance.refreshToken();
                result.fold(
                  (e) async {
                    Logger.error("Error Code : ${e.code}");
                    Logger.error("Error Code : ${e.errorMsg}");
                    Logger.error("Error Code : ${e.apiErrorMsg}");
                    if (e.code.toString() == "401" ||
                        e.code.toString() == "400") {
                      Logger.info("Refresh token is expired");
                      await LocaleStorageService.removeRefreshToken();
                      await LocaleStorageService.removeAccessToken();

                      context.goNamed(WebRoutes.ageConfirmationScreen.name);
                      return;
                    }
                  },
                  (r) {
                    final newToken = r["access"];
                    LocaleStorageService.saveUserToken(newToken);
                    context.goNamed(WebRoutes.homeScreen.name);
                  },
                );
              }
            },
            (r) {
              Logger.info("I am inside the success part");
              Logger.info(r.toString());
              context.goNamed(WebRoutes.homeScreen.name);
            },
          ); //

          return;
        }
        //todo need to manage offline view for web
        // context.goNamed(WebRoutes.offlineViewScreen.name);
        return;
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      currentIndex++;
      if (currentIndex > 2) {
        currentIndex = -1;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Logger.info(context.screenWidth.toString());
    return Scaffold(
      appBar: WebTopSection(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageWidget(
              path: AppAssets.splashWebLogo,
              type: ImageType.asset,
              height: context.isPhysicalMobile ? 250.w : 300.w,
            ).animate().fade(duration: 0.8.seconds, delay: 1.seconds),
            24.h.flexClamp(20, 28).verticalSpace,
            Text(
              "A new way of betting here",
              style: medium(
                fontFamily: AppFontFamily.secondary,
                fontSize: 20.sp,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "'@PuntGPT'",
                    style: regular(
                      fontSize: 24.sp,
                      fontFamily: AppFontFamily.secondary,
                    ),
                  ),
                  TextSpan(
                    text: " the talking from guide",
                    style: regular(
                      fontSize: 24.sp,
                      fontFamily: AppFontFamily.secondary,
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 0.8.seconds, delay: 1.3.seconds),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: context.bottomPadding > 0
                  ? context.bottomPadding + 20
                  : 30,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: 280.ms,
                  height: 15.w.flexClamp(15, 20),
                  width: 15.w.flexClamp(15, 20),
                  color: currentIndex >= 0
                      ? AppColors.primary
                      : AppColors.primary.setOpacity(0.1),
                ),
                SizedBox(width: 8.w.flexClamp(8, 12)),
                AnimatedContainer(
                  duration: 280.ms,
                  height: 15.w.flexClamp(15, 20),
                  width: 15.w.flexClamp(15, 20),
                  color: currentIndex >= 1
                      ? AppColors.primary
                      : AppColors.primary.setOpacity(0.1),
                ),
                SizedBox(width: 8.w.flexClamp(8, 12)),
                AnimatedContainer(
                  duration: 280.ms,
                  height: 15.w.flexClamp(15, 20),
                  width: 15.w.flexClamp(15, 20),
                  color: currentIndex == 2
                      ? AppColors.primary
                      : AppColors.primary.setOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
