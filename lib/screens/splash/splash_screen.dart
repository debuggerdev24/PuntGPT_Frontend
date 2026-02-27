// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/services/account/account_api_service.dart';
import 'package:puntgpt_nick/services/auth/auth_api_service.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String authToken = LocaleStorageService.userToken;

  Timer? _timer;
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    Logger.info("Authorized Token : $authToken");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.pushNamed(AppRoutes.homeScreen.name);
      // return;

      _startTimer();
      Future.delayed(3.seconds).then((value) async {
        Logger.info(
          "is Physical Mobile ${context.isPhysicalMobile} ${context.screenWidth}",
        );
        Logger.info(
          "is Browser Mobile  ${context.isBrowserMobile} ${context.screenWidth}",
        );
        Logger.info("is Tablet ${context.isTablet} ${context.screenWidth}");
        Logger.info("is Desktop ${context.isDesktop} ${context.screenWidth}");

        if (isNetworkConnected.value) {
          if (LocaleStorageService.isFirstTime && authToken.isEmpty) {
            Logger.info("Inside if part");
            Logger.info(AppConfig.apiBaseurl);
            context.goNamed(AppRoutes.ageConfirmationScreen.name);
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
                  "Refresh token : ${LocaleStorageService.refreshToken}",
                );
                final result = await AuthApiService.instance.refreshToken();

                result.fold(
                  (e) async {
                    Logger.error((e.code.toString() == "401").toString());
                    if (e.code.toString() == "401" ||
                        e.code.toString() == "400") {
                      // AppToast.error(
                      //   context: context,
                      //   message: "Refresh token is expired",
                      // );
                      Logger.info("Refresh token is expired");
                      await LocaleStorageService.removeRefreshToken();
                      await LocaleStorageService.removeAccessToken();
                      context.goNamed(AppRoutes.ageConfirmationScreen.name);
                      return;
                    }
                  },
                  (r) {
                    final newToken = r["access"];

                    LocaleStorageService.saveUserToken(newToken);
                    context.goNamed(AppRoutes.homeScreen.name);
                  },
                );
              }
            },
            (r) {
              context.goNamed(AppRoutes.homeScreen.name);
            },
          );

          return;
        }
        context.goNamed(AppRoutes.offlineViewScreen.name);
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageWidget(
              path: AppAssets.splashAppLogo,
              height: 200.w.flexClamp(200, 250),
            ).animate().fade(duration: 0.8.seconds, delay: 1.seconds),
            SizedBox(height: 20.w.flexClamp(20, 25)),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "'@PuntGPT'",
                    style: regular(
                      fontSize: 20.sp,
                      fontFamily: AppFontFamily.secondary,
                    ),
                  ),
                  TextSpan(
                    text: " the talking from guide",
                    style: regular(
                      fontSize: 20.sp,
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
