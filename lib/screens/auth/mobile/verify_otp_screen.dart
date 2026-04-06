import 'package:pinput/pinput.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpFieldHeight = (context.isMobileView) ? 50.0 : 55.w;
    final otpFieldWidth = (context.isMobileView) ? 50.0 : 70.w;
    final provider = context.read<AuthProvider>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: !kIsWeb ? null : WebTopSection(),
          body: Consumer<AuthProvider>(
            builder: (context, value, child) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 26),
                        Text(
                          "Verify OTP",

                          style: regular(
                            fontFamily: AppFontFamily.secondary,
                            fontSize: 40.fSize,
                            height: (kIsWeb) ? 0.9 : null,
                          ),
                        ),
                        SizedBox(height: 28),
                        Text(
                          textAlign: TextAlign.center,
                          "Enter the OTP received on your registered email address to reset password.",
                          style: regular(
                            fontSize: 16.fSize,

                            color: AppColors.primary.withValues(),
                          ),
                        ),
                        SizedBox(height: 28),
                        //* otp field
                        Pinput(
                          controller: provider.otpCtr,
                          length: 4,
                          separatorBuilder: (index) => 18.horizontalSpace,
                          defaultPinTheme: PinTheme(
                            height: otpFieldHeight,
                            width: otpFieldWidth,
                            textStyle: medium(fontSize: 20.fSize),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            height: otpFieldHeight,
                            width: otpFieldWidth,

                            // textStyle: medium(fontSize: 20.sp),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                          ),
                          submittedPinTheme: PinTheme(
                            height: otpFieldHeight.toDouble(),
                            width: otpFieldWidth,
                            textStyle: regular(fontSize: 20.fSize),
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
                          style: semiBold(fontSize: 14.fSize),
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
                          margin: EdgeInsets.only(top: 10.h, bottom: 12.h),
                        ),
                        SafeArea(
                          child: AppFilledButton(
                            margin: EdgeInsets.only(bottom: 20.h),
                            text: "Reset Password",
                            onTap: () {
                              provider.verifyOtp(context: context);
                              // context.pushNamed(AppRoutes.resetPasswordScreen.name);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (provider.isVerifyOtpLoading ||
                      provider.isResendOtpLoading)
                    FullPageIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
