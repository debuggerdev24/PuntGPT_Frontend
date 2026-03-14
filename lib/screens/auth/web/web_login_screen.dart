import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/web_top_section.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class WebLoginScreen extends StatelessWidget {
  const WebLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fourteenResponsive = context.isDesktop
        ? 14.sp
        : context.isTablet
        ? 22.5.sp
        : (context.isBrowserMobile)
        ? 28.sp
        : 14.sp;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final width =
        context.screenWidth *
        ((context.isDesktop)
            ? 0.35
            : (context.isTablet)
            ? 0.45
            : (context.isBrowserMobile)
            ? 0.55
            : context.screenWidth);
    return Scaffold(
      appBar: WebTopSection(),
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: (context.isBrowserMobile) ? 0 : 25.w,
                    ),
                    child: SizedBox(
                      width: width,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            80.h.verticalSpace,
                            (context.isBrowserMobile)
                                ? ImageWidget(
                                    path: AppAssets.splashWebLogo,
                                    type: ImageType.asset,
                                    width: context.isDesktop
                                        ? 375.w
                                        : context.isTablet
                                        ? 550.w
                                        : 750.w,
                                  )
                                : ImageWidget(
                                    path: AppAssets.splashWebLogo,
                                    type: ImageType.asset,
                                    width: context.isDesktop
                                        ? 375.w
                                        : context.isTablet
                                        ? 550.w
                                        : 375.w,
                                  ),
                            18.h.verticalSpace,
                            Text(
                              "'@PuntGPT' the talking from guide",
                              style: regular(
                                fontSize:
                                    //.responsiveTextSize(),
                                    (context.isDesktop)
                                    ? 24.sp
                                    : (context.isTablet)
                                    ? 34.sp
                                    : (context.isBrowserMobile)
                                    ? 46.sp
                                    : 20.sp,
                                fontFamily: AppFontFamily.secondary,
                              ),
                            ),
                            60.h.verticalSpace,
                            AppTextField(
                              controller: provider.loginEmailCtr,
                              validator: FieldValidators().email,
                              hintText: "Email",
                              // hintStyle: medium(
                              //   fontSize: context.isDesktop
                              //       ? 16.sp
                              //       : context.isTablet
                              //       ? 26.sp
                              //       : (kIsWeb)
                              //       ? 30.sp
                              //       : 16.sp,
                              //   color: AppColors.primary.setOpacity(0.55),
                              // ),
                              onSubmit: () {
                                if (formKey.currentState!.validate()) {
                                  provider.loginUser(context: context);
                                  return;
                                }
                              },
                            ),
                            16.h.verticalSpace,
                            AppTextField(
                              controller: provider.loginPasswordCtr,
                              hintText: "Password",
                              validator: (value) {
                                return FieldValidators().required(
                                  value,
                                  "Password",
                                );
                              },
                              onSubmit: () {
                                if (formKey.currentState!.validate()) {
                                  provider.loginUser(context: context);
                                  return;
                                }
                              },
                              trailingIcon: provider.showLoginPass
                                  ? AppAssets.hide
                                  : AppAssets.show,
                              onTrailingIconTap: () => provider.showLoginPass =
                                  !provider.showLoginPass,
                              // hintStyle: medium(
                              //   fontSize: context.isDesktop
                              //       ? 16.sp
                              //       : context.isTablet
                              //       ? 26.sp
                              //       : (kIsWeb)
                              //       ? 30.sp
                              //       : 16.sp,
                              //
                              //   color: AppColors.primary.setOpacity(0.4),
                              // ),
                            ),
                            12.h.verticalSpace,
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
                                  style: bold(fontSize: fourteenResponsive),
                                ),
                              ),
                            ),
                            40.h.verticalSpace,
                            AppFilledButton(
                              text: "Login",
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  provider.loginUser(context: context);
                                }
                              },
                              textStyle: semiBold(
                                fontSize: context.isDesktop
                                    ? 16.sp
                                    : context.isTablet
                                    ? 26.sp
                                    : (context.isBrowserMobile)
                                    ? 30.sp
                                    : 16.sp,
                                color: AppColors.white,
                              ),
                              child:
                                  (provider.isLoginLoading &&
                                      !context.isBrowserMobile)
                                  ? webProgressIndicator(context)
                                  : null,
                            ),
                            18.w.verticalSpace,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "New to PuntGPT? ",
                                  style: medium(
                                    fontSize: context.isDesktop
                                        ? 14.sp
                                        : context.isTablet
                                        ? 20.sp
                                        : (context.isBrowserMobile)
                                        ? 22.sp
                                        : 14.sp,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                                OnMouseTap(
                                  onTap: () {
                                    context.pop();
                                  },
                                  child: Text(
                                    " Sign up",
                                    style: bold(
                                      fontSize: context.isDesktop
                                          ? 14.sp
                                          : context.isTablet
                                          ? 20.sp
                                          : (context.isBrowserMobile)
                                          ? 22.sp
                                          : 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            80.h.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
