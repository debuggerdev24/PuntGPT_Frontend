import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class WebResetPasswordScreen extends StatelessWidget {
  const WebResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: WebTopSection(),
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //todo title
                  Text(
                    "Reset Password",

                    style: regular(
                      fontFamily: AppFontFamily.secondary,
                      fontSize: 38.fSize,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.w, bottom: 18.w),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Enter new password below to reset.",
                      style: regular(fontSize: 16.fSize),
                    ),
                  ),
                  AppTextField(
                    controller: provider.newPasswordCtr,
                    hintText: "New Password",
                    validator: FieldValidators().password,
                  ),
                  SizedBox(height: 8),

                  AppTextField(
                    controller: provider.resetConfirmPasswordCtr,
                    hintText: "Confirm Password",
                    onSubmit: () {
                      deBouncer.run(() {
                        provider.resetPassword(context: context);
                      });
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (provider.newPasswordCtr.text.trim() !=
                            provider.resetConfirmPasswordCtr.text.trim()) {
                          return "Confirm Password should match with new Password!";
                        }
                      }
                      return FieldValidators().required(
                        value,
                        "Confirm Password",
                      );
                    },
                  ),
                  AppFilledButton(
                    text: "Confirm",
                    margin: EdgeInsets.only(top: 34.w),
                    onTap: () {
                      deBouncer.run(() {
                        provider.resetPassword(context: context);
                      });
                    },
                    child:
                        (provider.isResetPasswordLoading &&
                            !context.isBrowserMobile)
                        ? webProgressIndicator(context)
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
