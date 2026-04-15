import 'package:puntgpt_nick/core/app_imports.dart';

class AgeConfirmationScreen extends StatelessWidget {
  const AgeConfirmationScreen({super.key});

  void _onYesTap(BuildContext context) {
    context.pushNamed(AppRoutes.signUpScreen.name);//commenting the onboardingScreen to avoid the login flow.
  }

  void _onNoTap(BuildContext context) {
    context.pushNamed(AppRoutes.signUpScreen.name);//commenting the onboardingScreen to avoid the login flow.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you over 18?",
                textAlign: TextAlign.center,
                style: regular(
                  fontFamily: AppFontFamily.secondary,
                  fontSize: 40.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: context.isPhysicalMobile
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                25,
                0,
                25,
                context.bottomPadding + 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppFilledButton(onTap: () => _onYesTap(context), text: "Yes"),
                  10.h.verticalSpace,
                  AppOutlinedButton(onTap: () => _onNoTap(context), text: "No"),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
