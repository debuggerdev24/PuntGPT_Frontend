import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/core/utils/custom_loader.dart';
import 'package:puntgpt_nick/core/utils/de_bouncing.dart';
import 'package:puntgpt_nick/core/widgets/app_check_box.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/widgets/sign_up_bottom_section.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/widgets/sign_up_form.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/widgets/sign_up_title.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.isFreeSignUp});
  final bool isFreeSignUp;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: !kIsWeb ? null : WebTopSection(),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            Logger.info(provider.isSignUpLoading.toString());

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 30.h),
                  child: Column(
                    children: [
                      //todo title
                      SignUpTitle(isFreeSignUp: isFreeSignUp),
                      20.h.verticalSpace,
                      //todo main body
                      SignUpForm(formKey: formKey),
                      12.h.verticalSpace,
                      //todo bottom section
                      SizedBox(
                        width: context.isMobileView
                            ? double.maxFinite
                            : context.screenWidth * 0.8.flexClamp(null, 800),
                        child: AppCheckBox(
                          value: provider.isReadTermsAndConditions,
                          onChanged: (value) {
                            provider.isReadTermsAndConditions = value;
                          },
                          label: Text(
                            "I have read and accept the Terms & Conditions, AI disclaimer and understand my personal information will be handled in accordance with the Privacy Policy.",
                            style: regular(
                              fontSize: 14.sp,
                              height: 1.4,
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                      30.h.verticalSpace,
                      SignUpBottomSection(
                        onLoginTap: () {
                          context.pushReplacementNamed(
                            AppRoutes.loginScreen.name,
                            extra: {"is_free_sign_up": isFreeSignUp},
                          );
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
                      ),
                    ],
                  ),
                ),
                if (provider.isSignUpLoading) FullPageIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
