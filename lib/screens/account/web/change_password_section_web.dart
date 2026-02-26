import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';

class ChangePasswordSectionWeb extends StatefulWidget {
  const ChangePasswordSectionWeb({super.key});

  @override
  State<ChangePasswordSectionWeb> createState() =>
      _ChangePasswordSectionWebState();
}

class _ChangePasswordSectionWebState extends State<ChangePasswordSectionWeb> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sixteenResponsive = context.isDesktop ? 16.sp : 21.5.sp;
    final twelveResponsive = context.isDesktop ? 12.sp : 20.sp;

    final twentyTwoResponsive = context.isDesktop ? 22.sp : 30.sp;
    double fieldWidth = context.isDesktop ? 320.w : 380.w;
    return Consumer<AccountProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topBar(
                context: context,
                provider: provider,
                formKey: _formKey,
                twelveResponsive: twelveResponsive,
                sixteenResponsive: sixteenResponsive,
                responsiveIcon: twentyTwoResponsive,
              ),
              horizontalDivider(),
              if (context.isDesktop) 17.w.verticalSpace else 28.w.verticalSpace,
              //todo text fields
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Wrap(
                    spacing: 16.w,
                    runSpacing: 12.h,
                    children: [
                      SizedBox(
                        width: fieldWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5.h,
                          children: [
                            Text(
                              "Current Password",
                              style: semiBold(fontSize: sixteenResponsive),
                            ),
                            AppTextField(
                              controller: provider.currentPassCtr,
                              hintText: "Enter Current Password",
                              validator: (value) =>
                                  FieldValidators().password(value),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: fieldWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5.h,
                          children: [
                            Text(
                              "New Password",
                              style: semiBold(fontSize: sixteenResponsive),
                            ),
                            AppTextField(
                              controller: provider.newPassCtr,
                              hintText: "Enter New Password",
                              validator: (value) =>
                                  FieldValidators().password(value),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: fieldWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5.h,
                          children: [
                            Text(
                              "Confirm Password",
                              style: semiBold(fontSize: sixteenResponsive),
                            ),
                            AppTextField(
                              controller: provider.confirmPassCtr,
                              hintText: "Enter Confirm Password",
                              validator: (value) => FieldValidators().match(
                                value,
                                provider.newPassCtr.text.trim(),
                                "Confirm Password should match with a new Password",
                              ),
                              onSubmit: () {
                                provider.updatePassword(
                                  onSuccess: () {
                                    _formKey.currentState!.reset();
                                    AppToast.success(
                                      context: context,
                                      message: "Password updated successfully",
                                    );
                                  },
                                  onError: (error) {
                                    AppToast.error(
                                      context: context,
                                      message: "Failed to update password",
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppFilledButton(
                text: "Save",
                textStyle: semiBold(
                  fontSize: sixteenResponsive,
                  color: AppColors.white,
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    provider.updatePassword(
                      onSuccess: () {
                        AppToast.success(
                          context: context,
                          message: "Password updated successfully",
                        );
                      },
                      onError: (error) {
                        AppToast.error(
                          context: context,
                          message: "Failed to update password",
                        );
                      },
                    );
                  }
                },
                width: fieldWidth,
                margin: EdgeInsets.only(
                  top: context.isDesktop ? 24.w : 34.w,
                  left: 24.w,
                  right: 24.w,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: context.isDesktop ? 12.w : 16.w,
                  // horizontal: context.isDesktop ? 20.w : 40.w,
                ),
                child: (provider.isUpdatePasswordLoading)
                    ? webProgressIndicator(context)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget topBar({
    required BuildContext context,
    required AccountProvider provider,
    required double twelveResponsive,
    required double sixteenResponsive,
    required double responsiveIcon,
    required GlobalKey<FormState> formKey,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isDesktop ? 24.w : 30.w,
        vertical: context.isDesktop ? 11.w : 17.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OnMouseTap(
            onTap: () {
              provider.setIsShowChangePassword = !provider.showChangePassword;
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: responsiveIcon,
              color: AppColors.primary,
            ),
          ),
          (context.isDesktop) ? 13.w.horizontalSpace : 24.w.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Password",
                style: regular(
                  fontSize: context.isDesktop ? 24.sp : 30.sp,
                  fontFamily: AppFontFamily.secondary,
                  height: 1.4,
                ),
              ),
              Text(
                "Manage Your Password.",
                style: semiBold(
                  fontSize: twelveResponsive,
                  color: AppColors.greyColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          // Spacer(),
          // (provider.isEdit)
          //     ? TextButton(
          //         onPressed: () {
          //           formKey.currentState?.reset();
          //           provider.setIsEdit = !(provider.isEdit);
          //         },
          //
          //         child: Text(
          //           "Cancel",
          //           style: bold(fontSize: 16.sp, color: AppColors.primary),
          //         ),
          //       )
          //     : OnMouseTap(
          //         onTap: () {
          //           provider.setIsEdit = !(provider.isEdit);
          //         },
          //
          //         child: Row(
          //           spacing: context.isDesktop ? 5.w : 10.w,
          //           children: [
          //             SvgPicture.asset(
          //               AppAssets.edit,
          //               width: context.isDesktop ? 18.w : 22.w,
          //             ),
          //             Text("Edit", style: bold(fontSize: sixteenResponsive)),
          //           ],
          //         ),
          //       ),
        ],
      ),
    );
  }
}
