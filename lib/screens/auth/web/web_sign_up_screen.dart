import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/auth/mobile/widgets/sign_up_title.dart';
import 'package:puntgpt_nick/screens/auth/web/widgets/web_sign_up_form.dart';
import 'package:puntgpt_nick/screens/auth/web/widgets/web_signup_bottom.dart';

class WebSignUpScreen extends StatelessWidget {
  const WebSignUpScreen({super.key, required this.isFreeSignUp});
  final bool isFreeSignUp;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: WebTopSection(),
      body: Container(
        alignment: context.isMobileView
            ? Alignment.topLeft
            : Alignment.topCenter,
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) => Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30.w),

                child: Column(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: OnMouseTap(
                            onTap: () {},
                            child: SignUpTitle(isFreeSignUp: isFreeSignUp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: (context.isDesktop) ? 35.w : 12.w,
                            top: (context.isBrowserMobile) ? 30.h : 14.h,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: OnMouseTap(
                              onTap: () {
                                context.pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: context.isDesktop ? 22.w : 28.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    50.h.verticalSpace,

                    WebSignUpForm(formKey: formKey),
                    20.h.verticalSpace,
                    WebSignUpBottomSection(
                      onLoginTap: () {
                        // LogHelper.info(Responsive.isDesktop(context))
                        provider.clearLoginControllers();
                        context.pushNamed(WebRoutes.logInScreen.name);
                      },
                      onSignUpTap: () {
                        deBouncer.run(() {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          provider.registerUser(
                            context: context,
                            isFreeSignUp: isFreeSignUp,
                          );
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
      ),
    );
  }
}
