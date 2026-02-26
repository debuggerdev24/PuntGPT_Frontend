import 'dart:developer';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/auth/auth_constants.dart';

class WebSignUpForm extends StatelessWidget {
  const WebSignUpForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  void _pickBob(BuildContext context, AuthProvider provider) async {
    final DateTime today = DateTime.now();

    final DateTime lastDate = DateTime(today.year, today.month, today.day);
    final DateTime firstDate = DateTime(1900);

    DateTime? selectedDate = await showAppDatePicker(
      context,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      provider.dobCtr.text = DateFormatter.registerApiFormate(selectedDate);
    }
  }

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
                      AppTextField(
                        controller: provider.dobCtr,
                        hintText: "Date of birth",
                        readOnly: true,
                        trailingIcon: AppAssets.arrowDown,
                        trailingIconWidth: 15,
                        validator: (value) =>
                            FieldValidators().required(value, "Date of birth"),
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                        onTap: () {
                          _pickBob(context, provider);
                        },
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
                        controller: provider.emailCtr,
                        hintText: "Email",
                        validator: FieldValidators().email,
                        hintStyle: medium(
                          fontSize: (context.isBrowserMobile) ? 28.sp : 16.sp,
                          color: AppColors.primary.setOpacity(0.4),
                        ),
                      ),
                      AppTextField(
                        keyboardType: TextInputType.number,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: provider.phoneCtr,
                        hintText: "Phone",
                        validator: FieldValidators().mobileNumber,
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
                        Row(
                          spacing: 24.w.flexClamp(20, 24),
                          children: [
                            Expanded(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,

                                child: AppTextField(
                                  controller: provider.dobCtr,
                                  hintText: "Date of birth",
                                  readOnly: true,
                                  hintStyle: medium(
                                    fontSize: (context.isTablet)
                                        ? 22.sp
                                        : 16.sp,
                                    color: AppColors.primary.setOpacity(0.4),
                                  ),
                                  trailingIcon: AppAssets.arrowDown,
                                  validator: (value) => FieldValidators()
                                      .required(value, "Date of birth"),
                                  onTap: () => _pickBob(context, provider),
                                ),
                              ),
                            ),
                            Expanded(
                              child: AppTextFieldDropdown(
                                items: states,
                                hintText: 'State',
                                hintStyle: medium(
                                  fontSize: (Responsive.isTablet(context))
                                      ? 22.sp
                                      : 16.sp,

                                  color: AppColors.primary.setOpacity(0.4),
                                ),
                                onChange: (value) =>
                                    provider.selectedState = value,
                                selectedValue: provider.selectedState,
                                validator: (value) =>
                                    FieldValidators().required(value, "State"),
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
                              child: AppTextField(
                                controller: provider.phoneCtr,
                                hintText: "Phone",
                                hintStyle: medium(
                                  fontSize: (Responsive.isTablet(context))
                                      ? 22.sp
                                      : 16.sp,

                                  color: AppColors.primary.setOpacity(0.4),
                                ),
                                validator: FieldValidators().mobileNumber,
                              ),
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
