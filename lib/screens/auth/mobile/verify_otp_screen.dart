import 'package:pinput/pinput.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, value, child) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      26.h.verticalSpace,
                      Text(
                        "Verify OTP",
                        style: regular(
                          fontFamily: AppFontFamily.secondary,
                          fontSize: (context.isBrowserMobile) ? 60.sp : 40.sp,
                        ),
                      ),
                      28.h.verticalSpace,
                      Text(
                        textAlign: TextAlign.center,
                        "Enter the OTP received on your registered email address to reset password.",
                        style: regular(
                          fontSize: (context.isBrowserMobile) ? 30.sp : 16.sp,

                          color: AppColors.primary.withValues(),
                        ),
                      ),
                      28.h.verticalSpace,
                      //todo otp field
                      Pinput(
                        controller: provider.otpCtr,
                        length: 4,

                        separatorBuilder: (index) => (context.isMobileView)
                            ? 28.w.horizontalSpace
                            : 14.w.horizontalSpace,
                        defaultPinTheme: PinTheme(
                          height: (context.isBrowserMobile) ? 80.w : 55.h,
                          width: context.isBrowserMobile ? 80.w : 70.w,
                          textStyle: medium(fontSize: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          height: context.isBrowserMobile ? 80.w : 55.h,
                          width: context.isBrowserMobile ? 80.w : 70.w,

                          // textStyle: medium(fontSize: 20.sp),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                        ),
                        submittedPinTheme: PinTheme(
                          height: (context.isBrowserMobile) ? 80.w : 55.h,
                          width: (context.isBrowserMobile) ? 80.w : 70.w,
                          textStyle: regular(
                            fontSize: (context.isBrowserMobile) ? 35.sp : 30.sp,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onCompleted: (code) {},
                      ),
                      Spacer(),
                      //todo bottom buttons
                      Text(
                        "Didn’t receive OTP?",
                        style: semiBold(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
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
                        textStyle: (context.isBrowserMobile)
                            ? semiBold(fontSize: 30.sp)
                            : null,
                        margin: EdgeInsets.only(top: 10.h, bottom: 12.h),
                      ),
                      SafeArea(
                        child: AppFilledButton(
                          margin: EdgeInsets.only(bottom: 20.h),
                          text: "Reset Password",
                          textStyle: (context.isBrowserMobile)
                              ? semiBold(
                                  fontSize: 30.sp,
                                  color: AppColors.white,
                                )
                              : null,
                          onTap: () {
                            provider.verifyOtp(context: context);
                            // context.pushNamed(AppRoutes.resetPasswordScreen.name);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.isVerifyOtpLoading || provider.isResendOtpLoading)
                  FullPageIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
