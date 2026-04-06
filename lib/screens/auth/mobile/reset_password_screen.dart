import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: (kIsWeb)? WebTopSection() : null,
          body: Consumer<AuthProvider>(
            builder: (context, provider, child) => Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        28.w.verticalSpace,
                        Text(
                          "Reset Password",
                          style: regular(
                            fontFamily: AppFontFamily.secondary,
                            fontSize: 40.fSize,
                          ),
                        ),
                        28.w.verticalSpace,
                        Text(
                          textAlign: TextAlign.center,
                          "Enter new password below to reset.",
                          style: regular(
                            fontSize: 16.fSize,
                            color: AppColors.primary.withValues(),
                          ),
                        ),
                        55.w.verticalSpace,
                        AppTextField(
                          controller: provider.newPasswordCtr,
                          hintText: "New Password",
                          validator: FieldValidators().password,
                        ),
                        //(kIsWeb) ? SizedBox(height: 15) : 
                        15.w.verticalSpace,
                        AppTextField(
                          controller: provider.resetConfirmPasswordCtr,
                          hintText: "Confirm Password",
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (provider.newPasswordCtr.text.trim() !=
                                  provider.resetConfirmPasswordCtr.text
                                      .trim()) {
                                return "Confirm Password should match with new Password!";
                              }
                            }
                            return FieldValidators().required(
                              value,
                              "Confirm Password",
                            );
                          },
                        ),
                        Spacer(),
                        SafeArea(
                          child: AppFilledButton(
                            margin: EdgeInsets.only(bottom: 20.w),
                            // textStyle: context.isBrowserMobile
                            //     ? semiBold(
                            //         fontSize: 30.sp,
                            //         color: AppColors.white,
                            //       )
                            //     : null,
                            text: "Confirm",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                provider.resetPassword(context: context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // if (provider.isResetPasswordLoading) FullPageIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
