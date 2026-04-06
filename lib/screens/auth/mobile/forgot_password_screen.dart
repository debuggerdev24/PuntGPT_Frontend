import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
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
        appBar: !kIsWeb ? null : WebTopSection(),
        body: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.wSize),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          26.wSize.verticalSpace,
                          
                          Text(
                            "Forgot Password",
                            style: regular(
                              fontFamily: AppFontFamily.secondary,
                              fontSize: 40.fSize,
                              height: (kIsWeb) ? 0.9 : null,
                            ),
                          ),
                          28.wSize.verticalSpace,
                          Text(
                            textAlign: TextAlign.center,
                            "We will send you an OTP to the email address you signed up with.",
                            style: regular(
                              fontSize: 16
                                  .fSize, // (context.isBrowserMobile) ? 30.sp : 16.sp,
                              color: AppColors.primary.withValues(),
                            ),
                          ),
                          26.wSize.verticalSpace,
                          AppTextField(
                            controller: provider.forgotPasswordCtr,
                            hintText: "Email",
                            validator: FieldValidators().email,
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
                ),
                if (provider.isForgotPassLoading) FullPageIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
