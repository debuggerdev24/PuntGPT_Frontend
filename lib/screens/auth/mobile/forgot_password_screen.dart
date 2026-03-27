import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          26.h.verticalSpace,
                          Text(
                            "Forgot Password",
                            style: regular(
                              fontFamily: AppFontFamily.secondary,
                              fontSize: (context.isBrowserMobile) ? 60.sp : 40.sp,
                            ),
                          ),
                          28.h.verticalSpace,
                          Text(
                            textAlign: TextAlign.center,
                            "We will send you an OTP to the email address you signed up with.",
                            style: regular(
                              fontSize: (context.isBrowserMobile) ? 30.sp : 16.sp,
                              color: AppColors.primary.withValues(),
                            ),
                          ),
                          26.h.verticalSpace,
                          AppTextField(
                            controller: provider.forgotPasswordCtr,
                            hintText: "Email",
                            validator: FieldValidators().email,
                            errorStyle: medium(
                              fontSize: (context.isBrowserMobile) ? 25.sp : 12.sp,
                              color: AppColors.red,
                            ),
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                            onSubmit: () {
                              deBouncer.run(() {
                                if (formKey.currentState!.validate()) {
                                  provider.sendOTP(context: context);
                                }
                              });
                            },
                          ),
                          Spacer(),
                          SafeArea(
                            child: AppFilledButton(
                              margin: EdgeInsets.only(bottom: 20.h),
                              text: "Send OTP",
      
                              textStyle: (context.isBrowserMobile)
                                  ? semiBold(
                                      fontSize: 30.sp,
                                      color: AppColors.white,
                                    )
                                  : null,
                              onTap: () {
                                deBouncer.run(() {
                                  if (formKey.currentState!.validate()) {
                                    provider.sendOTP(context: context);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (provider.isForgotPassLoading) FullPageIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
