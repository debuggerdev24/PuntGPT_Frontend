import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/theme/app_colors.dart';
import 'package:puntgpt_nick/core/theme/text_style.dart';
import 'package:puntgpt_nick/core/utils/de_bouncing.dart';
import 'package:puntgpt_nick/core/utils/field_validators.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';
import 'package:puntgpt_nick/core/widgets/app_text_field.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';

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
          width: context.isDesktop ? 400.w : 550.w,
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot Password",
                      style: regular(
                        fontFamily: AppFontFamily.secondary,
                        fontSize: context.isDesktop
                            ? 40.sp
                            : context.isTablet
                            ? 48.sp
                            : 58.sp,
                      ),
                    ),
                    8.w.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        textAlign: TextAlign.center,
                        "We will send you an OTP to the email address you signed up with.",
                        style: regular(
                          fontSize: context.isDesktop
                              ? 16.sp
                              : context.isTablet
                              ? 24.sp
                              : 32.sp,
                        ),
                      ),
                    ),
                    36.w.verticalSpace,
                    AppTextField(
                      controller: provider.forgotPasswordCtr,
                      hintText: "Email",
                      validator: FieldValidators().email,
                      // errorStyle: medium(
                      //   fontSize: (kIsWeb) ? 25.sp : 12.sp,
                      //   color: AppColors.red,
                      // ),
                      hintStyle: medium(
                        fontSize: (context.isDesktop) ? 16.sp : 22.sp,
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
                      margin: EdgeInsets.only(top: 45.w),
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
