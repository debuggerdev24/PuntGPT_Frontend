import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/auth/auth_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpBottomSection extends StatelessWidget {
  const SignUpBottomSection({
    super.key,
    required this.onLoginTap,
    required this.onSignUpTap,
  });

  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

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
        AppFilledButton(text: "Create Account", onTap: onSignUpTap),
        10.w.verticalSpace,
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Terms & Conditions",
              style: bold(
                fontSize: 14.sp,
                decoration: TextDecoration.underline,
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: AppColors.primary,
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            // Text("AI disclaimer", style: bold(fontSize: 14.sp)),
            // Container(
            //   width: 1,
            //   height: 20,
            //   color: AppColors.primary,
            //   margin: EdgeInsets.symmetric(horizontal: 10),
            // ),
            // ),
            OnMouseTap(
              onTap: () {
                launchUrl(
                  Uri.parse(kPrivacyPolicyUrl),
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
      ],
    );
  }
}
