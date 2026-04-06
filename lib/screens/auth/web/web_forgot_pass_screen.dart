import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/theme/app_colors.dart';
import 'package:puntgpt_nick/core/theme/text_style.dart';
import 'package:puntgpt_nick/core/utils/de_bouncing.dart';
import 'package:puntgpt_nick/core/utils/field_validators.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';
import 'package:puntgpt_nick/core/widgets/app_text_field.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/core/responsive/responsive_builder.dart';

import '../../../core/utils/custom_loader.dart';
import '../../../core/widgets/web_top_section.dart';

class WebForgotPassScreen extends StatelessWidget {
  const WebForgotPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: WebTopSection(),
      body: Center(
        child: SizedBox(
          width: 400, // context.isDesktop ? 400.w : 550.w,
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot Password",
                      textAlign: TextAlign.center,
                      style: regular(
                        fontFamily: AppFontFamily.secondary,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        textAlign: TextAlign.center,
                        "We will send you an OTP to the email address you signed up with.",
                        style: regular(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 36),
                    AppTextField(
                      controller: provider.forgotPasswordCtr,
                      hintText: "Email",
                      validator: FieldValidators().email,
                      hintStyle: medium(
                        fontSize: 16,
                        color: AppColors.primary.withValues(alpha: 0.55),
                      ),
                      onSubmit: () {
                        deBouncer.run(() {
                          if (formKey.currentState!.validate()) {
                            provider.sendOTP(context: context);
                          }
                        });
                      },
                    ),
                    AppFilledButton(
                      margin: EdgeInsets.only(top: 45),
                      text: "Send OTP",
                      child:
                          (provider.isForgotPassLoading &&
                              !context.isBrowserMobile)
                          ? webProgressIndicator(context)
                          : null,
                      onTap: () {
                        if (!provider.isForgotPassLoading) {
                          deBouncer.run(() {
                            if (formKey.currentState!.validate()) {
                              provider.sendOTP(context: context);
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
