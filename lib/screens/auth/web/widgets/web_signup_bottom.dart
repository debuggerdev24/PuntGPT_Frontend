import 'dart:math' as math;

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WebSignUpBottomSection extends StatelessWidget {
  const WebSignUpBottomSection({
    super.key,
    required this.onLoginTap,
    required this.onSignUpTap,
    required this.provider,
  });

  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;
  final AuthProvider provider;

  @override
  Widget build(BuildContext context) {
    final hPad = 25.adaptiveSpacing(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: math.min(context.screenWidth - 2 * hPad, 600),
            child: AppCheckBox(
              value: provider.isReadTermsAndConditions,
              onChanged: (value) {
                provider.isReadTermsAndConditions = value;
              },
              label: Text(
                "I have read and accept the Terms & Conditions, AI disclaimer and understand my personal information will be handled in accordance with the Privacy Policy.",
                style: regular(
                  fontSize: 14,
                  height: 1.2,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),

          AppFilledButton(
            text: "Create Account",
            width: (context.isMobileView) ? null : 400,
            onTap: onSignUpTap,
            margin: EdgeInsets.only(top: 60,bottom: 20),
            textStyle: semiBold(
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Already Registered?",
                style: regular(
                  fontSize: 14,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
              OnMouseTap(
                onTap: onLoginTap,
                child: Text(
                  " Login",
                  style: bold(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          60.adaptiveSpacing(context).verticalSpace,
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Terms & Conditions",
                style: bold(
                  fontSize: 12,
                ),
              ),
              Container(
                width: 1,
                height: 20.adaptiveSpacing(context),
                color: AppColors.primary,
                margin: EdgeInsets.symmetric(
                  horizontal: 10.adaptiveSpacing(context),
                ),
              ),
              Text(
                "AI disclaimer",
                style: bold(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
              Container(
                width: 1,
                height: 20.adaptiveSpacing(context),
                color: AppColors.primary,
                margin: EdgeInsets.symmetric(
                  horizontal: 10.adaptiveSpacing(context),
                ),
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
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
