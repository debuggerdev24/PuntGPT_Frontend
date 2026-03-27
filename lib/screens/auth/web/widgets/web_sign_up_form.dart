import 'dart:developer';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/auth/auth_constants.dart';

class WebSignUpForm extends StatelessWidget {
  const WebSignUpForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    log("is Mobile ${Responsive.isMobileWeb(context)}");
    log("is Desktop ${Responsive.isDesktop(context)}");
    log("is Tablet ${Responsive.isTablet(context)}");
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Form(
            key: formKey,
            child: context.isPhysicalMobile || context.isBrowserMobile
                ? Column(
                    spacing: 8.h,
                    children: [
                      AppTextField(
                        controller: provider.firstNameCtr,
                        hintText: "First Name",
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ),
                        ],
                        validator: (value) =>
                            FieldValidators().required(value, "First Name"),
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        controller: provider.lastNameCtr,
                        hintText: "Last Name",
                        validator: (value) =>
                            FieldValidators().required(value, "Last Name"),
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextFieldDropdown(
                        items: List.generate(
                          20,
                          (index) => "State ${index + 1}",
                        ),
                        hintText: 'State',
                        onChange: (value) => provider.selectedState = value,
                        selectedValue: provider.selectedState,
                        validator: (value) =>
                            FieldValidators().required(value, "State"),
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        controller: provider.addressLine1Ctr,
                        hintText: "Address Line 1",
                        validator: (value) =>
                            FieldValidators().required(value, "Address Line 1"),
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        controller: provider.addressLine2Ctr,
                        hintText: "Address Line 2",
                        validator: (value) =>
                            FieldValidators().required(value, "Address Line 2"),
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        controller: provider.suburbCtr,
                        hintText: "Suburb",
                        validator: (value) =>
                            FieldValidators().required(value, "Suburb"),
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        controller: provider.postCodeCtr,
                        hintText: "Post Code",
                        keyboardType: TextInputType.number,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (value) {
                          final r =
                              FieldValidators().required(value, "Post Code");
                          if (r != null) return r;
                          return FieldValidators().lengthValidator(value, 4);
                        },
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      PhoneCountryField(provider: provider),
                      AppTextField(
                        controller: provider.emailCtr,
                        hintText: "Email",
                        validator: FieldValidators().email,
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        controller: provider.passwordCtr,
                        hintText: "Password",
                        obscureText: provider.showSignUpPass,
                        validator: FieldValidators().password,
                        trailingIcon: provider.showSignUpPass
                            ? AppAssets.hide
                            : AppAssets.show,
                        onTrailingIconTap: () =>
                            provider.showSignUpPass = !provider.showSignUpPass,

                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        controller: provider.confirmPasswordCtr,
                        hintText: "Confirm Password",
                        obscureText: provider.showConfirmPass,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (provider.passwordCtr.text.trim() !=
                                provider.confirmPasswordCtr.text.trim()) {
                              return "Confirm Password should match with Original Password!";
                            }
                          }

                          return FieldValidators().required(
                            value,
                            "Confirm Password",
                          );
                        },
                        trailingIcon: provider.showConfirmPass
                            ? AppAssets.hide
                            : AppAssets.show,
                        onTrailingIconTap: () => provider.showConfirmPass =
                            !provider.showConfirmPass,
                      ),
                    ],
                  )
                : SizedBox(
                    width: context.screenWidth * 0.6.flexClamp(null, 600),
                    child: Column(
                      spacing: 24.h,
                      children: [
                        Row(
                          spacing: 24.w.flexClamp(20, 24),
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: provider.firstNameCtr,
                                hintText: "First Name",
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                hintStyle: medium(
                                  fontSize: context.isTablet ? 22.sp : 16.sp,
                                  color: AppColors.primary.setOpacity(0.4),
                                ),
                                validator: (value) => FieldValidators()
                                    .required(value, "First Name"),
                              ),
                            ),
                            Expanded(
                              child: AppTextField(
                                controller: provider.lastNameCtr,
                                hintText: "Last Name",
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                hintStyle: medium(
                                  fontSize: context.isTablet ? 22.sp : 16.sp,
                                  color: AppColors.primary.setOpacity(0.4),
                                ),
                                validator: (value) => FieldValidators()
                                    .required(value, "Last Name"),
                              ),
                            ),
                          ],
                        ),
                        AppTextFieldDropdown(
                          items: states,
                          hintText: 'State',
                          hintStyle: medium(
                            fontSize: (Responsive.isTablet(context))
                                ? 22.sp
                                : 16.sp,
                            color: AppColors.primary.setOpacity(0.4),
                          ),
                          onChange: (value) => provider.selectedState = value,
                          selectedValue: provider.selectedState,
                          validator: (value) =>
                              FieldValidators().required(value, "State"),
                        ),
                        AppTextField(
                          controller: provider.addressLine1Ctr,
                          hintText: "Address Line 1",
                          hintStyle: medium(
                            fontSize: (Responsive.isTablet(context))
                                ? 22.sp
                                : 16.sp,
                            color: AppColors.primary.setOpacity(0.4),
                          ),
                          validator: (value) => FieldValidators()
                              .required(value, "Address Line 1"),
                        ),
                        AppTextField(
                          controller: provider.addressLine2Ctr,
                          hintText: "Address Line 2",
                          hintStyle: medium(
                            fontSize: (Responsive.isTablet(context))
                                ? 22.sp
                                : 16.sp,
                            color: AppColors.primary.setOpacity(0.4),
                          ),
                          validator: (value) => FieldValidators()
                              .required(value, "Address Line 2"),
                        ),
                        Row(
                          spacing: 24.w.flexClamp(20, 24),
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: provider.suburbCtr,
                                hintText: "Suburb",
                                hintStyle: medium(
                                  fontSize: (Responsive.isTablet(context))
                                      ? 22.sp
                                      : 16.sp,
                                  color: AppColors.primary.setOpacity(0.4),
                                ),
                                validator: (value) =>
                                    FieldValidators().required(value, "Suburb"),
                              ),
                            ),
                            Expanded(
                              child: AppTextField(
                                controller: provider.postCodeCtr,
                                hintText: "Post Code",
                                keyboardType: TextInputType.number,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                hintStyle: medium(
                                  fontSize: (Responsive.isTablet(context))
                                      ? 22.sp
                                      : 16.sp,
                                  color: AppColors.primary.setOpacity(0.4),
                                ),
                                validator: (value) {
                                  final r = FieldValidators()
                                      .required(value, "Post Code");
                                  if (r != null) return r;
                                  return FieldValidators().lengthValidator(
                                    value,
                                    4,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 24.w.flexClamp(20, 24),
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: provider.emailCtr,
                                hintText: "Email",
                                hintStyle: medium(
                                  fontSize: (Responsive.isTablet(context))
                                      ? 22.sp
                                      : 16.sp,

                                  color: AppColors.primary.setOpacity(0.4),
                                ),
                                validator: FieldValidators().email,
                              ),
                            ),
                            Expanded(
                              child: PhoneCountryField(provider: provider),
                            ),
                          ],
                        ),
                        AppTextField(
                          controller: provider.passwordCtr,
                          hintText: "Password",
                          hintStyle: medium(
                            fontSize: (Responsive.isTablet(context))
                                ? 22.sp
                                : 16.sp,

                            color: AppColors.primary.setOpacity(0.4),
                          ),
                          obscureText: provider.showSignUpPass,
                          validator: FieldValidators().password,
                          trailingIcon: provider.showSignUpPass
                              ? AppAssets.hide
                              : AppAssets.show,
                          onTrailingIconTap: () => provider.showSignUpPass =
                              !provider.showSignUpPass,
                        ),
                        AppTextField(
                          controller: provider.confirmPasswordCtr,
                          hintText: "Confirm Password",
                          hintStyle: medium(
                            fontSize: (Responsive.isTablet(context))
                                ? 22.sp
                                : 16.sp,
                            color: AppColors.primary.setOpacity(0.4),
                          ),
                          obscureText: provider.showConfirmPass,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (provider.passwordCtr.text.trim() !=
                                  provider.confirmPasswordCtr.text.trim()) {
                                return "Confirm Password should match with Original Password!";
                              }
                            }

                            return FieldValidators().required(
                              value,
                              "Confirm Password",
                            );
                          },
                          trailingIcon: provider.showConfirmPass
                              ? AppAssets.hide
                              : AppAssets.show,
                          onTrailingIconTap: () => provider.showConfirmPass =
                              !provider.showConfirmPass,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
