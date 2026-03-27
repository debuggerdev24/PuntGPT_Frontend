import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/auth/auth_constants.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Form(
          key: formKey,
          child: Column(
            spacing: 8.w,
            children: [
              AppTextField(
                controller: provider.firstNameCtr,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                hintText: "First Name",
                validator: (value) =>
                    FieldValidators().required(value, "First Name"),
              ),
              AppTextField(
                controller: provider.lastNameCtr,
                hintText: "Last Name",
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                validator: (value) =>
                    FieldValidators().required(value, "Last Name"),
              ),
              AppTextFieldDropdown(
                items: states, 
                hintText: 'State',
                onChange: (value) => provider.selectedState = value,
                selectedValue: provider.selectedState,
                validator: (value) =>
                    FieldValidators().required(value, "State"),
              ),
              AppTextField(
                controller: provider.addressLine1Ctr,
                hintText: "Address Line 1",
                validator: (value) =>
                    FieldValidators().required(value, "Address Line 1"),
              ),
              AppTextField(
                controller: provider.addressLine2Ctr,
                hintText: "Address Line 2",
                validator: (value) =>
                    FieldValidators().required(value, "Address Line 2"),
              ),
              AppTextField(
                controller: provider.suburbCtr,
                hintText: "Suburb",
                validator: (value) =>
                    FieldValidators().required(value, "Suburb"),
              ),
              AppTextField(
                controller: provider.postCodeCtr,
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                hintText: "Post Code",
                validator: (value) {
                  final r = FieldValidators().required(value, "Post Code");
                  if (r != null) return r;
                  return FieldValidators().lengthValidator(value, 4);
                },
              ),
              PhoneCountryField(provider: provider),
              AppTextField(
                controller: provider.emailCtr,
                hintText: "Email",
                validator: FieldValidators().email,
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

                  return FieldValidators().required(value, "Confirm Password");
                },
                trailingIcon: provider.showConfirmPass
                    ? AppAssets.hide
                    : AppAssets.show,
                onTrailingIconTap: () =>
                    provider.showConfirmPass = !provider.showConfirmPass,
              ),
            ],
          ),

          //         width: context.screenWidth * 0.6.flexClamp(null, 600),
          //         child: Column(
          //           spacing: 24.h,
          //           children: [
          //             Row(
          //               spacing: 24.w.flexClamp(20, 24),
          //               children: [
          //                 Expanded(
          //                   child: AppTextField(
          //                     controller: provider.firstNameCtr,
          //                     hintText: "First Name",
          //                     hintStyle: medium(
          //                       fontSize: 16.sp,
          //                       color: AppColors.primary.setOpacity(0.4),
          //                     ),
          //                     validator: (value) => FieldValidators().required(
          //                       value,
          //                       "First Name",
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   child: AppTextField(
          //                     controller: provider.lastNameCtr,
          //                     hintText: "Last Name",
          //                     hintStyle: medium(
          //                       fontSize: 16.sp,
          //                       color: AppColors.primary.setOpacity(0.4),
          //                     ),
          //                     validator: (value) => FieldValidators().required(
          //                       value,
          //                       "Last Name",
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             AppTextFieldDropdown(
          //               items: states,
          //               hintText: 'State',
          //               hintStyle: medium(
          //                 fontSize: 16.sp,
          //                 color: AppColors.primary.setOpacity(0.4),
          //               ),
          //               onChange: (value) => provider.selectedState = value,
          //               selectedValue: provider.selectedState,
          //               validator: (value) =>
          //                   FieldValidators().required(value, "State"),
          //             ),
          //             Row(
          //               spacing: 24.w.flexClamp(20, 24),
          //               children: [
          //                 Expanded(
          //                   child: AppTextField(
          //                     controller: provider.emailCtr,
          //                     hintText: "Email",
          //                     hintStyle: medium(
          //                       fontSize: 16.sp,
          //                       color: AppColors.primary.setOpacity(0.4),
          //                     ),
          //                     validator: FieldValidators().email,
          //                   ),
          //                 ),
          //                 Expanded(
          //                   child: AppTextField(
          //                     controller: provider.phoneCtr,
          //                     hintText: "Phone",
          //                     hintStyle: medium(
          //                       fontSize: 16.sp,
          //                       color: AppColors.primary.setOpacity(0.4),
          //                     ),
          //                     validator: FieldValidators().mobileNumber,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             AppTextField(
          //               controller: provider.passwordCtr,
          //               hintText: "Password",
          //               hintStyle: medium(
          //                 fontSize: 16.sp,
          //                 color: AppColors.primary.setOpacity(0.4),
          //               ),
          //               obscureText: provider.showSignUpPass,
          //               validator: FieldValidators().password,
          //               trailingIcon: provider.showSignUpPass
          //                   ? AppAssets.hide
          //                   : AppAssets.show,
          //               onTrailingIconTap: () =>
          //                   provider.showSignUpPass = !provider.showSignUpPass,
          //             ),
          //           ],
          //         ),
          //       ),
        );
      },
    );
  }
}
