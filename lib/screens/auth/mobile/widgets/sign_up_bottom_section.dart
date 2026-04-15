import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpBottomSection extends StatelessWidget {
  const SignUpBottomSection({
    super.key,
    required this.onLoginTap,
    required this.onSignUpTap,
    required this.onContinueAsGuestTap,
  });

  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;
  final VoidCallback onContinueAsGuestTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Already Registered?",
              style: regular(
                fontSize: 14.sp,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
            ),
            OnMouseTap(
              onTap: onLoginTap,
              child: Text(" Login", style: bold(fontSize: 14.sp)),
            ),
          ],
        ),
        10.w.verticalSpace,
        AppFilledButton(
          text: "Create Account",
          onTap: onSignUpTap,
          margin: EdgeInsets.symmetric(horizontal: 25.w),
        ),
        10.w.verticalSpace,
        OnMouseTap(
          onTap: onContinueAsGuestTap,
          child: Text(
            "Continue as guest",
            style: medium(
              fontSize: 14.sp,
              color: AppColors.primary.withValues(alpha: 0.85),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        20.w.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OnMouseTap(
                onTap: () {
                  launchUrl(
                    Uri.parse(AppStrings.termsAndConditionsUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text(
                  "Terms & Conditions",
                  style: bold(
                    fontSize: 14.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 20,
                color: AppColors.primary,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              OnMouseTap(
                onTap: () {
                  launchUrl(
                    Uri.parse(AppStrings.aiDisclaimerUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text(
                  "AI disclaimer",
                  style: bold(
                    fontSize: 14.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 20,
                color: AppColors.primary,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),

              OnMouseTap(
                onTap: () {
                  launchUrl(
                    Uri.parse(AppStrings.privacyPolicyUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text(
                  "Privacy Policy",
                  style: bold(
                    fontSize: 14.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
