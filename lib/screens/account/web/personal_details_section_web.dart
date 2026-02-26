import 'package:flutter_svg/svg.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';

class PersonalDetailsSectionWeb extends StatelessWidget {
  const PersonalDetailsSectionWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final sixteenResponsive = context.isDesktop ? 16.sp : 21.5.sp;
    final twelveResponsive = context.isDesktop ? 12.sp : 20.sp;
    // final fourteenResponsive = context.isDesktop
    //     ? 14.sp
    //     : context.isTablet
    //     ? 22.sp
    //     : (kIsWeb)
    //     ? 26.sp
    //     : 14.sp;

    final twentyTwoResponsive = context.isDesktop
        ? 22.sp
        : context.isTablet
        ? 30.sp
        : context.isBrowserMobile
        ? 38.sp
        : 22.sp;
    double fieldWidth = context.isDesktop ? 320.w : 380.w;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Consumer<AccountProvider>(
      builder: (context, provider, child) {
        bool readOnly = (provider.isEdit) ? false : true;
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.isDesktop ? 24.w : 30.w,
                  vertical: context.isDesktop ? 11.w : 17.w,
                ),
                child: topBar(
                  context: context,
                  provider: provider,
                  formKey: formKey,
                  twelveResponsive: twelveResponsive,
                  sixteenResponsive: sixteenResponsive,
                  responsiveIcon: twentyTwoResponsive,
                ),
              ),
              horizontalDivider(),
              if (context.isDesktop) 17.w.verticalSpace else 28.w.verticalSpace,

              //todo text fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: formKey,
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
                              "Name",
                              style: semiBold(fontSize: sixteenResponsive),
                            ),
                            AppTextField(
                              controller: provider.nameCtr,
                              hintText: "Enter your Name",
                              validator: (value) =>
                                  FieldValidators().name(value, "Name"),
                              readOnly: readOnly,
                              hintStyle: semiBold(
                                color: AppColors.primary.withValues(alpha: 0.7),
                                fontSize: context.isDesktop ? 14.sp : 20.sp,
                              ),
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
                              "Email",

                              style: semiBold(fontSize: sixteenResponsive),
                            ),

                            AppTextField(
                              readOnly: readOnly,
                              controller: provider.emailCtr,
                              validator: FieldValidators().email,
                              hintText: "Enter your Email",
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
                              "Phone",
                              style: semiBold(fontSize: sixteenResponsive),
                            ),
                            AppTextField(
                              readOnly: readOnly,
                              validator: (value) => FieldValidators().required(
                                value,
                                "Phone Number",
                              ),
                              controller: provider.phoneCtr,
                              hintText: "Enter your Phone Number",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppOutlinedButton(
                margin: EdgeInsets.only(
                  top: context.isDesktop ? 24.w : 34.w,
                  left: 24.w,
                  right: 24.w,
                ),
                text: "Change Password",
                onTap: () {
                  provider.setIsShowChangePassword =
                      !provider.showChangePassword;
                },
                width: fieldWidth,
                padding: EdgeInsets.symmetric(
                  vertical: context.isDesktop ? 12.w : 16.w,
                ),
                textStyle: semiBold(fontSize: sixteenResponsive),
              ),
              AppFilledButton(
                margin: EdgeInsets.only(
                  top: context.isDesktop ? 24.w : 34.w,
                  left: 24.w,
                  right: 24.w,
                ),
                width: fieldWidth,
                text: "Save",
                onTap: () {
                  deBouncer.run(() {
                    if (formKey.currentState!.validate()) {
                      provider.updateProfile(
                        onSuccess: () {
                          AppToast.success(
                            context: context,
                            message: "Profile updated successfully",
                          );
                        },
                        onNoChanges: () {
                          AppToast.info(
                            context: context,
                            message: "No changes found.",
                          );
                        },
                        onFailed: (error) {
                          AppToast.error(context: context, message: error);
                        },
                      );
                    }
                  });
                },
                textStyle: semiBold(
                  fontSize: sixteenResponsive,
                  color: AppColors.white,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: context.isDesktop ? 12.w : 16.5.w,
                ),
                child: (provider.isUpdateProfileLoading)
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Details",
              style: regular(
                fontSize: context.isDesktop ? 24.sp : 30.sp,
                fontFamily: AppFontFamily.secondary,
                height: 1.35,
              ),
            ),
            Text(
              "Manage your name, email, etc.",
              style: semiBold(
                fontSize: twelveResponsive,
                color: AppColors.greyColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        Spacer(),
        (provider.isEdit)
            ? TextButton(
                onPressed: () {
                  formKey.currentState?.reset();
                  provider.setIsEdit = !(provider.isEdit);
                },

                child: Text(
                  "Cancel",
                  style: bold(
                    fontSize: sixteenResponsive,
                    color: AppColors.primary,
                  ),
                ),
              )
            : OnMouseTap(
                onTap: () {
                  provider.setIsEdit = !(provider.isEdit);
                },

                child: Row(
                  spacing: context.isDesktop ? 5.w : 10.w,
                  children: [
                    SvgPicture.asset(
                      AppAssets.edit,
                      width: context.isDesktop ? 18.w : 22.w,
                    ),
                    Text("Edit", style: bold(fontSize: sixteenResponsive)),
                  ],
                ),
              ),
      ],
    );
  }
}
