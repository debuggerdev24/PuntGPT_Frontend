import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: !kIsWeb ? null : WebTopSection(),
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: SizedBox(
                  width: Responsive.isMobileWeb(context)
                      ? double.maxFinite
                      : 500.w.flexClamp(null, 500),
                  child: Column(
                    children: [
                      120.h.verticalSpace,
                      ImageWidget(path: AppAssets.splashAppLogo),
                      16.h.verticalSpace,
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "'@PuntGPT'",
                              style: regular(
                                fontSize: 20.sp,
                                fontFamily: AppFontFamily.secondary,
                              ),
                            ),
                            TextSpan(
                              text: " the talking from guide",
                              style: regular(
                                fontSize: 20.sp,
                                fontFamily: AppFontFamily.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      80.h.verticalSpace,
                      //todo login fields amil and pass
                      Form(
                        key: formKey,
                        child: Column(
                          spacing: 8.h,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppTextField(
                              controller: provider.loginEmailCtr,
                              hintText: "Email",
                              validator: FieldValidators().email,
                            ),
                            AppTextField(
                              controller: provider.loginPasswordCtr,
                              hintText: "Password",
                              obscureText: provider.showLoginPass,
                              validator: FieldValidators().password,
                              trailingIcon: provider.showLoginPass
                                  ? AppAssets.hide
                                  : AppAssets.show,
                              onTrailingIconTap: () => provider.showLoginPass =
                                  !provider.showLoginPass,
                            ),
                          ],
                        ),
                      ),
                      10.h.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.forgotPasswordScreen.name,
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forget Password?",
                            style: bold(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      100.verticalSpace,
                      AppFilledButton(
                        text: "Login",
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            // context.go(AppRoutes.home);
                            await provider.loginUser(context: context);
                          }
                        },
                      ),
                      15.w.verticalSpace,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "New to PuntGPT? ",
                            style: medium(
                              fontSize: 14.sp,
                              color: AppColors.primary.setOpacity(.8),
                            ),
                          ),
                          OnMouseTap(
                            onTap: () {
                              context.pushReplacementNamed(
                                AppRoutes.signUpScreen.name,
                              );
                            },
                            child: Text(
                              " Sign up",
                              style: bold(fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                      20.h.verticalSpace,
                    ],
                  ),
                ),
              ),
              if (provider.isLoginLoading) FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }
}
