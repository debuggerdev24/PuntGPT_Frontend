import 'package:pinput/pinput.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class WebVerifyOtpScreen extends StatelessWidget {
  const WebVerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final boxSize = context.isDesktop ? 75.w : 85.w;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: WebTopSection(),
      body: Center(
        child: SizedBox(
          width: context.isDesktop ? 400.w : 550.w,
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //todo title
                  Text(
                    "Verify OTP",
                    style: regular(
                      fontFamily: AppFontFamily.secondary,
                      fontSize: context.isDesktop
                          ? 40.sp
                          : context.isTablet
                          ? 48.sp
                          : 58.sp,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 40.w),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Enter the OTP received on your registered email address to reset password.",
                      style: regular(
                        fontSize: context.isDesktop
                            ? 16.sp
                            : context.isTablet
                            ? 24.sp
                            : 32.sp,
                      ),
                    ),
                  ),
                  otpField(provider, context, boxSize),
                  48.w.verticalSpace,
                  OnMouseTap(
                    onTap: () {
                      context.pop();
                    },
                    child: Text(
                      "Didn’t receive OTP?",
                      style: semiBold(
                        fontSize: context.isDesktop ? 16.sp : 24.sp,
                      ),
                    ),
                  ),
                  AppOutlinedButton(
                    text: provider.isResendOtpLoading
                        ? "Resending..."
                        : provider.canResendOtp
                        ? "Re-Send"
                        : "Resend OTP in ${provider.resendSeconds}s",
                    onTap: () {
                      if (provider.canResendOtp &&
                          !provider.isResendOtpLoading) {
                        provider.resendOtp(context: context);
                      }
                    },
                    textStyle: semiBold(
                      fontSize: context.isDesktop ? 16.sp : 24.sp,
                    ),
                    margin: EdgeInsets.only(top: 10.w, bottom: 12.h),
                    child: (provider.isResendOtpLoading)
                        ? webProgressIndicator(
                            context,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  AppFilledButton(
                    margin: EdgeInsets.only(bottom: 20.h),
                    text: "Reset Password",
                    textStyle: semiBold(
                      color: AppColors.white,
                      fontSize: context.isDesktop ? 16.sp : 24.sp,
                    ),
                    onTap: () {
                      provider.verifyOtp(context: context);
                    },
                    child:
                        (provider.isVerifyOtpLoading &&
                            !context.isBrowserMobile)
                        ? webProgressIndicator(context)
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget otpField(AuthProvider provider, BuildContext context, double boxSize) {
    return Pinput(
      controller: provider.otpCtr,
      length: 4,
      separatorBuilder: (index) =>
          context.isDesktop ? 14.w.horizontalSpace : 25.w.horizontalSpace,
      defaultPinTheme: PinTheme(
        height: boxSize, // context.isDesktop ? 400.w / 4 : 550.w / 4,
        width: boxSize, // context.isDesktop ? 400.w / 4 : 410.w / 4,
        textStyle: medium(fontSize: context.isDesktop ? 22.sp : 28.sp),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
      ),
      focusedPinTheme: PinTheme(
        height: boxSize,
        width: boxSize,
        textStyle: medium(fontSize: context.isDesktop ? 22.sp : 28.sp),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
      ),
      submittedPinTheme: PinTheme(
        height: boxSize,
        width: boxSize,

        textStyle: regular(fontSize: context.isDesktop ? 25.sp : 30.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
        ),
      ),
      keyboardType: TextInputType.number,
      onSubmitted: (value) {
        deBouncer.run(() {
          provider.verifyOtp(context: context);
        });
      },
      onCompleted: (code) {
        deBouncer.run(() {
          provider.verifyOtp(context: context);
        });
      },
    );
  }
}
