import 'package:puntgpt_nick/core/app_imports.dart';

class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.isBrowserMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          35.w.verticalSpace,
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Create",
                  style: regular(
                    height: 1.2,
                    fontSize: 38.sp,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
                TextSpan(
                  text: " “Pro Punter” ",
                  style: regular(
                    height: 1.2,
                    fontSize: 38.sp,
                    fontFamily: AppFontFamily.secondary,
                    color: AppColors.premiumYellow,
                  ),
                ),
                TextSpan(
                  text: "Account",
                  style: regular(
                    height: 1.2,
                    fontSize: 38.sp,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
              ],
            ),
          ),
          20.w.verticalSpace,
          Text(
            textAlign: TextAlign.center,
            "Cancel Subscription anytime*",
            style: regular(
              fontSize: context.isBrowserMobile ? 30.sp : 16.sp,
              color: AppColors.primary.setOpacity(0.8),
            ),
          ),
        ],
      );
    } else if (context.isTablet) {
      return SizedBox(
        width: context.screenWidth - 90,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              30.w.verticalSpace,
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Create",
                      style: regular(
                        height: 1.2,
                        fontSize: 44.sp,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    TextSpan(
                      text: " “Pro Punter” ",
                      style: regular(
                        height: 1.2,
                        fontSize: 44.sp,
                        fontFamily: AppFontFamily.secondary,
                        color: AppColors.premiumYellow,
                      ),
                    ),
                    TextSpan(
                      text: "Account",
                      style: regular(
                        height: 1.2,
                        fontSize: 38.sp,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              20.w.verticalSpace,
              Text(
                "Cancel Subscription anytime",
                style: regular(
                  fontSize: 24.sp,
                  color: AppColors.primary.setOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: context.screenWidth - 90,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              30.w.verticalSpace,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Create",
                      style: regular(
                        height: 1.2,
                        fontSize: 36.sp,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    TextSpan(
                      text: " “Pro Punter” ",
                      style: regular(
                        height: 1.2,
                        fontSize: 36.sp,
                        fontFamily: AppFontFamily.secondary,
                        color: AppColors.premiumYellow,
                      ),
                    ),
                    TextSpan(
                      text: "Account",
                      style: regular(
                        height: 1.2,
                        fontSize: 36.sp,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              20.w.verticalSpace,
              Text(
                "Cancel Subscription anytime",
                style: regular(
                  fontSize: 16.sp,
                  color: AppColors.primary.setOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
