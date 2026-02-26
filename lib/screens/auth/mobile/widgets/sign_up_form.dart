import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/screens/auth/auth_constants.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  void _pickDob(BuildContext context, AuthProvider provider) async {
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
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Form(
          key: formKey,
          child: Column(
            spacing: 8.h,
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
              AppTextField(
                controller: provider.dobCtr,
                hintText: "Date of birth",
                readOnly: true,

                trailingIcon: AppAssets.arrowDown,
                // enabled: false,
                validator: (value) =>
                    FieldValidators().required(value, "Date of birth"),

                onTap: () => _pickDob(context, provider),
              ),
              AppTextFieldDropdown(
                items:
                    states, //List.generate(20, (index) => "State ${index + 1}"),
                hintText: 'State',
                onChange: (value) => provider.selectedState = value,
                selectedValue: provider.selectedState,
                validator: (value) =>
                    FieldValidators().required(value, "State"),
              ),
              AppTextField(
                controller: provider.emailCtr,
                hintText: "Email",
                validator: FieldValidators().email,
              ),

              AppTextField(
                keyboardType: TextInputType.number,
                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                controller: provider.phoneCtr,
                hintText: "Phone",
                validator: FieldValidators().mobileNumber,
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

          // SizedBox(
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
          //             Row(
          //               spacing: 24.w.flexClamp(20, 24),
          //               children: [
          //                 Expanded(
          //                   child: AppTextField(
          //                     controller: provider.dobCtr,
          //                     hintText: "Date of birth",
          //                     hintStyle: medium(
          //                       fontSize: 16.sp,
          //                       color: AppColors.primary.setOpacity(0.4),
          //                     ),
          //                     trailingIcon: AppAssets.arrowDown,
          //                     enabled: false,
          //                     validator: (value) => FieldValidators().required(
          //                       value,
          //                       "Date of birth",
          //                     ),
          //                     onTap: () => _pickDob(context, provider),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   child: AppTextFieldDropdown(
          //                     items: states,
          //                     hintText: 'State',
          //                     hintStyle: medium(
          //                       fontSize: 16.sp,
          //                       color: AppColors.primary.setOpacity(0.4),
          //                     ),
          //                     onChange: (value) =>
          //                         provider.selectedState = value,
          //                     selectedValue: provider.selectedState,
          //                     validator: (value) =>
          //                         FieldValidators().required(value, "State"),
          //                   ),
          //                 ),
          //               ],
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
