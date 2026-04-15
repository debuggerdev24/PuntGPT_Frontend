import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/auth/mobile/widgets/sign_up_bottom_section.dart';
import 'package:puntgpt_nick/screens/auth/mobile/widgets/sign_up_form.dart';
import 'package:puntgpt_nick/screens/auth/mobile/widgets/sign_up_title.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: kIsWeb ? WebTopSection() : null,
          body: SafeArea(
            child: Consumer<AuthProvider>(
              builder: (context, provider, child) {
                Logger.info(provider.isSignUpLoading.toString());
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 30.w),
                            child: Column(
                              children: [
                                //* title
                                SignUpTitle(),
                                20.w.verticalSpace,
                                //* main body
                                SignUpForm(formKey: formKey),
                                12.w.verticalSpace,
                                //* bottom section
                                SizedBox(
                                  width: context.isMobileView
                                      ? double.maxFinite
                                      : context.screenWidth *
                                            0.8.flexClamp(null, 800),
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
                                        color: AppColors.primary.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          SignUpBottomSection(
                            onLoginTap: () {
                              context.pushReplacementNamed(
                                AppRoutes.loginScreen.name,
                              );
                            },
                            onSignUpTap: () {
                              deBouncer.run(() {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                provider.registerUser(context: context);
                              });
                            },
                            onContinueAsGuestTap: () {
                              LocaleStorageService.setIsFirstTime(false);
                              isGuest = true;
                              context.pushNamed(
                                kIsWeb
                                    ? WebRoutes.homeScreen.name
                                    : AppRoutes.homeScreen.name,
                              );
                            },
                          ),
                          30.w.verticalSpace,
                        ],
                      ),
                    ),
                    if (provider.isSignUpLoading) FullPageIndicator(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
