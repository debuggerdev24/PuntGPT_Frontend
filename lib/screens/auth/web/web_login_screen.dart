import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class WebLoginScreen extends StatelessWidget {
  const WebLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    // final width =
    //     context.screenWidth *
    //     ((context.isDesktop)
    //         ? 0.35
    //         : (context.isTablet)
    //         ? 0.45
    //         : (context.isBrowserMobile)
    //         ? 0.55
    //         : 0.9);
    // Logger.info("$width");
    return Scaffold(
      appBar: WebTopSection(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              width: 360,
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  children: [
                    SizedBox(height: 80),
                    ImageWidget(
                      path: AppAssets.splashWebLogo,
                      type: ImageType.asset,
                      width: 375,
                    ),

                    SizedBox(height: 18),
                    Text(
                      "'@PuntGPT' the talking from guide",
                      style: regular(
                        fontSize: 24,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    SizedBox(height: 60),
                    AppTextField(
                      controller: provider.emailCtr,
                      validator: FieldValidators().email,
                      hintText: "Email",

                      onSubmit: () {
                        if (formKey.currentState!.validate()) {
                          provider.login(context: context);
                          return;
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    AppTextField(
                      controller: provider.passwordCtr,
                      hintText: "Password",
                      validator: (value) {
                        return FieldValidators().required(value, "Password");
                      },
                      onSubmit: () {
                        if (formKey.currentState!.validate()) {
                          provider.login(context: context);
                          return;
                        }
                      },
                      trailingIcon: provider.showLoginPass
                          ? AppAssets.hide
                          : AppAssets.show,
                      onTrailingIconTap: () =>
                          provider.showLoginPass = !provider.showLoginPass,
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OnMouseTap(
                        onTap: () {
                          context.pushNamed(
                            WebRoutes.forgotPasswordScreen.name,
                          );
                          provider.forgotPasswordCtr.clear();
                        },
                        child: Text(
                          "Forgot Password?",
                          style: bold(fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    AppFilledButton(
                      text: "Login",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          provider.login(context: context);
                        }
                      },
                      textStyle: semiBold(fontSize: 16, color: AppColors.white),
                      margin: EdgeInsets.only(bottom: 18),
                      child:
                          (provider.isLoginLoading && !context.isBrowserMobile)
                          ? webProgressIndicator(context)
                          : null,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "New to PuntGPT? ",
                          style: medium(
                            fontSize: 14,
                            color: AppColors.primary.withValues(alpha: 0.8),
                          ),
                        ),
                        OnMouseTap(
                          onTap: () {
                            context.pop();
                          },
                          child: Text(" Sign up", style: bold(fontSize: 14)),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
