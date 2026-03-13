import 'package:puntgpt_nick/core/app_imports.dart';

class SignUpBottomSection extends StatelessWidget {
  const SignUpBottomSection({
    super.key,
    required this.onLoginTap,
    required this.onSignUpTap,
    this.onContinueAsGuestTap,
  });

  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;
  final VoidCallback? onContinueAsGuestTap;

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
        10.h.verticalSpace,
        AppFilledButton(text: "Create Account", onTap: onSignUpTap),
        if (onContinueAsGuestTap != null) ...[
          12.h.verticalSpace,
          OnMouseTap(
            onTap: onContinueAsGuestTap!,
            child: Center(
              child: Text(
                "Continue as guest",
                style: medium(
                  fontSize: 14.sp,
                  color: AppColors.primary.setOpacity(.85),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
        10.h.verticalSpace,
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("Terms & Conditions", style: bold(fontSize: 14.sp)),
            Container(
              width: 1,
              height: 20,
              color: AppColors.primary,
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            Text("AI disclaimer", style: bold(fontSize: 14.sp)),
            Container(
              width: 1,
              height: 20,
              color: AppColors.primary,
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            Text("Privacy Policy", style: bold(fontSize: 14.sp)),
          ],
        ),
      ],
    );
  }
}
