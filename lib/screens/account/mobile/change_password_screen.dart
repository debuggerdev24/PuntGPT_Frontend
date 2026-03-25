import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Column(
              children: [
                topBar(context),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.h),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          28.h.verticalSpace,

                          //todo ------------> Current Password
                          Text(
                            "Current Password",
                            style: semiBold(fontSize: 14.sp),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.currentPassCtr,
                            obscureText: provider.currentPassObscure,
                            hintText: "Enter Current Password",
                            textInputAction: TextInputAction.next,
                            trailingIcon: provider.currentPassObscure
                                ? AppAssets.hide
                                : AppAssets.show,
                            onTrailingIconTap: () {
                              provider.currentPassObscure =
                                  !provider.currentPassObscure;
                            },
                            validator: (value) =>
                                FieldValidators().password(value),
                          ),
                          //todo ------------> New Password
                          14.h.verticalSpace,
                          Text(
                            "New Password",
                            style: semiBold(fontSize: 14.sp),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.newPassCtr,
                            obscureText: provider.newPassObscure,
                            hintText: "Enter New Password",
                            textInputAction: TextInputAction.next,
                            trailingIcon: provider.newPassObscure
                                ? AppAssets.hide
                                : AppAssets.show,

                            onTrailingIconTap: () {
                              provider.newPassObscure =
                                  !provider.newPassObscure;
                            },
                            validator: (value) =>
                                FieldValidators().password(value),
                          ),

                          //todo ------------> Confirm Password
                          14.h.verticalSpace,
                          Text(
                            "Confirm Password",
                            style: semiBold(fontSize: 14.sp),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.confirmPassCtr,
                            obscureText: provider.confirmPassObscure,
                            hintText: "Re-enter New Password",
                            textInputAction: TextInputAction.done,
                            trailingIcon: provider.confirmPassObscure
                                ? AppAssets.hide
                                : AppAssets.show,

                            onTrailingIconTap: () {
                              provider.confirmPassObscure =
                                  !provider.confirmPassObscure;
                            },
                            validator: (value) => FieldValidators().match(
                              value,
                              provider.newPassCtr.text.trim(),
                              "Confirm Password should match with a new Password",
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: AlignmentGeometry.bottomCenter,
                            child: AppFilledButton(
                              text: "Save",
                              onTap: () {
                                deBouncer.run(() {
                                  if (_formKey.currentState!.validate()) {
                                    provider.updatePassword(
                                      onSuccess: () {
                                        AppToast.success(
                                          context: context,
                                          message:
                                              "Password updated successfully.",
                                        );
                                      },
                                      onError: (errorMsg) {
                                        AppToast.error(
                                          context: context,
                                          message: errorMsg,
                                        );
                                        Logger.error(errorMsg);
                                      },
                                    );
                                    return;
                                  }
                                });
                              },
                              margin: EdgeInsets.only(
                                bottom: 25.h,
                              ), // top: 200.h
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (provider.isUpdateProfileLoading) FullPageIndicator(),
          ],
        );
      },
    );
  }

  Widget topBar(BuildContext context) {
    return AppScreenTopBar(
      title: "Change Password",
      slogan: "Change Password for your account.",
      onBack: () => context.pop(),
    );
  }
}
