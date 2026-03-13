import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class WebSignUpBottomSection extends StatelessWidget {
  const WebSignUpBottomSection({
    super.key,
    required this.onLoginTap,
    required this.onSignUpTap,
    required this.provider,
    this.onContinueAsGuestTap,
  });

  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;
  final AuthProvider provider;
  final VoidCallback? onContinueAsGuestTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: context.isMobileView
                ? double.maxFinite
                : context.screenWidth * 0.6.flexClamp(null, 600),
            child: AppCheckBox(
              value: provider.isReadTermsAndConditions,
              onChanged: (value) {
                provider.isReadTermsAndConditions = value;
              },
              label: Text(
                "I have read and accept the Terms & Conditions, AI disclaimer and understand my personal information will be handled in accordance with the Privacy Policy.",
                style: regular(
                  fontSize: (context.isDesktop)
                      ? 14.sp
                      : (context.isTablet)
                      ? 22.sp
                      : (context.isBrowserMobile)
                      ? 30.sp
                      : 14.sp,
                  height: 1.2,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          60.h.verticalSpace,

          AppFilledButton(
            text: "Create Account",
            width: (context.isDesktop)
                ? 400.w
                : (context.isTablet)
                ? 500.w
                : 600.w,
            onTap: onSignUpTap,
            textStyle: semiBold(
              fontSize: (context.isDesktop)
                  ? 16.sp
                  : (context.isTablet)
                  ? 24.sp
                  : (context.isBrowserMobile)
                  ? 30.sp
                  : 18.sp, //(kIsWeb) ? 28.sp : 18.sp,
              color: AppColors.white,
            ),
          ),
          if (onContinueAsGuestTap != null) ...[
            12.h.verticalSpace,
            OnMouseTap(
              onTap: onContinueAsGuestTap!,
              child: Center(
                child: Text(
                  "Continue as guest",
                  style: medium(
                    fontSize: (context.isDesktop)
                        ? 14.sp
                        : (context.isTablet)
                        ? 20.sp
                        : (context.isBrowserMobile)
                        ? 22.sp
                        : 14.sp,
                    color: AppColors.primary.setOpacity(.85),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
          20.h.verticalSpace,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Already Registered?",
                style: regular(
                  fontSize: (context.isDesktop)
                      ? 14.sp
                      : (context.isTablet)
                      ? 22.sp
                      : (context.isBrowserMobile)
                      ? 28.sp
                      : 14.sp,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
              OnMouseTap(
                onTap: onLoginTap,
                child: Text(
                  " Login",
                  style: bold(
                    fontSize: (context.isDesktop)
                        ? 14.sp
                        : (context.isTablet)
                        ? 22.sp
                        : (context.isBrowserMobile)
                        ? 28.sp
                        : 14.sp,
                  ),
                ),
              ),
            ],
          ),
          60.h.verticalSpace,
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Terms & Conditions",
                style: bold(
                  fontSize: (context.isDesktop)
                      ? 12.sp
                      : (context.isTablet)
                      ? 20.sp
                      : (context.isBrowserMobile)
                      ? 22.sp
                      : 14.sp,
                ),
              ),
              Container(
                width: 1,
                height: 20.h,
                color: AppColors.primary,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              Text(
                "AI disclaimer",
                style: bold(
                  fontSize: (context.isDesktop)
                      ? 12.sp
                      : (context.isTablet)
                      ? 20.sp
                      : (context.isBrowserMobile)
                      ? 22.sp
                      : 14.sp,
                ),
              ),
              Container(
                width: 1,
                height: 20.h,
                color: AppColors.primary,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              Text(
                "Privacy Policy",
                style: bold(
                  fontSize: (context.isDesktop)
                      ? 12.sp
                      : (context.isTablet)
                      ? 20.sp
                      : (context.isBrowserMobile)
                      ? 22.sp
                      : 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
