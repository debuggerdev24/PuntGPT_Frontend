import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/auth/mobile/widgets/sign_up_form.dart';
import 'package:puntgpt_nick/screens/auth/web/widgets/web_sign_up_form.dart';
import 'package:puntgpt_nick/screens/auth/web/widgets/web_signup_bottom.dart';

class WebSignUpScreen extends StatelessWidget {
  const WebSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: WebTopSection(),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  _webSignUpTitle(context),
                  SizedBox(height: 40),


                  (context.isMobileView)
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),

                          child: SignUpForm(formKey: formKey),
                        )
                      : WebSignUpForm(formKey: formKey),

                  //   SignUpForm(formKey: formKey) : WebSignUpForm(formKey: formKey),
                  20.verticalSpace,
                  WebSignUpBottomSection(
                    onLoginTap: () {
                      provider.clearLoginControllers();
                      context.pushNamed(WebRoutes.logInScreen.name);
                    },
                    onSignUpTap: () {
                      deBouncer.run(() {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        provider.registerUser(context: context);
                      });
                    },
                    provider: provider,
                  ),
                ],
              ),
            ),
            if (provider.isSignUpLoading) FullPageIndicator(),
          ],
        ),
      ),
    );
  }
}

Widget _webSignUpTitle(BuildContext context) {
  const double kBackTapWidth = 48;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnMouseTap(
              onTap: () => context.pop(),
              child: SizedBox(
                width: kBackTapWidth,
                height: kBackTapWidth,
                child: Center(
                  child: Icon(Icons.arrow_back_ios_rounded, size: 22),
                ),
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Create",
                      style: regular(
                        height: 1,
                        fontSize: 36,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                    TextSpan(
                      text: " “Pro Punter” ",
                      style: regular(
                        height: 1,
                        fontSize: 36,
                        fontFamily: AppFontFamily.secondary,
                        color: AppColors.premiumYellow,
                      ),
                    ),
                    TextSpan(
                      text: "Account",
                      style: regular(
                        height: 1,
                        fontSize: 36,
                        fontFamily: AppFontFamily.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            kBackTapWidth.horizontalSpace,
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Cancel Subscription anytime",
          textAlign: TextAlign.center,
          style: regular(
            fontSize: 16,
            color: AppColors.primary.setOpacity(0.8),
          ),
        ),
      ],
    ),
  );
}
