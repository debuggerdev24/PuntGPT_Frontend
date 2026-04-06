import 'package:puntgpt_nick/core/app_imports.dart';

/// Title for **native mobile** sign-up only (`SignUpScreen`).
/// Web sign-up uses the header built in [WebSignUpScreen].
class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth - 90.w,
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
              textAlign: TextAlign.center,
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
